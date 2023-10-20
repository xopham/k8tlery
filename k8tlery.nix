{ pkgs ? import <nixpkgs> {} }:

let
  # fetch and install binaries from urls
  fetchAndInstallBinary = { url, sha256, name, no_sc }: pkgs.stdenv.mkDerivation rec {
    pname = name;
    version = "x";
    src = pkgs.fetchurl {
      url = url;
      sha256 = sha256;
    };
    nsc = no_sc;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      tar xf $src --strip-components=$nsc -C $out/bin/
    '';
  };

  # fetch python projects (needs aliasing and manual installation of 'requirements' below)
  fetchAndInstallScript = { url, rev, sha256, name }: pkgs.stdenv.mkDerivation rec {
    pname = name;
    version = "x";
    src = pkgs.fetchgit {
      url = url;
      rev = rev;
      sha256 = sha256;
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/code
      cp -r $src/* $out/code
    '';
  };

  # List of binaries to fetch and install
  # get sha via: wget -q -O - ${url} | sha256sum | awk '{print $1}'
  customTools = {
    peirates = {
      name = "peirates";
      url = "https://github.com/inguardians/peirates/releases/download/v1.1.13/peirates-linux-amd64.tar.xz";
      sha256 = "49c8637fbdea7f891e4aa993559f177fdd51ad553d6d810a748c715ed713d80d";
      no_sc = 1;
    };
    crictl = {
      name = "crictl";
      url = "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz";
      sha256 = "8dc78774f7cbeaf787994d386eec663f0a3cf24de1ea4893598096cb39ef2508";
      no_sc = 0;
    };
    trufflehog = {
      name = "trufflehog";
      url = "https://github.com/trufflesecurity/trufflehog/releases/download/v3.56.1/trufflehog_3.56.1_linux_amd64.tar.gz";
      sha256 = "1716d32e6896cffda946e4cb358ca64b82a85ca980f851717669052957f04a87";
      no_sc = 0;
    };
    # Add more tools as needed
  };

  # Function to create derivations for custom tools
  makeCustomTool = name: toolConfig: fetchAndInstallBinary toolConfig;

  # Derivation set for custom tools
  customToolDerivations = builtins.mapAttrs makeCustomTool customTools;

  # List of script tools to fetch and install
  # * get sha by running nix-shell with empty sha256 value and copy from nix output
  # * since these are scripts you need to create aliases in mkShell below in case you want simple access
  scriptTools = {
    kubiscan = {
      name = "kubiscan";
      url = "https://github.com/cyberark/KubiScan";
      rev = "bc9cdf246ec36216eda38e812fffaff97fb94041";
      sha256 = "KzfTGw1HXacgLuCJaM9ls0ObH77fRle8jEz9JM29iKM=";
    };
    docker_bench = {
      name = "docker_bench";
      url = "https://github.com/docker/docker-bench-security";
      rev = "b7a5284ce47cfa0a23c1704d86060a8ec7c8e88b";
      sha256 = "fa3fkweDbwdk37p+8YI19YH3PKJkxMqvhVjMkZ/SGVQ=";
    };
    # Add more tools as needed
  };

  # Function to create derivations for python tools
  makeScriptTool = name: toolConfig: fetchAndInstallScript toolConfig;

  # Derivation set for python tools
  customScriptDerivations = builtins.mapAttrs makeScriptTool scriptTools;
in



pkgs.mkShell {
	buildInputs = [
		# basics
		pkgs.vim
    pkgs.jq
    pkgs.yq
		pkgs.findutils
		pkgs.tree
    pkgs.age
		(pkgs.python311.withPackages(ps: with ps; [kubernetes ptable]))

		# general security tooling
		pkgs.nmap

		# k8s/ctr tooling
		pkgs.trivy
		pkgs.kube-bench
		pkgs.syft
		pkgs.grype
		pkgs.checkov
    pkgs.dive
		pkgs.kubeaudit
		pkgs.cosign
		pkgs.kdigger
		pkgs.kubectl
		pkgs.docker
    pkgs.docker-compose
    pkgs.podman
    pkgs.k9s
    pkgs.crane
    pkgs.conftest
    pkgs.kubeshark
	] ++ (builtins.attrValues customToolDerivations) ++ (builtins.attrValues customScriptDerivations);
	shellHook = ''
	  alias k="kubectl"
	  alias ll="ls -la"
    kubiscanPath="/nix/store/$(ls -t /nix/store/ | grep "kubiscan-x$" | head -1)"
    alias kubiscan="python3.11 $kubiscanPath/code/KubiScan.py"
    docker_bench="/nix/store/$(ls -t /nix/store/ | grep "docker_bench-x$" | head -1)"
    alias docker_bench="$docker_bench"
    # Function to list the contents of a specific file from a Docker image layer
    layer_list() {
        # Input parameters
        local image="$1"  # Docker image name via `docker save -o image.tar IMAGE:TAG`
        local id="$2"     # Layer ID, e.g. via 'dive'
        local file="$3"   # File to list

        # Check if all parameters are provided
        if [[ -z "$image" || -z "$id" || -z "$file" ]]; then
            echo "Error: Missing input parameters."
            echo "Usage: layer_list <image> <id> <file>"
            echo "  <image>: Docker image name"
            echo "  <id>: Layer ID in the Docker image"
            echo "  <file>: Name of the file to list from the specified layer"
            return 1
        fi

        # List the contents of the file from the specified layer of the Docker image
        tar -Oxf "$image" "$id/layer.tar" | tar tvf - "$file"
    }
    # Function to extract a specific file from a Docker image layer
    layer_extract() {
        # Input parameters
        local image="$1"  # Docker image tar via `docker save -o image.tar IMAGE:TAG`
        local id="$2"     # Layer ID, e.g. via dive
        local file="$3"   # File to extract (reference inside layer, no leading '/')

        # Check if all parameters are provided
        if [[ -z "$image" || -z "$id" || -z "$file" ]]; then
            echo "Error: Missing input parameters."
            echo "Usage: layer_extract <image> <id> <file>"
            echo "  <image>: Docker image name"
            echo "  <id>: Layer ID in the Docker image"
            echo "  <file>: Name of the file to extract from the specified layer"
            return 1
        fi

        # Extract the file from the specified layer of the Docker image
        tar -Oxf "$image" "$id/layer.tar" | tar xvf - "$file"
    }


	'';
}
