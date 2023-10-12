# Hobsons Platform K8S Ops Workspaces - Sandbox - GitHub Action Generation

## Introduction

This is a guide on generating a workspace specific set of GitHub action workflows  via a standard template
for use in pull request validation.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL"
in this document are to be interpreted as described in RFC 2119.

### Guide

#### Editing Templates

- File - `linter.yaml.tpl`

This contains the consistent structure for all GitHub actions related to kubernetes manifest, helm chart, and kustomize linting and validation.

#### Managing and Applying Changes

Once template structure changes have been made, they need to be applied to all managed resource paths.
This is done via `terraform` using `local_file` resources.
This action simply overwrites the existing `.github/workflows/*.yaml` files,
allowing changes to be reviewed and committed via standard `git` operations.

No terraform state is maintained, as terraform is simply used as a templating engine.

```
> cd hack/github-actions
> terraform init && terraform apply
> git diff
```

#### Managing GitHub Action Config

Each file under management requires a minimal set of configuration when generating it.
A list of maps is maintained in `main.tf`  that controls which workspace paths are under management.
Simply add a new entry to the map and update the required variable values.

```
{
  workspace = "sandbox"
  kustomize_build_commands = [
    "kustomize build k8s/kustomize/overlays/sandbox/weavescope | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
    "kustomize build k8s/kustomize/overlays/sandbox/polaris | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
    "kustomize build k8s/kustomize/overlays/sandbox/ops-apps-shared-ingress | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
    "kustomize build k8s/kustomize/overlays/sandbox/opa-gatekeeper | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas"
  ]
},
```
