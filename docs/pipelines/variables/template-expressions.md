---
title: Use variables in template expressions
description: Learn when and where you can reference Azure Pipelines variables in template expressions, including scope rules, document order, and predefined variables that are available at compile time.
ms.topic: concept-article
ms.date: 04/30/2026
monikerRange: "<=azure-devops"
ai-usage: ai-assisted
#customer intent: As a pipeline author, I want to know exactly where ${{ variables.X }} works in my YAML so that I can dynamically name stages, jobs, and steps without surprises.
---

# Use variables in template expressions

[!INCLUDE [version-lt-eq-azure-devops](../../includes/version-lt-eq-azure-devops.md)]

Use template expression syntax (`${{ variables.<name> }}`) to inject a variable value into your YAML at compile time, before any task runs. This article explains exactly which variables you can reference, where the syntax is allowed in your YAML, and how variable scope determines what's visible at each point in the file.

For an introduction to all three variable syntaxes (`$(var)`, `${{ variables.var }}`, `$[variables.var]`), see [Define variables](index.md). For the broader template-expression feature set including parameters, conditional insertion, and template-expression functions, see [Template expressions](../process/template-expressions.md).

## When template expressions are evaluated

Azure Pipelines processes a run in this order:

1. **Compile time (template expansion).** The pipeline parser reads your YAML, expands every `${{ ... }}` expression, and produces a fully resolved pipeline document. This is where `${{ variables.X }}` is replaced.
1. **Queue time.** The resolved document is queued and resources are authorized.
1. **Runtime.** Agents pick up jobs, the agent expands `$(var)` macros before each task input, and `$[variables.var]` runtime expressions evaluate when the job or stage is about to execute.

