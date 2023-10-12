# Platform - Core K8S Ops Workspaces

## Introduction

This is a general guide on contributing or updating declarative configuration for use by the deployment operator in the Hobsons Kubernetes Platform.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL"
in this document are to be interpreted as described in RFC 2119.

## Build - Deploy Platform

This project uses GitHub Actions to test and validate PRs, and verify changes to this repository.
The cluster itself contain a [CNCF fluxcd/flux](https://github.com/fluxcd/flux) operator in each namespace monitoring this repository for managed changes.
Any CI tooling around this project MUST NOT be given direct access to manipulate the cluster state.

## Project Layout

- Each operator workspace MUST live in its own subdirectory of this monorepo.
- Each operator workspace MUST be an independently managed namespace scoped operator
- This repository MAY manage workspaces in more than one **sandbox** cluster
- GitHub deployment keys MUST be provisioned for each unique operator in a cluster
- Workspace (e.g. `sandbox`) MAY be 1:Many potential kubernetes namespaces to which the operator can deploy (e.g. `ops` and `kube-system`),
  but each kubernetes namespace MUST have at most 1 operator running in it
- Restricting the operator permissions to a specific namespace MUST be done via kubernetes RBAC

Sample kubernetes manifest layout
```
<root>/k8s/<workspace>/<app-name>/**/*.yml #k8s or HelmRelease
```

Sample kustomize manifest layout (see kustomize [README.md](../k8s/kustomize/README.md))
```
<root>/k8s/kustomize/bases
<root>/k8s/kustomize/overlays

```

General documentation for `fluxcd/flux` can be reviewed [Here](https://docs.fluxcd.io/en/latest/)
See [Here](https://docs.fluxcd.io/en/latest/requirements.html) for more specific on the operator requirements for files

## Making a change (Operations)

For manually managed deployments, or for structure changes to the declarative configuration,
simply open a PR against the branch monitored by the operator.

PRs are subject to validation checks via CI, but once merged, they will be applied to the expecting cluster **immediately**.

External CI jobs that incorporate this operator repository are out of scope for this document.
