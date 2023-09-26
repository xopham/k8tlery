# k8tlery

Dissect container images, container runtimes, container orchestrators.

## inventory

| tool          | scope         | description   |
| ------------- | ------------- | ------------- |
| [trivy](https://github.com/aquasecurity/trivy) |  | Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more. |
| [syft](https://github.com/anchore/syft) |  | CLI tool and library for generating a Software Bill of Materials from container images and filesystems. |
| [grype](https://github.com/anchore/grype) |  | A vulnerability scanner for container images and filesystems. |
| [tool](url) |  |  |
| [tool](url) |  |  |
| [tool](url) |  |  |
| [tool](url) |  |  |
| [tool](url) |  |  |
| [tool](url) |  |  |

### config scanner

* trivy

### container scanner

* trivy
* grype
* syft

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