For the full processing order, see [Pipeline runs - process the pipeline](../process/runs.md#process-the-pipeline).

Because `${{ variables.X }}` resolves at compile time, the value is fixed in the run's expanded YAML and never changes during execution. This is the trade-off: template-expression variables are visible early enough to control pipeline structure, but they can't reflect anything that happens after parsing.

## Variables you can reference

At compile time, the `variables` context contains:

- **User-defined variables declared earlier in the same YAML file**, in scope (see [Variable scope](#variable-scope)).
- **User-defined variables set in the pipeline settings UI** (variables defined on the pipeline definition).
- **Queue-time overrides** that the user supplied when starting the run (only when the variable is marked **Settable at queue time**).
- **Server-known [predefined variables](reference.md)**, such as `Build.SourceBranch`, `Build.Reason`, `Build.SourceVersion`, `System.TeamProject`, and `System.PullRequest.PullRequestId`.

### Variables you can't reference

These don't exist yet at compile time, so they always expand to an empty string:

- **Agent variables**, such as `Agent.OS`, `Agent.WorkFolder`, and `Agent.MachineName`. The agent sets these *after* compile-time expansion, when the job starts running on the agent.
- **Variables set by `##vso[task.setvariable]`** in a previous task. The task hasn't run yet.
- **Output variables from previous jobs or stages**, such as `dependencies.A.outputs['step.var']`. Use [runtime expression syntax](../process/expressions.md) (`$[ ... ]`) for those.
- **Variable-group variables.** Variable groups are linked to the pipeline as a [resource](../process/resources.md) and aren't fetched until after authorization, which happens after template expansion. Use macro syntax (`$(var)`) at runtime instead.
- **Variables from a sibling stage or sibling job.** See [Variable scope](#variable-scope).

> [!NOTE]
> Template expressions silently coalesce missing variables to an empty string. If you reference a variable that isn't yet defined, your stage or job name might come out blank instead of failing with a clear error. To check what was substituted, view the expanded YAML on the pipeline run summary.

## Where you can use `${{ variables.X }}`

Template expressions are only expanded in keys and values that the pipeline schema marks as expression-friendly. The following table summarizes the most common positions.

| Location | `${{ variables.X }}` allowed? | Notes |
| --- | --- | --- |
| Pipeline `name` (run number) | Yes | Use predefined variables to format the run name. |
| `stages` block (any property) | Yes | Including `stage`, `displayName`, `dependsOn`, `condition`, `pool`, `variables` values. |
| `jobs` and `deployment` block | Yes | Including `job`, `deployment`, `displayName`, `dependsOn`, `condition`, `pool`, `strategy`, `variables` values. |
| `steps`, `tasks` block | Yes | Including `script`, `displayName`, `condition`, `inputs.<name>`, `env.<name>`. |
| `variables` block values | Yes | A later variable can reference an earlier variable in the same block. |
| `resources.containers[*]` (`endpoint`, `options`, `ports`, `volumes`) | Yes | The container `image` accepts expressions in modern parser versions. |
| `resources.repositories[*].ref` | Yes | Pin a checkout to a branch or tag chosen by a variable. |
| `resources.repositories[*].name` | **No** | The schema explicitly rejects variable references in repository `name`. |
| `resources.pipelines[*]` (`source`, `version`, `branch`, `tags`) | Yes | Choose which upstream pipeline run to consume. |
| `resources.builds[*]` and `resources.packages[*]` (`version`, `branch`, `tag`) | Yes | Pin to a build or package version chosen at compile time. |
| `trigger`, `pr`, `schedules` | **No** | These are evaluated by the trigger service before any pipeline run, so user variables don't exist yet. Use [parameters](../process/runtime-parameters.md) or hardcode values. |
| `extends` template, `template` reference parameters | Yes | Pass variable values into templates as `parameters:`. |

When you put `${{ variables.X }}` somewhere the schema doesn't accept expressions, the parser leaves the literal text in place &mdash; the expression isn't evaluated and the YAML probably fails validation later.

## Variable scope

Variables follow a strict scope chain that mirrors the YAML structure. When the parser enters a `stage`, `deployment`, `job`, or `phase` mapping, it pushes a new variable scope. When it leaves the mapping, it pops the scope. A `variables:` block adds entries to the *current* scope.

Lookups walk *up* the scope chain (current &rarr; parent &rarr; ... &rarr; pipeline root &rarr; predefined). They never walk sideways. As a result:

- **Pipeline-root variables** (top-level `variables:`) are visible to every stage, job, and step in the file.
- **Stage-level variables** are visible inside the same stage's jobs and steps. They're **not** visible in sibling stages or in stage-level properties that come *before* the `variables:` block in the same stage (because document order matters &mdash; see [Document order](#document-order-within-a-mapping)).
- **Job-level variables** are visible inside the same job's steps. They're **not** visible in sibling jobs or stage-level properties.
- **Predefined variables** are always visible at every scope.

This is exactly why you can use `${{ variables.myStage }}` declared at the pipeline root to set a stage's name, but you *can't* declare `myJob` at the stage level and use `${{ variables.myJob }}` to set the parent stage's name &mdash; the stage's properties are evaluated in the stage's own scope, where stage-level variables added later in document order aren't yet visible to siblings.

### Document order within a mapping

Inside a single mapping (a single stage, job, or `variables:` block), the parser reads keys in the order you wrote them. Each `${{ ... }}` expression evaluates against the variables that have been added *up to that point*.

This has two practical consequences:

1. **Within a `variables:` block**, a later variable can reference an earlier one in the same block.

   ```yaml
   variables:
     prefix: ci
     branchTag: $(Build.SourceBranchName)         # macro, expands at runtime
     containerName: ${{ variables.prefix }}-image # template, expands at compile time using prefix above
   ```

1. **At the stage or job level**, properties such as `displayName` that appear *before* the local `variables:` block in your YAML can't see those local variables. Put `variables:` first if you want stage-level variables to be visible from `displayName`, `pool`, or `condition`. Better still, put names that vary at the pipeline root.

## Examples

### Pipeline-root variable controls a stage name

```yaml
variables:
  environment: production

stages:
- stage: deploy_${{ variables.environment }}     # → deploy_production
  displayName: Deploy to ${{ variables.environment }}
  jobs:
  - job: rollout
    steps:
    - script: ./deploy.sh $(environment)         # macro reads the same value at runtime
```

### Pipeline-root variable controls a job and step name

```yaml
variables:
  service: orders-api

jobs:
- job: build_${{ variables.service }}
  displayName: Build ${{ variables.service }}
  steps:
  - script: dotnet build src/${{ variables.service }}/
    displayName: dotnet build ${{ variables.service }}
```

### Stage-scoped variable controls jobs inside the stage

```yaml
stages:
- stage: ci
  variables:
    buildJob: compile

  jobs:
  - job: ${{ variables.buildJob }}              # → compile (allowed: same stage scope)
    displayName: ${{ variables.buildJob }} step
    steps:
    - script: make
```

### Stage-scoped variable can't change a sibling stage or its parent stage's name

```yaml
stages:
- stage: A
  variables:
    nextStage: deploy
  jobs:
  - job: build
    steps:
    - script: ./build.sh

# ❌ This doesn't work. variables.nextStage is scoped to stage A and isn't
# visible when the parser is processing stage B's properties.
- stage: ${{ variables.nextStage }}             # expands to '' (empty) → schema error
  jobs:
  - job: noop
    steps:
    - script: echo hi
```

To control the name of stage `B`, declare `nextStage` at the pipeline root instead:

```yaml
variables:
  nextStage: deploy

stages:
- stage: A
  jobs:
  - job: build
    steps:
    - script: ./build.sh
- stage: ${{ variables.nextStage }}             # ✓ visible at every scope
  jobs:
  - job: noop
    steps:
    - script: echo hi
```

### Job-scoped variable controls steps inside the job

```yaml
jobs:
- job: build
  variables:
    target: linux-x64
  steps:
  - script: dotnet publish -r ${{ variables.target }}
    displayName: Publish for ${{ variables.target }}     # → Publish for linux-x64
```

### Predefined variables in a template expression

Server-known predefined variables are seeded into the variables context before parsing, so they're available everywhere `${{ }}` is allowed.

```yaml
variables:
  isMain: ${{ eq(variables['Build.SourceBranch'], 'refs/heads/main') }}

stages:
- stage: build
  jobs:
  - job: compile
    steps:
    - script: ./build.sh
- ${{ if eq(variables.isMain, 'True') }}:
  - stage: release
    jobs:
    - job: publish
      steps:
      - script: ./publish.sh ${{ variables['Build.SourceVersion'] }}
```

Use the `variables['Some.Name']` index syntax for any name that contains a dot (such as `Build.SourceBranch`).

### Conditional insertion using a variable

Combine `${{ variables.X }}` with the `${{ if ... }}` directive to add or omit pipeline elements.

```yaml
variables:
  includeIntegrationTests: true

jobs:
- job: unit
  steps:
  - script: dotnet test --filter Category=Unit

- ${{ if eq(variables.includeIntegrationTests, 'True') }}:
  - job: integration
    dependsOn: unit
    steps:
    - script: dotnet test --filter Category=Integration
```

### Template expression in a repository resource `ref`

```yaml
parameters:
- name: toolsBranch
  type: string
  default: main

variables:
  toolsRef: refs/heads/${{ parameters.toolsBranch }}

resources:
  repositories:
  - repository: tools
    type: git
    name: contoso/build-tools
    ref: ${{ variables.toolsRef }}              # ✓ ref accepts expressions
    # name: ${{ variables.repoName }}           # ❌ name does not accept variables
```

### A later variable references an earlier one in the same block

```yaml
variables:
  registry: contoso.azurecr.io
  imageName: ${{ variables.registry }}/orders-api    # → contoso.azurecr.io/orders-api
  imageTag: ${{ variables.imageName }}:$(Build.BuildId)
```

The macro `$(Build.BuildId)` in `imageTag` is left as-is at compile time and replaced by the agent at runtime; the surrounding `${{ }}` part still expands when the YAML is parsed.

## Common pitfalls

- **Empty expansion when a variable is out of scope.** A misplaced reference resolves to `''` rather than failing fast. Inspect the expanded YAML in the run summary if a stage or job suddenly has a blank or duplicated name.
- **You can't redefine a system variable.** The parser rejects user variable names that collide with predefined names (for example, you can't declare `variables: { Build.BuildId: 7 }`).
- **Macro syntax doesn't substitute for template syntax in keys.** `$(name): value` isn't valid YAML keying. Only `${{ variables.name }}: value` works as a key.
- **`trigger`, `pr`, and `schedules` see neither macros nor template expressions on user variables.** Use [parameters](../process/runtime-parameters.md) or static values.
- **Template variable values must be literals.** A `variables:` entry whose value is itself an unresolved expression isn't added to the variables map. If you need conditional values, use `${{ if ... }}` to choose between literal alternatives.

## Related articles

- [Define variables](index.md)
- [Variables quick reference](quick-reference.md)
- [Predefined variables reference](reference.md)
- [Template expressions](../process/template-expressions.md)
- [Expressions](../process/expressions.md)
- [Process the pipeline](../process/runs.md#process-the-pipeline)
- [Runtime parameters](../process/runtime-parameters.md)
