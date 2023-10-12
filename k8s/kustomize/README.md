## Kustomize Configuration
This directory contains kustomize based deployment manifests for all clusters for ops namespace with the following organization:

```
k8s/kustomize/
├── README.md
├── bases
│   ├── platform-k8s-go-sample-app
│   │   ├── config.yml
│   │   ├── deployment.yml
│   │   ├── external-secret.yml
│   │   ├── kustomization.yaml
│   │   └── service.yml
│   └── polaris
│       ├── README.md
│       ├── configmap.yaml
│       ├── dashboard.deployment.yaml
│       ├── dashboard.rbac.yaml
│       ├── dashboard.service.yaml
│       ├── kustomization.yaml
│       └── polaris-ingress.yaml
└── overlays
    ├── sandbox
        ├── .flux.yaml
        └── polaris
            ├── kustomization.yaml
            └── polaris-ingress.yaml

```

### RULES
- `k8s/kustomize/bases` directory contains the common configurations (across all clusters) for each app managed by kustomize.
- `k8s/kustomize/overlays/$CLUSTER/.flux.yaml` is one file per cluster where an entry like `kustomize build $APP`is added for each new app being added to the cluster. For example, `$APP` can be `polaris`.
IMPORTANT NOTE: Please ensure that you have a directory created in `k8s/kustomize/overlays/$CLUSTER/` matching the name of the application defined in `k8s/kustomize/overlays/$CLUSTER/.flux.yaml`.
- `k8s/kustomize/overlays/$CLUSTER/$APP` directory has specific environment configurations that differs from one cluster to another.

### DO NOT REMOVE THE `.flux.yaml` FILE IN `overlays/$CLUSTER` DIRECTORY
