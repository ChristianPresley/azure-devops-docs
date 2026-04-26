---
title: Variables quick reference
description: Quickly choose Azure Pipelines variable syntax, scope, output variable patterns, secret handling, and variable group usage.
ms.topic: reference
ms.date: 04/26/2026
ms.service: azure-devops
ms.subservice: azure-pipelines
---

# Variables quick reference

[!INCLUDE [version-lt-eq-azure-devops](../../includes/version-lt-eq-azure-devops.md)]

Use this reference when you need to choose a variable syntax, decide where to define a value, pass data between jobs or stages, or keep secrets out of pipeline logs. For full concepts and procedures, see [Define variables](variables.md), [Set variables in scripts](set-variables-scripts.md), [Set secret variables](set-secret-variables.md), and [Manage variable groups](../library/variable-groups.md).

## Choose the right value type

| Need | Use | Why |
| --- | --- | --- |
| Reuse a string value in task inputs or scripts | [Variable](variables.md) | Variables are strings and can change during a run. |
| Select jobs, stages, steps, or templates before the run starts | [Runtime parameter](runtime-parameters.md) | Parameters are typed and available during template parsing. |
| Share nonsecret configuration across pipelines | [Variable group](../library/variable-groups.md) | Variable groups centralize common values. |
| Share secrets across pipelines | [Variable group linked to Azure Key Vault](../library/link-variable-groups-to-key-vaults.md) | Key Vault supports central secret management and rotation. |
| Pass a value from one step, job, or stage to another | [Output variable](set-variables-scripts.md#levels-of-output-variables) | Output variables are designed for values discovered while the pipeline runs. |
| Gate a job or stage based on a previous result | [Condition with an expression](conditions.md) | Conditions evaluate pipeline state and dependency outputs. |

## Choose variable syntax

| Syntax | Example | Processed | Use for | Avoid for |
| --- | --- | --- | --- | --- |
| Macro | `$(imageTag)` | Runtime before a task runs | Task inputs, script arguments, and values that can change during a job | Pipeline keywords that resolve before runtime, such as `trigger`, `resources`, and repository checkout references |
| Template expression | `${{ variables.imageName }}` | Compile time, before runtime starts | Template reuse, conditional insertion, and nonsecret values that should be visible in expanded YAML | Secrets and values set during a running job |
| Runtime expression | `$[variables.isMain]` | Runtime, before a job or stage runs | Conditions and dynamic variable assignment | Partial string interpolation, because the expression must take the entire right side |

## Choose variable scope

When the same variable name is defined in multiple places, the most local definition wins.

| Scope | Visible to | Typical use | Precedence |
| --- | --- | --- | --- |
| Pipeline settings UI | The pipeline run | Values managed outside YAML, including overridable queue-time values | Lowest |
| Pipeline root | All stages and jobs in the YAML file | Shared defaults, such as `buildConfiguration` | Overrides pipeline settings UI |
| Stage | Jobs in the stage | Environment-specific values, such as `deploymentSlot` | Overrides root variables |
| Job | Steps in the job | Job-specific values, such as a test shard or package path | Highest YAML scope |
| Step-created variable | Later steps in the same job by default | Values discovered in a script | Available after the step that sets it |

For examples, see [Variable scopes](variables.md#variable-scopes).

## Output variable syntax

Use `task.setvariable` when a script discovers a value that later steps, jobs, or stages need. Add `isOutput=true` when the value must cross a job or stage boundary, or when you want to reference it by step name in the same job.

| Scenario | Set variable | Read variable |
| --- | --- | --- |
| Later step in the same job, without `isOutput` | `echo "##vso[task.setvariable variable=imageTag]1.2.3"` | `$(imageTag)` |
| Later step in the same job, with `isOutput=true` | `echo "##vso[task.setvariable variable=imageTag;isOutput=true]1.2.3"` in a step named `setVersion` | `$(setVersion.imageTag)` |
| Job in the same stage | Set with `isOutput=true` in job `Build`, step `setVersion` | Map with `imageTag: $[ dependencies.Build.outputs['setVersion.imageTag'] ]`, then use `$(imageTag)` |
| Job in a later stage | Set with `isOutput=true` in stage `Build`, job `BuildJob`, step `setVersion` | Map with `imageTag: $[ stageDependencies.Build.BuildJob.outputs['setVersion.imageTag'] ]`, then use `$(imageTag)` |
| Stage condition | Set with `isOutput=true` in stage `Build`, job `BuildJob`, step `setVersion` | Use `condition: eq(dependencies.Build.outputs['BuildJob.setVersion.runDeploy'], 'true')` |
| Deployment job | Set with `isOutput=true` in the deployment lifecycle hook | Use the deployment job syntax for the strategy. See [Deployment jobs](deployment-jobs.md#support-for-output-variables). |

Output variables are available only to downstream jobs or stages that depend on the job or stage where the variable was set. If multiple consumers need the same output variable, add explicit `dependsOn` relationships.

## Use secrets safely

- Don't put secret values directly in YAML.
- Prefer secret variables in the pipeline UI, a protected variable group, or a variable group linked to Azure Key Vault.
- Secret variables aren't automatically mapped to environment variables. Map them explicitly with `env:` for each task that needs them.
- Don't echo secrets or pass them as command-line arguments. Some operating systems log command-line arguments.
- Secret masking doesn't mask substrings. Avoid structured secrets such as JSON, XML, or values where a meaningful substring is sensitive.

For procedures, see [Set secret variables](set-secret-variables.md).

## Variable groups in real pipelines

Use variable groups for values shared by multiple pipelines, such as service URLs, deployment region names, feature flags, and shared secret references. Keep pipeline-specific values in YAML at the root, stage, or job level so they remain close to the pipeline logic.

```yaml
variables:
- group: contoso-shared-release
- name: buildConfiguration
  value: Release

stages:
- stage: Build
  jobs:
  - job: BuildApp
    steps:
    - script: echo Building $(buildConfiguration) for $(appRegion)

- stage: Deploy
  variables:
    deploymentSlot: staging
  jobs:
  - job: DeployApp
    steps:
    - bash: ./deploy.sh $(deploymentSlot)
      env:
        API_TOKEN: $(contosoApiToken)
```

In this pattern, `contoso-shared-release` can provide shared values such as `appRegion` and secret values such as `contosoApiToken`. The stage-level `deploymentSlot` stays in YAML because it's specific to this pipeline.

## Common troubleshooting checks

| Symptom | Check |
| --- | --- |
| `$(name)` prints literally | The variable might not exist at the time the task runs, or macro syntax might be used in a keyword that resolves before runtime. |
| Output variable is empty in another job | Confirm `isOutput=true`, the producing step has a `name`, and the consuming job has `dependsOn`. |
| Output variable is empty in another stage | Confirm the stage has `dependsOn` and the mapping uses `stageDependencies.<stage>.<job>.outputs['<step>.<variable>']`. |
| Deployment job output path doesn't work | Confirm whether the deployment uses `runOnce`, `canary`, `rolling`, or an environment resource. Each strategy changes the output key. |
| Secret isn't available as an environment variable | Map the secret explicitly with `env:` on the task. |
| Environment variable name doesn't match | Variable names are uppercased, and periods become underscores. For example, `any.variable` becomes `$ANY_VARIABLE`. |
| Multi-line value behaves differently by agent OS | Format line endings and escaping for the target operating system before setting the variable. |

## See also

- [Define variables](variables.md)
- [Set variables in scripts](set-variables-scripts.md)
- [Expressions](expressions.md)
- [Set secret variables](set-secret-variables.md)
- [Manage variable groups](../library/variable-groups.md)
