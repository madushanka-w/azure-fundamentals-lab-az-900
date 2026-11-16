# Phase N — Title

> One-line summary: what this phase builds and why it matters.

![Phase N architecture](diagrams/phase-N.png)
<sub>Source: [diagrams/phase-N.excalidraw](diagrams/phase-N.excalidraw)</sub>

## Contents

| # | Step | Built with |
|---|---|---|
| 1 | Step name | Portal + CLI |

---

<!-- step blocks go here (docs/templates/step-block.md) -->

---

## Scripts

| Script | What it does |
|---|---|
| [`scripts/deploy.sh`](scripts/deploy.sh) | Builds the phase with Azure CLI |
| [`scripts/teardown.sh`](scripts/teardown.sh) | Deletes the phase resource groups |

## Teardown

```bash
az group delete --name <rg-name> --yes --no-wait
```

## Cost

| Session | Resources | Est. cost |
|---|---|---|