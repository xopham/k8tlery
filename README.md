# k8tlery

Dissect container images, container runtimes, container orchestrators.

## inventory

| tool          | scope         | description   |
| ------------- | ------------- | ------------- |
| [trivy](https://github.com/aquasecurity/trivy) |  | Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more. |
| [syft](https://github.com/anchore/syft) |  | CLI tool and library for generating a Software Bill of Materials from container images and filesystems. |
| [grype](https://github.com/anchore/grype) |  | A vulnerability scanner for container images and filesystems. |
| [kube-bench](https://github.com/aquasecurity/kube-bench) |  | Checks whether Kubernetes is deployed according to security best practices as defined in the CIS Kubernetes Benchmark. |
| [checkov](https://github.com/bridgecrewio/checkov) |  | Prevent cloud misconfigurations and find vulnerabilities during build-time in infrastructure as code, container images and open source packages with Checkov by Bridgecrew. |
| [kubeaudit](https://github.com/Shopify/kubeaudit) |  | kubeaudit helps you audit your Kubernetes clusters against common security controls. |
| [cosign](https://github.com/sigstore/cosign) |  | Container Signing. |
| [kdigger](https://github.com/quarkslab/kdigger) |  | Kubernetes focused container assessment and context discovery tool for penetration testing. |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/) |  | Kubernetes provides a command line tool for communicating with a Kubernetes cluster's control plane, using the Kubernetes API. |
| [docker](https://github.com/docker/cli) |  | Command line interface for interacting with docker container images. |
| [crictl](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md) |  | CLI and validation tools for Kubelet Container Runtime Interface (CRI). |
| [KubiScan](https://github.com/cyberark/KubiScan) |  | A tool to scan Kubernetes cluster for risky permissions. |
| [Docker Bench Security](https://github.com/docker/docker-bench-security) |  | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker containers in production. |
| [peirates](https://github.com/inguardians/peirates) |  | Peirates, a Kubernetes penetration tool, enables an attacker to escalate privilege and pivot through a Kubernetes cluster. It automates known techniques to steal and collect service account tokens, secrets, obtain further code execution, and gain control of the cluster. |
| [TruffleHog](https://github.com/trufflesecurity/trufflehog) |  | Find and verify credentials. |
| [Popeye](https://github.com/derailed/popeye) |  | A Kubernetes cluster resource sanitizer. |
| [k9s](https://github.com/derailed/k9s) |  | Kubernetes CLI To Manage Your Clusters In Style. |
| [Hadolint](https://github.com/hadolint/hadolint) |  | Dockerfile linter, validate inline bash, written in Haskell. |
| [Conftest](https://github.com/open-policy-agent/conftest) |  | Write tests against structured configuration data using the Open Policy Agent Rego query language. |
| [audit2rbac](https://github.com/liggitt/audit2rbac) |  | Autogenerate RBAC policies based on Kubernetes audit logs. |
| [kubeshark](https://github.com/kubeshark/kubeshark) |  | The API traffic analyzer for Kubernetes providing real-time K8s protocol-level visibility, capturing and monitoring all traffic and payloads going in, out and across containers, pods, nodes and clusters. Inspired by Wireshark, purposely built for Kubernetes. |
| [hardeneks](https://github.com/aws-samples/hardeneks) |  | Runs checks to see if an EKS cluster follows EKS Best Practices. |
| [amicontained](https://github.com/genuinetools/amicontained) |  | Container introspection tool. Find out what container runtime is being used as well as features available. |
| [kubesec](https://github.com/controlplaneio/kubesec) |  | Security risk analysis for Kubernetes resources. |
| [kubectl-who-can](https://github.com/aquasecurity/kubectl-who-can) |  | Show who has RBAC permissions to perform actions on different resources in Kubernetes. |
| [etcdctl](https://github.com/etcd-io/etcd/tree/main/etcdctl) |  | etcdctl is a command line client for etcd. |
| [gitleaks](https://github.com/gitleaks/gitleaks) |  | Gitleaks is a SAST tool for detecting and preventing hardcoded secrets like passwords, api keys, and tokens in git repos. Gitleaks is an easy-to-use, all-in-one solution for detecting secrets, past or present, in your code. |
| [kubeletctl](https://github.com/cyberark/kubeletctl) |  | Kubeletctl is a command line tool that implement kubelet's API. Part of kubelet's API is documented but most of it is not. This tool covers all the documented and undocumented APIs. |
| [kubehunter](https://github.com/aquasecurity/kube-hunter) |  | Hunt for security weaknesses in Kubernetes clusters. |

## usage

### nix-shell

```bash
nix-shell k8tlery.nix
```

### docker

```bash
docker -it --rm ghcr.io/xopham/k8tlery:<tag>
```

### cluster

```bash
kubectl apply -f k8tlery.yaml
#or
kubectl apply -f k8tlery-fullaccess.yaml
```

```bash
kubectl exec -it k8tlery -- bash
```
