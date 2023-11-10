# NERC OpenShift Schema Repository

This repository exists to collect OpenAPI schemas from our OpenShift/Kubernetes clusters, patching them if required so that Kustomize can appropriate apply strategic merge patches to lists. We use automated tooling to generate extract individual resource schemas into the [`schemas/`](schemas/) directory, and then a top level `kustomization.yaml` file applies patches. The final output is processed with `yq` to generate a valid OpenAPI document.

## Installation

You will need a recent Python, the [`click`](https://click.palletsprojects.com/) package, and `yq` ([this one], not [that one]).

[this one]: https://kislyuk.github.io/yq/
[that one]: https://github.com/mikefarah/yq

## Adding new schemas

To update this repository with schemas from your currently cluster:

```
./refresh-schemas.sh
```

This will:

1. Fetch OpenAPI schemas from the remote cluster (using `./schemautil fetch`)
2. Split the schema definitions into individual files under the `schemas` directory (using `./schemautil split`)
4. Re-generate `schemas/kustomization.yaml` (using `./schemautil kustomize`)

At this point, you need to add new schemas to the repository. If you only want new schemas (that is, you want to ignore any modifications to existing schemas), you can do something like this:

```
git checkout schemas/*/*.json
git add schemas
git commit ...
```
## Generating the merged schema

To generate the final `openshift-api-schema.json` document, run:

```
make
```
