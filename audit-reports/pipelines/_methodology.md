# Azure Pipelines Docs Audit — Methodology

Read-only audit of `docs/pipelines/` against authoritative source code. **No doc edits this pass.** Each area-agent emits one report following the schema below.

## Sources of truth

| Repo (read-only, outside workspace) | Use for |
|---|---|
| `/git/azure-devops/AzureDevOps/` | Server-side: YAML schema parsing, job/stage execution, variable resolution, in-box task definitions, release management, security, policies, library, build legacy. |
| `/git/external/azure-pipelines-agent/` | OSS agent: agent CLI (`config.sh`/`config.cmd`, `run.sh`, `svc`), capabilities discovery, worker runtime, task execution host, predefined variables exposed to tasks, runner behavior. **Always consult this for any finding involving the agent process or worker.** |
| `docs/pipelines/toc.yml` | Authoritative article enumeration for each area. |
| `.github/copilot-instructions.md` | Repo style rules — moniker usage (`azure-devops` cloud, `azure-devops-2022` server; discard `tfs-2018`), naming ("Azure DevOps" never "ADO"/"AZDO"), required frontmatter (`title`, `description`, `ms.date`, `ms.topic`). |

## Source-area mapping (use as starting point; follow code where it leads)

| Doc area | Primary source folders |
|---|---|
| `agents/` | `AzureDevOps/DistributedTask/Agent`, `Sdk`, `Shared`; **`azure-pipelines-agent`** (entire repo) |
| `tasks/build|deploy|package|test|tool|utility/` | `AzureDevOps/DistributedTask/Tasks`, `Service`; cross-check task execution against `azure-pipelines-agent/src/Agent.Worker` |
| `process/` (YAML, jobs, stages, expressions, templates, conditions, runtime-params, triggers) | `AzureDevOps/DistributedTask/Service`, `Sdk`; `Build` (legacy); `PipelinePolicy` |
| `variables/` | `AzureDevOps/DistributedTask/Service` (resolution), `Build`; `azure-pipelines-agent` (predefined vars exposed to worker) |
| `library/` (variable groups, secure files) | `AzureDevOps/DistributedTask/Service/Library`, `Web` |
| `policies/` | `AzureDevOps/PipelinePolicy`, `Build` |
| `release/` | `AzureDevOps/ReleaseManagement` |
| `targets/` (deployment groups, envs, K8s, VM scale set) | `AzureDevOps/DistributedTask/Tasks`, `Deployment`, `Environments` |
| `ecosystems/`, `apps/` | `AzureDevOps/DistributedTask/Tasks`, `Toolsets`, `VsoToolsets`, `ServiceEndpoints` |
| `repos/` | `AzureDevOps/DistributedTask/Service` (repo resource), `ServiceEndpoints`, `ExternalIntegration` |
| `artifacts/` (pipelines-side; NOT top-level `docs/artifacts/`) | `AzureDevOps/Feed`, `PackagingServices`, `DistributedTask/Tasks` |
| `build/` | `AzureDevOps/Build`, `DistributedTask/Service` |
| `test/` | `AzureDevOps/Tcm`, `TestFramework`, `DistributedTask/Tasks/Test*` |
| `reports/` | `AzureDevOps/Reporting`, `Analytics` |
| `security/` | `AzureDevOps/DistributedTask/Service/Security`, `Token`, `ServiceEndpoints` |
| `licensing/` | `AzureDevOps/Licensing`, `Commerce` |
| `migrate/` | `AzureDevOps/ReleaseManagement`, `Build` |
| `integrations/` | `AzureDevOps/ExternalIntegration`, `ServiceHooks` |
| `architectures/`, `scripts/`, `troubleshooting/`, `admin/`, `get-started/`, root files | cross-cutting — use mappings of referenced areas |

## Per-agent checklist

For every article in your assigned area:

1. **Duplicates within area.** Same subject covered in multiple files? Note article paths.
2. **Inconsistencies.** Conflicting statements between articles. Stale moniker gates (e.g. `tfs-2018` content still showing, missing `azure-devops-2022` coverage). Conflicting examples (YAML in one article that contradicts another).
3. **Source-drift (spot-check 3–5 representative items per article).** Pick concrete claims (task input names/defaults, YAML schema keys, predefined variables, agent CLI flags, capabilities, version-gated behavior) and verify against the mapped source. List what you verified AND what you didn't have time to check.
4. **Missing features.** Capabilities present in source but not mentioned in this area's docs (e.g. an agent CLI flag, a YAML key, a task input). Cite source path + symbol.
5. **Cross-link & staleness.** Broken xrefs (`[text](path)` to nonexistent files), `ms.date` older than 2024-10-29 (>18 months from 2026-04-29) on still-valid features, screenshots referenced by name with file age >18 months on UI-heavy articles.
6. **Learn-extension findings.** Style/structure findings the Learn authoring extension would flag (H1 mismatch with frontmatter title, missing alt text, code blocks without language, etc.). Flag by inspection — do not run the linter.

## Severity legend

- **P0** — incorrect/misleading: docs say something the source contradicts, or an example will fail.
- **P1** — outdated/incomplete: doc was correct historically but source has moved on; or a feature is undocumented.
- **P2** — polish: style, formatting, light staleness, broken non-critical xref.

## Report schema (REQUIRED — exact section names)

Each agent writes ONE file: `audit-reports/pipelines/<area>.md`. Use this template verbatim:

```markdown
# Pipelines Docs Audit — <area>

**Area path:** `docs/pipelines/<area>/`
**Articles audited:** N
**Source folders consulted:** ...
**Date:** YYYY-MM-DD

## Summary

2–4 sentence overview. Headline counts: P0=_, P1=_, P2=_.

## Duplicates

- [path/to/article-a.md](../../docs/pipelines/<area>/article-a.md) and [path/to/article-b.md](../../docs/pipelines/<area>/article-b.md) — both cover X. Recommendation: merge / cross-link / remove.

## Inconsistencies

- **[P0|P1|P2]** [article.md](../../docs/pipelines/<area>/article.md) line N: claim A contradicts [other.md](../../docs/pipelines/<area>/other.md) line M which says B.

## Source-drift

- **[P0|P1|P2]** [article.md](...): doc says "X". Source `AzureDevOps/<path>:Symbol` (or `azure-pipelines-agent/<path>:Symbol`) shows "Y". Verified by reading <file>.

### Verified items
- list of concrete things actually checked

### Not verified
- list of claims the agent did NOT have time to check (so the next pass knows)

## Missing features

- **[P0|P1|P2]** Source `azure-pipelines-agent/src/Agent.Listener/CommandSettings.cs:Flag --foo` is not documented anywhere in `docs/pipelines/<area>/`. Suggested home: <article>.

## Cross-link & staleness

- **[P2]** [article.md](...): `ms.date: 2023-05-01` (>18 months old); content references UI that may have changed.
- **[P0|P1]** [article.md](...): broken link `[text](nonexistent.md)`.

## Learn-extension findings

- **[P2]** [article.md](...) line N: code block missing language identifier.

## Severity-ranked TODO

1. **P0** Fix X in article.md (cited above under Source-drift).
2. **P0** ...
3. **P1** ...
```

## Operating rules for agents

- **Read-only.** Do NOT edit any file under `docs/pipelines/`. You may only write your one report under `audit-reports/pipelines/`.
- **Cite specifically.** Every finding must cite `(doc article + line OR section)` and, for source-drift/missing-features, `(source repo + path + symbol)`. Vague findings are rejected.
- **Spot-check, don't exhaust.** Pick 3–5 representative items per article. Quality > coverage. Explicitly list what you didn't verify.
- **No false certainty.** If you can't determine whether a doc claim is accurate, say so under "Not verified" — don't guess.
- **Use workspace-relative paths.** All doc links in your report use paths relative to the report file (e.g., `../../docs/pipelines/agents/agents.md`).
- **Don't restate the schema.** Just fill it in.
- **Don't propose fixes in detail** — that's the next pass. The TODO section is a one-line-per-item priority queue.
