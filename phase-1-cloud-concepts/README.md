## Step 1 — Naming + tagging standard

> Defined one naming pattern and five required tags for the whole lab, plus a shared script that applies them and a checker that audits them.

Full standard: [docs/naming-and-tagging.md](../docs/naming-and-tagging.md)

| Item | Value |
|---|---|
| Name pattern | `<type>-<workload>[-<nn>]`, lowercase, CAF abbreviations |
| Global names | + 4-hex `LAB_SUFFIX`; storage `stlab<suffix>` |
| Required tags | `project=az900-lab`, `phase=phase-N`, `env=lab`, `owner=madushanka`, `managedBy=portal\|cli\|bicep\|terraform` |
| Shared script | `scripts/lab-standards.sh` (`lab_tags`) |
| Checker | `phase-1-cloud-concepts/scripts/check-tags.sh` |

**Verify:** test resource groups created in Portal (`managedBy=portal`) and CLI (`managedBy=cli`); checker flagged an untagged group and a bare `phase=1`, then passed after `az tag update --operation Merge`; all test groups deleted.

**Gotchas:** tags aren't inherited; `--tags` on `update` replaces all tags; tag values are case-sensitive; cost data shows tags only after they're applied.