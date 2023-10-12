locals {
  module_path                   = "terraform/modules/"
  test_path                     = "test/integration/default/"
  default_command_timeout       = 600
  current_version               = "0.13.0"
  default_name                  = "default"
  default_root_module_directory = "test/fixtures"
  kube_tools_version            = "v1"
  hrval_version                 = "3.1.0"
  kubectl_version               = "1.16.4"
  kustomize_version             = "3.5.4"

  workspaces = [
    {
      workspace = "sandbox"
      kustomize_build_commands = [
        "kustomize build k8s/kustomize/overlays/sandbox/weavescope | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox/polaris | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox/ops-apps-shared-ingress | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox/flagger | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox/opa-gatekeeper | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox/nginx-ingress-controller | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox/aws-efs-csi-driver | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox/bottlerocket-update-operator | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox/ack-s3-controller | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
      ]
    },
    {
      workspace = "sandbox-ops-managed"
      kustomize_build_commands = [
        "kustomize build k8s/kustomize/overlays/sandbox-ops-managed/platform-k8s-go-sample-app-nginx-ingress-example | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox-ops-managed/sample-app-flagger-nginx-ingress-datadog-example | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox-ops-managed/sample-app-flagger-nginx-ingress-prometheus-example | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
        "kustomize build k8s/kustomize/overlays/sandbox-ops-managed/stateful-sample-app-drupal-example | kubeval -v ${local.kubectl_version} --exit-on-error --ignore-missing-schemas",
      ]
    },
  ]

  workspaces_count = length(local.workspaces)

  content = [
    for n in local.workspaces : templatefile("${path.module}/linter.yaml.tpl", {
      workspace                = n["workspace"]
      kubectl_version          = local.kubectl_version
      kustomize_version        = local.kustomize_version
      kube_tools_version       = local.kube_tools_version
      hrval_version            = local.hrval_version
      kustomize_build_commands = n["kustomize_build_commands"]
    })
  ]
}

resource "local_file" "lint_yaml" {
  count                = local.workspaces_count
  content              = local.content[count.index]
  filename             = "${path.module}/../../.github/workflows/lint-${local.workspaces[count.index]["workspace"]}.yaml"
  file_permission      = "0644"
  directory_permission = "0755"
}
