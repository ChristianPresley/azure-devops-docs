---
ms.topic: include
ms.service: azure-devops-pipelines
ms.manager: wiwagn
ms.author: rabououn
author: ramiMSFT
ms.date: 05/11/2026
---
<a id="agent-variables"></a>
<a id="build-variables"></a>
<a id="system-variables"></a>
<a id="pipeline-variables"></a>
<a id="deployment-job-variables"></a>
<a id="checks-variables"></a>

## Predefined variables (Azure Pipelines)

Predefined variables are available in three pipeline expression syntaxes:

- **Template expressions** `${{ variable }}` — evaluated at template-expansion (compile) time. Only variables whose values are known before the job runs are available.
- **Macro expressions** `$(variable)` — substituted just before each task executes. Almost every predefined variable is available as a macro.
- **Runtime expressions** `$[ variable ]` — evaluated at job execution time, typically used in `condition:` and dependency expressions.

Each variable below lists the supported expression syntax in a **Property / Value** table. Rows marked **Not available** indicate a syntax that can't be used to reference that variable — for example, when you reference a template-only variable in a [template](../../process/templates.md), the expression doesn't render because the value isn't accessible within the template's scope. You can use agent variables as environment variables in scripts and as parameters in build tasks; you can't use them to customize the build number or to apply a version control label or tag.

The following sections group predefined variables by scenario. Each table provides a quick reference with an example value, and the detailed variable descriptions remain below.

## Agent and workspace

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [Agent.BuildDirectory](#agentbuilddirectory) | `/home/vsts/work/1` |
> | [Agent.ContainerMapping](#agentcontainermapping) | `{"one_container":{"id":"bdbb357d73a0..."}}` |
> | [Agent.HomeDirectory](#agenthomedirectory) | `c:\agent` |
> | [Agent.Id](#agentid) | `2` |
> | [Agent.JobName](#agentjobname) | `Job` |
> | [Agent.JobStatus](#agentjobstatus) | `Succeeded` |
> | [Agent.MachineName](#agentmachinename) | `fv-az200-123` |
> | [Agent.Name](#agentname) | `Hosted Agent` |
> | [Agent.OS](#agentos) | `Linux` |
> | [Agent.OSArchitecture](#agentosarchitecture) | `X64` |
> | [Agent.TempDirectory](#agenttempdirectory) | `/home/vsts/work/_temp` |
> | [Agent.ToolsDirectory](#agenttoolsdirectory) | `/opt/hostedtoolcache` |
> | [Agent.WorkFolder](#agentworkfolder) | `c:\agent_work` |
> | [Common.TestResultsDirectory](#commontestresultsdirectory) | `c:\agent_work\1\TestResults` |
> | [Pipeline.Workspace](#pipelineworkspace) | `/home/vsts/work/1` |
> | [TF_BUILD](#tfbuild) | `True` |

## Pipeline, job, and stage execution context

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [Build.BuildId](#buildbuildid) | `1764` |
> | [Build.BuildNumber](#buildbuildnumber) | `20260511.1` |
> | [Build.BuildUri](#buildbuilduri) | `vstfs:///Build/Build/1430` |
> | [Build.ContainerId](#buildcontainerid) | `2713905` |
> | [Build.DefinitionFolderPath](#builddefinitionfolderpath) | `\Infrastructure\Deploy` |
> | [Build.DefinitionName](#builddefinitionname) | `MyApp-CI` |
> | [Build.DefinitionVersion](#builddefinitionversion) | `1` |
> | [Checks.StageAttempt](#checksstageattempt) | `1` |
> | [System.DefinitionId](#systemdefinitionid) | `42` |
> | [System.JobAttempt](#systemjobattempt) | `1` |
> | [System.JobDisplayName](#systemjobdisplayname) | `Build` |
> | [System.JobId](#systemjobid) | `12f1170f-0000-0000-0000-000000000000` |
> | [System.JobIdentifier](#systemjobidentifier) | `Build.Build.__default` |
> | [System.JobName](#systemjobname) | `Build` |
> | [System.PhaseAttempt](#systemphaseattempt) | `1` |
> | [System.PhaseDisplayName](#systemphasedisplayname) | `Build` |
> | [System.PhaseName](#systemphasename) | `Phase_1` |
> | [System.PlanId](#systemplanid) | `9e4ec8c3-0000-0000-0000-000000000000` |
> | [System.StageAttempt](#systemstageattempt) | `1` |
> | [System.StageDisplayName](#systemstagedisplayname) | `Build` |
> | [System.StageName](#systemstagename) | `Stage_1` |
> | [System.TimelineId](#systemtimelineid) | `33b55a2d-0000-0000-0000-000000000000` |

## Source control

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [Build.Repository.Clean](#buildrepositoryclean) | `true` |
> | [Build.Repository.Git.SubmoduleCheckout](#buildrepositorygitsubmodulecheckout) | `true` |
> | [Build.Repository.ID](#buildrepositoryid) | `b3e7e7c4-0000-0000-0000-000000000000` |
> | [Build.Repository.LocalPath](#buildrepositorylocalpath) | `c:\agent_work\1\s` |
> | [Build.Repository.Name](#buildrepositoryname) | `Fabrikam-Scripts` |
> | [Build.Repository.Provider](#buildrepositoryprovider) | `GitHub` |
> | [Build.Repository.Tfvc.Workspace](#buildrepositorytfvcworkspace) | `ws_12_8` |
> | [Build.Repository.Uri](#buildrepositoryuri) | `https://dev.azure.com/fabrikamfiber/_git/Scripts` |
> | [Build.SourceBranch](#buildsourcebranch) | `refs/heads/main` |
> | [Build.SourceBranchName](#buildsourcebranchname) | `main` |
> | [Build.SourcesDirectory](#buildsourcesdirectory) | `c:\agent_work\1\s` |
> | [Build.SourceTfvcShelveset](#buildsourcetfvcshelveset) | `myshelveset;user@example.com` |
> | [Build.SourceVersion](#buildsourceversion) | `a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0` |
> | [Build.SourceVersionAuthor](#buildsourceversionauthor) | `Jamal Hartnett` |
> | [Build.SourceVersionMessage](#buildsourceversionmessage) | `Fix login bug` |
> | [System.DefaultWorkingDirectory](#systemdefaultworkingdirectory) | `c:\agent_work\1\s` |
> | [System.IsTriggeringRepository](#systemistriggeringrepository) | `True` |

## Triggers and upstream builds

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [Build.CronSchedule.DisplayName](#buildcronscheduledisplayname) | `Nightly build` |
> | [Build.Reason](#buildreason) | `Manual` |
> | [Build.TriggeredBy.BuildId](#buildtriggeredbybuildid) | `1764` |
> | [Build.TriggeredBy.BuildNumber](#buildtriggeredbybuildnumber) | `20260511.1` |
> | [Build.TriggeredBy.DefinitionId](#buildtriggeredbydefinitionid) | `42` |
> | [Build.TriggeredBy.DefinitionName](#buildtriggeredbydefinitionname) | `MyApp-CI` |
> | [Build.TriggeredBy.ProjectID](#buildtriggeredbyprojectid) | `b3e7e7c4-0000-0000-0000-000000000000` |

## Pull requests

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [System.PullRequest.ForkSecretsRemoved](#systempullrequestforksecretsremoved) | `True` |
> | [System.PullRequest.IsFork](#systempullrequestisfork) | `True` |
> | [System.PullRequest.MergedAt](#systempullrequestmergedat) | `2026-05-11T18:30:00Z` |
> | [System.PullRequest.PullRequestId](#systempullrequestpullrequestid) | `17` |
> | [System.PullRequest.PullRequestIteration](#systempullrequestpullrequestiteration) | `3` |
> | [System.PullRequest.PullRequestNumber](#systempullrequestpullrequestnumber) | `42` |
> | [System.PullRequest.SourceBranch](#systempullrequestsourcebranch) | `refs/heads/users/raisa/new-feature` |
> | [System.PullRequest.SourceCommitId](#systempullrequestsourcecommitid) | `a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0` |
> | [System.PullRequest.SourceRepositoryUri](#systempullrequestsourcerepositoryuri) | `https://dev.azure.com/ouraccount/_git/OurProject` |
> | [System.PullRequest.TargetBranch](#systempullrequesttargetbranch) | `refs/heads/main` |
> | [System.PullRequest.targetBranchName](#systempullrequesttargetbranchname) | `main` |

## Identity and auditing

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [Build.QueuedBy](#buildqueuedby) | `Jamal Hartnett` |
> | [Build.QueuedById](#buildqueuedbyid) | `a1b2c3d4-0000-0000-0000-000000000000` |
> | [Build.RequestedFor](#buildrequestedfor) | `Jamal Hartnett` |
> | [Build.RequestedForEmail](#buildrequestedforemail) | `fabrikamfiber4@example.com` |
> | [Build.RequestedForId](#buildrequestedforid) | `00000002-0000-8888-8000-000000000000` |
> | [Build.StageRequestedBy](#buildstagerequestedby) | `Jamal Hartnett` |
> | [Build.StageRequestedForId](#buildstagerequestedforid) | `00000002-0000-8888-8000-000000000000` |

## Artifacts and output directories

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [Build.ArtifactStagingDirectory](#buildartifactstagingdirectory) | `c:\agent_work\1\a` |
> | [Build.BinariesDirectory](#buildbinariesdirectory) | `c:\agent_work\1\b` |
> | [Build.StagingDirectory](#buildstagingdirectory) | `c:\agent_work\1\a` |

## Organization, project, and security

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [System.AccessToken](#systemaccesstoken) | `(opaque OAuth bearer token)` |
> | [System.AccessTokenRequestUri](#systemaccesstokenrequesturi) | `https://vstoken.dev.azure.com/...` |
> | [System.CollectionId](#systemcollectionid) | `6c6f3423-0000-0000-0000-000000000000` |
> | [System.CollectionUri](#systemcollectionuri) | `https://dev.azure.com/fabrikamfiber/` |
> | [System.HostType](#systemhosttype) | `build` |
> | [System.OidcRequestUri](#systemoidcrequesturi) | `https://vstoken.dev.azure.com/...` |
> | [System.TeamFoundationCollectionUri](#systemteamfoundationcollectionuri) | `https://dev.azure.com/fabrikamfiber/` |
> | [System.TeamProject](#systemteamproject) | `Fabrikam` |
> | [System.TeamProjectId](#systemteamprojectid) | `b3e7e7c4-0000-0000-0000-000000000000` |

## Deployment jobs (CD)

> [!div class="mx-tdBreakAll"]
> | Variable | Example value |
> | --- | --- |
> | [Environment.Id](#environmentid) | `10` |
> | [Environment.Name](#environmentname) | `smarthotel-dev` |
> | [Environment.ResourceId](#environmentresourceid) | `4` |
> | [Environment.ResourceName](#environmentresourcename) | `bookings` |
> | [Strategy.CycleName](#strategycyclename) | `Iteration` |
> | [Strategy.Name](#strategyname) | `canary` |

Detailed variable descriptions follow.

### Agent.BuildDirectory

The local path on the agent where all folders for a given build pipeline are created. This variable has the same value as `Pipeline.Workspace`. For example: `/home/vsts/work/1`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.BuildDirectory)` |
| Runtime syntax | `$[ variables['Agent.BuildDirectory'] ]` |
| Template syntax | Not available |

### Agent.ContainerMapping

A mapping from container resource names in YAML to their Docker IDs at runtime. Example:

```json
{
  "one_container": {
    "id": "bdbb357d73a0bd3550a1a5b778b62a4c88ed2051c7802a0659f1ff6e76910190"
  },
  "another_container": {
    "id": "82652975109ec494876a8ccbb875459c945982952e0a72ad74c91216707162bb"
  }
}
```

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.ContainerMapping)` |
| Runtime syntax | `$[ variables['Agent.ContainerMapping'] ]` |
| Template syntax | Not available |

### Agent.HomeDirectory

The directory the agent is installed into. This variable contains the agent software. For example: `c:\agent`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.HomeDirectory)` |
| Runtime syntax | `$[ variables['Agent.HomeDirectory'] ]` |
| Template syntax | Not available |

### Agent.Id

The ID of the agent.

| Property | Value |
| --- | --- |
| Example | `2` |
| Macro syntax | `$(Agent.Id)` |
| Runtime syntax | `$[ variables['Agent.Id'] ]` |
| Template syntax | Not available |

### Agent.JobName

The name of the running job. This name is usually `Job`; or `__default`, but in multi-config scenarios, it's the configuration.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.JobName)` |
| Runtime syntax | `$[ variables['Agent.JobName'] ]` |
| Template syntax | Not available |

### Agent.JobStatus

The status of the build.<br><br>• `Canceled`<br>• `Failed`<br>• `Succeeded`<br>• `SucceededWithIssues` (partially successful)<br>• `Skipped` (last job)<br><br>The environment variable should be referenced as `AGENT_JOBSTATUS`. The older `agent.jobstatus` is available for backwards compatibility.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.JobStatus)` |
| Runtime syntax | `$[ variables['Agent.JobStatus'] ]` |
| Template syntax | Not available |

### Agent.MachineName

The name of the machine on which the agent is installed.

| Property | Value |
| --- | --- |
| Example | `fv-az200-123` |
| Macro syntax | `$(Agent.MachineName)` |
| Runtime syntax | `$[ variables['Agent.MachineName'] ]` |
| Template syntax | Not available |

### Agent.Name

The name of the agent that is registered with the pool.<br><br>If you're using a self-hosted agent, you specify the name. See [agents](../../agents/agents.md)

| Property | Value |
| --- | --- |
| Example | `Hosted Agent` |
| Macro syntax | `$(Agent.Name)` |
| Runtime syntax | `$[ variables['Agent.Name'] ]` |
| Template syntax | Not available |

### Agent.OS

The operating system of the agent host. Valid values are:<br><br>• `Windows_NT`<br>• `Darwin`<br>• `Linux`<br><br>If you're running in a container, the agent host and container can  run different operating systems.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.OS)` |
| Runtime syntax | `$[ variables['Agent.OS'] ]` |
| Template syntax | Not available |

### Agent.OSArchitecture

The operating system processor architecture of the agent host. Valid values are:<br><br>• `X86`<br>• `X64`<br>• `ARM`<br><br>

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.OSArchitecture)` |
| Runtime syntax | `$[ variables['Agent.OSArchitecture'] ]` |
| Template syntax | Not available |

### Agent.TempDirectory

A temporary folder that is cleaned after each pipeline job. This directory is used by tasks such as [.NET Core CLI task](/azure/devops/pipelines/tasks/reference/dotnet-core-cli-v2) to hold temporary items like test results before they're published.<br><br>For example: `/home/vsts/work/_temp` for Ubuntu.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.TempDirectory)` |
| Runtime syntax | `$[ variables['Agent.TempDirectory'] ]` |
| Template syntax | Not available |

### Agent.ToolsDirectory

The directory used by tasks such as [Node Tool Installer](/azure/devops/pipelines/tasks/reference/node-tool-v0) and [Use Python Version](/azure/devops/pipelines/tasks/reference/use-python-version-v0) to switch between multiple versions of a tool.<br><br>These tasks add tools from this directory to `PATH` so that subsequent build steps can use them.<br><br>Learn about [managing this directory on a self-hosted agent](https://go.microsoft.com/fwlink/?linkid=2008884)

| Property | Value |
| --- | --- |
| Example | `/opt/hostedtoolcache` |
| Macro syntax | `$(Agent.ToolsDirectory)` |
| Runtime syntax | `$[ variables['Agent.ToolsDirectory'] ]` |
| Template syntax | Not available |

### Agent.WorkFolder

The working directory for this agent.<br><br>For example: `c:\agent_work`.<br><br>Note: This directory isn't guaranteed to be writable by pipeline tasks (for example, when mapped into a container). For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).

| Property | Value |
| --- | --- |
| Macro syntax | `$(Agent.WorkFolder)` |
| Runtime syntax | `$[ variables['Agent.WorkFolder'] ]` |
| Template syntax | Not available |

### Build.ArtifactStagingDirectory

The local path on the agent where any artifacts are copied to before being pushed to their destination. For example: `c:\agent_work\1\a`.<br><br>A typical way to use this folder is to publish your build artifacts with the [Copy files](/azure/devops/pipelines/tasks/reference/copy-files-v2) and [Publish build artifacts](/azure/devops/pipelines/tasks/reference/publish-build-artifacts-v1) tasks.<br><br>Note: Build.ArtifactStagingDirectory and Build.StagingDirectory are interchangeable. This directory is purged before each new build, so you don't have to clean it up yourself.<br><br>See [Artifacts in Azure Pipelines](../../artifacts/artifacts-overview.md). For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure). <br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.ArtifactStagingDirectory)` |
| Runtime syntax | `$[ variables['Build.ArtifactStagingDirectory'] ]` |
| Template syntax | Not available |

### Build.BinariesDirectory

The local path on the agent you can use as an output folder for compiled binaries.<br><br> On self-hosted agents, new build pipelines aren't set up to clean this directory by default. You can define your build to clean it up on the [Repository tab](../../repos/index.md).<br><br>For example: `c:\agent_work\1\b`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.BinariesDirectory)` |
| Runtime syntax | `$[ variables['Build.BinariesDirectory'] ]` |
| Template syntax | Not available |

### Build.BuildId

The ID of the record for the completed build.

| Property | Value |
| --- | --- |
| Example | `1764` |
| Macro syntax | `$(Build.BuildId)` |
| Runtime syntax | `$[ variables['Build.BuildId'] ]` |
| Template syntax | Not available |

### Build.BuildNumber

The name of the completed build, also known as the run number. You can specify [what is included](../../process/run-number.md) in this value.<br><br>A typical use of this variable is to make it part of the label format, which you specify on the [repository tab](../../repos/index.md).<br><br>Note: This value can contain whitespace or other invalid label characters. In these cases, the [label format](../../../repos/tfvc/labels-command.md) fails.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Example | `20260511.1` |
| Macro syntax | `$(Build.BuildNumber)` |
| Runtime syntax | `$[ variables['Build.BuildNumber'] ]` |
| Template syntax | Not available |

### Build.BuildUri

The URI for the build. For example: `vstfs:///Build/Build/1430`.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.BuildUri)` |
| Runtime syntax | `$[ variables['Build.BuildUri'] ]` |
| Template syntax | Not available |

### Build.ContainerId

The ID of the container for your artifact. When you upload an artifact in your pipeline, it's added to a container that is specific for that particular artifact.

| Property | Value |
| --- | --- |
| Example | `2713905` |
| Macro syntax | `$(Build.ContainerId)` |
| Runtime syntax | `$[ variables['Build.ContainerId'] ]` |
| Template syntax | Not available |

### Build.CronSchedule.DisplayName

The `displayName` of the cron schedule that triggered the pipeline run. This variable is only set if a YAML scheduled trigger triggers the pipeline run. For more information, see [schedules.cron definition - Build.CronSchedule.DisplayName variable](/azure/devops/pipelines/yaml-schema/schedules-cron#buildcronscheduledisplayname-variable)

| Property | Value |
| --- | --- |
| Example | `Nightly build` |
| Macro syntax | `$(Build.CronSchedule.DisplayName)` |
| Runtime syntax | `$[ variables['Build.CronSchedule.DisplayName'] ]` |
| Template syntax | `${{ variables['Build.CronSchedule.DisplayName'] }}` |

### Build.DefinitionFolderPath

The folder path of the pipeline definition in the **Pipelines** list. For example, a pipeline at `\Infrastructure\Deploy\nightly-deploy` returns `\Infrastructure\Deploy`. Empty for pipelines at the root.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.DefinitionFolderPath)` |
| Runtime syntax | `$[ variables['Build.DefinitionFolderPath'] ]` |
| Template syntax | `${{ variables['Build.DefinitionFolderPath'] }}` |

### Build.DefinitionName

The name of the build pipeline.<br><br>Note: This value can contain whitespace or other invalid label characters. In these cases, the [label format](../../../repos/tfvc/labels-command.md) fails.

| Property | Value |
| --- | --- |
| Example | `MyApp-CI` |
| Macro syntax | `$(Build.DefinitionName)` |
| Runtime syntax | `$[ variables['Build.DefinitionName'] ]` |
| Template syntax | `${{ variables['Build.DefinitionName'] }}` |

### Build.DefinitionVersion

The version of the build pipeline.

| Property | Value |
| --- | --- |
| Example | `1` |
| Macro syntax | `$(Build.DefinitionVersion)` |
| Runtime syntax | `$[ variables['Build.DefinitionVersion'] ]` |
| Template syntax | `${{ variables['Build.DefinitionVersion'] }}` |

### Build.QueuedBy

See [How are the identity variables set?](#identity_values).<br><br>Note: This value can contain whitespace or other invalid label characters. In these cases, the [label format](../../../repos/tfvc/labels-command.md) fails.

| Property | Value |
| --- | --- |
| Example | `Jamal Hartnett` |
| Macro syntax | `$(Build.QueuedBy)` |
| Runtime syntax | `$[ variables['Build.QueuedBy'] ]` |
| Template syntax | `${{ variables['Build.QueuedBy'] }}` |

### Build.QueuedById

See [How are the identity variables set?](#identity_values)

| Property | Value |
| --- | --- |
| Example | `a1b2c3d4-0000-0000-0000-000000000000` |
| Macro syntax | `$(Build.QueuedById)` |
| Runtime syntax | `$[ variables['Build.QueuedById'] ]` |
| Template syntax | `${{ variables['Build.QueuedById'] }}` |

### Build.Reason

The event that caused the build to run. Example: `Manual`

| Value | Description |
|---|---|
| `Manual` | A user manually queued the build from the Azure DevOps portal. |
| `IndividualCI` | **Continuous integration (CI)** triggered by a Git push or a Team Foundation Version Control (TFVC) check-in. |
| `BatchedCI` | **Continuous integration (CI)** triggered by a Git push or a TFVC check-in, with **Batch changes** selected. |
| `Schedule` | **Scheduled** trigger. |
| `ScheduleForced` | A user manually ran a scheduled trigger, bypassing the **Always run** evaluation. For example, choosing **Run pipeline** on a scheduled pipeline. |
| `UserCreated` | The build was created programmatically through the REST API or `az pipelines run`, as opposed to the **Queue build** button (`Manual`). |
| `ValidateShelveset` | A user manually queued the build of a specific TFVC shelveset. |
| `CheckInShelveset` | **Gated check-in** trigger. |
| `PullRequest` | A Git branch policy that requires a build triggers the build. |
| `BuildCompletion` | [Another build triggers](../../process/pipeline-triggers.md) the build. |
| `ResourceTrigger` | [A resource trigger](../../process/resources.md) or [another build triggers](../../process/pipeline-triggers.md) the build. |

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.Reason)` |
| Runtime syntax | `$[ variables['Build.Reason'] ]` |
| Template syntax | `${{ variables['Build.Reason'] }}` |

### Build.Repository.Clean

The value you selected for **Clean** in the [source repository settings](../../repos/index.md).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Example | `true` |
| Macro syntax | `$(Build.Repository.Clean)` |
| Runtime syntax | `$[ variables['Build.Repository.Clean'] ]` |
| Template syntax | Not available |

### Build.Repository.Git.SubmoduleCheckout

The value you selected for **Checkout submodules** on the [repository tab](../../repos/index.md). With multiple repos checked out, this value tracks the triggering repository's setting.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Example | `true` |
| Macro syntax | `$(Build.Repository.Git.SubmoduleCheckout)` |
| Runtime syntax | `$[ variables['Build.Repository.Git.SubmoduleCheckout'] ]` |
| Template syntax | Not available |

### Build.Repository.ID

The unique identifier of the [repository](../../repos/index.md).<br><br>This value doesn't change, even if the name of the repository does.

| Property | Value |
| --- | --- |
| Example | `b3e7e7c4-0000-0000-0000-000000000000` |
| Macro syntax | `$(Build.Repository.ID)` |
| Runtime syntax | `$[ variables['Build.Repository.ID'] ]` |
| Template syntax | `${{ variables['Build.Repository.ID'] }}` |

### Build.Repository.LocalPath

The local path on the agent where your source code files are downloaded. For example: `c:\agent_work\1\s`.<br><br>On self-hosted agents, new build pipelines update only the changed files by default. You can modify how files are downloaded on the [Repository tab](../../repos/index.md).<br><br>Important note: If you check out only one Git repository, this path is the exact path to the code.<br><br>If you check out multiple repositories, the behavior is as follows (and might differ from the value of the Build.SourcesDirectory variable):<br><ul><li>If the checkout step for the self (primary) repository has no custom checkout path defined, or the checkout path is the multi-checkout default path `$(Pipeline.Workspace)/s/&<RepoName>` for the self repository, the value of this variable reverts to its default value, which is `$(Pipeline.Workspace)/s`.</li><li>If the checkout step for the self (primary) repository had a custom checkout path defined that is not its multi-checkout default path, this variable contains the exact path to the self repository.</li></ul>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.Repository.LocalPath)` |
| Runtime syntax | `$[ variables['Build.Repository.LocalPath'] ]` |
| Template syntax | Not available |

### Build.Repository.Name

The name of the triggering [repository](../../repos/index.md)

| Property | Value |
| --- | --- |
| Example | `Fabrikam-Scripts` |
| Macro syntax | `$(Build.Repository.Name)` |
| Runtime syntax | `$[ variables['Build.Repository.Name'] ]` |
| Template syntax | `${{ variables['Build.Repository.Name'] }}` |

### Build.Repository.Provider

The type of the triggering [repository](../../repos/index.md).<br><br>• `TfsGit`: [TFS Git repository](../../../repos/git/index.yml)<br>• `TfsVersionControl`: [Team Foundation Version Control](../../../repos/tfvc/what-is-tfvc.md)<br>• `Git`: Git repository hosted on an external server<br>• `GitHub`<br>• `Svn`: Subversion<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.Repository.Provider)` |
| Runtime syntax | `$[ variables['Build.Repository.Provider'] ]` |
| Template syntax | Not available |

### Build.Repository.Tfvc.Workspace

Defined if your [repository](../../repos/index.md) is Team Foundation Version Control. The name of the [TFVC workspace](../../../repos/tfvc/create-work-workspaces.md) used by the build agent.<br><br>For example, if the Agent.BuildDirectory is `c:\agent_work\12` and the Agent.Id is `8`, the workspace name could be: `ws_12_8`<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.Repository.Tfvc.Workspace)` |
| Runtime syntax | `$[ variables['Build.Repository.Tfvc.Workspace'] ]` |
| Template syntax | Not available |

### Build.Repository.Uri

The URL for the triggering repository. For example:<br><br>• Git: [https://fabrikamfiber@dev.azure.com/fabrikamfiber/_git/Scripts](https://fabrikamfiber@dev.azure.com/fabrikamfiber/_git/Scripts)<br>• TFVC: [https://dev.azure.com/fabrikamfiber/](https://dev.azure.com/fabrikamfiber/)<br><br>This variable can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.Repository.Uri)` |
| Runtime syntax | `$[ variables['Build.Repository.Uri'] ]` |
| Template syntax | `${{ variables['Build.Repository.Uri'] }}` |

### Build.RequestedFor

See [How are the identity variables set?](#identity_values).<br><br>Note: This value can contain whitespace or other invalid label characters. In these cases, the [label format](../../../repos/tfvc/labels-command.md) fails.

| Property | Value |
| --- | --- |
| Example | `Jamal Hartnett` |
| Macro syntax | `$(Build.RequestedFor)` |
| Runtime syntax | `$[ variables['Build.RequestedFor'] ]` |
| Template syntax | `${{ variables['Build.RequestedFor'] }}` |

### Build.RequestedForEmail

See [How are the identity variables set?](#identity_values)

| Property | Value |
| --- | --- |
| Example | `fabrikamfiber4@example.com` |
| Macro syntax | `$(Build.RequestedForEmail)` |
| Runtime syntax | `$[ variables['Build.RequestedForEmail'] ]` |
| Template syntax | `${{ variables['Build.RequestedForEmail'] }}` |

### Build.RequestedForId

See [How are the identity variables set?](#identity_values)

| Property | Value |
| --- | --- |
| Example | `00000002-0000-8888-8000-000000000000` |
| Macro syntax | `$(Build.RequestedForId)` |
| Runtime syntax | `$[ variables['Build.RequestedForId'] ]` |
| Template syntax | `${{ variables['Build.RequestedForId'] }}` |

### Build.SourceBranch

The branch of the triggering repo the build was queued for. Some examples:<br><ul><li>Git repo branch: `refs/heads/main`</li><li>Git repo pull request: `refs/pull/1/merge`</li><li>TFVC repo branch: `$/teamproject/main`</li><li>TFVC repo gated check-in: `Gated_2016-06-06_05.20.51.4369;username@live.com`</li><li>TFVC repo shelveset build: `myshelveset;username@live.com`</li><li>When a tag triggers your pipeline: `refs/tags/your-tag-name`</li></ul>When you use this variable in your build number format, the forward slash characters (`/`) are replaced with underscore characters (`_`).<br><br>Note: In TFVC, if you're running a gated check-in build or manually building a shelveset, you can't use this variable in your build number format.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.SourceBranch)` |
| Runtime syntax | `$[ variables['Build.SourceBranch'] ]` |
| Template syntax | `${{ variables['Build.SourceBranch'] }}` |

### Build.SourceBranchName

The name of the branch in the triggering repo the build was queued for.<br><ul><li>Git repo branch, pull request, or tag: The last path segment in the ref. For example, in `refs/heads/main` this value is `main`. In `refs/heads/feature/tools`, this value is `tools`. In `refs/tags/your-tag-name`, the value is `your-tag-name`.</li><li>TFVC repo branch: The last path segment in the root server path for the workspace. For example, in `$/teamproject/main` this value is `main`.</li><li>TFVC repo gated check-in or shelveset build is the name of the shelveset. For example, `Gated_2016-06-06_05.20.51.4369;username@live.com` or `myshelveset;username@live.com`.</li></ul>Note: In TFVC, if you're running a gated check-in build or manually building a shelveset, you can't use this variable in your build number format.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.SourceBranchName)` |
| Runtime syntax | `$[ variables['Build.SourceBranchName'] ]` |
| Template syntax | `${{ variables['Build.SourceBranchName'] }}` |

### Build.SourcesDirectory

The local path on the agent where your source code files are downloaded. For example: `c:\agent_work\1\s`.<br><br>On self-hosted agents, new build pipelines update only the changed files. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).<br><br>Important note: If you check out only one Git repository, this path is the exact path to the code. If you check out multiple repositories, it reverts to its default value, which is `$(Pipeline.Workspace)/s`, even if the self (primary) repository is checked out to a custom path different from its multi-checkout default path `$(Pipeline.Workspace)/s/<RepoName>` (in this respect, the variable differs from the behavior of the Build.Repository.LocalPath variable).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.SourcesDirectory)` |
| Runtime syntax | `$[ variables['Build.SourcesDirectory'] ]` |
| Template syntax | Not available |

### Build.SourceTfvcShelveset

Defined if your [repository](../../repos/index.md) is Team Foundation Version Control.<br><br>If you're running a [gated build](../../repos/tfvc.md#gated) or a [shelveset build](../../create-first-pipeline.md#queueabuild), this variable is set to the name of the [shelveset](../../../repos/tfvc/suspend-your-work-manage-your-shelvesets.md) you're building.<br><br>Note: This variable yields a value that is invalid for build use in a build number format.

| Property | Value |
| --- | --- |
| Example | `Gated_2026-05-11_05.20.51.4369;user@example.com` |
| Macro syntax | `$(Build.SourceTfvcShelveset)` |
| Runtime syntax | `$[ variables['Build.SourceTfvcShelveset'] ]` |
| Template syntax | Not available |

### Build.SourceVersion

The latest version control change of the triggering repo that is included in this build.<br><br>• Git: The [commit](../../../repos/git/commits.md) ID.<br>• TFVC: the [changeset](../../../repos/tfvc/find-view-changesets.md).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Example | `a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0` |
| Macro syntax | `$(Build.SourceVersion)` |
| Runtime syntax | `$[ variables['Build.SourceVersion'] ]` |
| Template syntax | `${{ variables['Build.SourceVersion'] }}` |

### Build.SourceVersionAuthor

The display name of the author of the commit referenced by `Build.SourceVersion`. This can differ from `Build.RequestedFor` (the user who triggered the run). Treated as personally identifiable information and scrubbed from agent diagnostic logs.

| Property | Value |
| --- | --- |
| Example | `Jamal Hartnett` |
| Macro syntax | `$(Build.SourceVersionAuthor)` |
| Runtime syntax | `$[ variables['Build.SourceVersionAuthor'] ]` |
| Template syntax | `${{ variables['Build.SourceVersionAuthor'] }}` |

### Build.SourceVersionMessage

The comment of the commit or changeset for the triggering repo. We truncate the message to the first line or 200 characters, whichever is shorter.<br><br>The `Build.SourceVersionMessage` corresponds to the message on `Build.SourceVersion` commit. The `Build.SourceVersion` commit for a PR build is the merge commit (not the commit on the source branch).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.<br><br>Also, this variable is only available on the step level and isn't available in the job or stage levels. That is, the message isn't extracted until the job starts and the code is checked out.<br><br>Note: The **Build.SourceVersionMessage** variable doesn't work with classic build pipelines in Bitbucket repositories when **Batch changes while a build is in progress** is enabled.

| Property | Value |
| --- | --- |
| Example | `Fix login bug` |
| Macro syntax | `$(Build.SourceVersionMessage)` |
| Runtime syntax | `$[ variables['Build.SourceVersionMessage'] ]` |
| Template syntax | Not available |

### Build.StageRequestedBy

The person who triggered the stage when the stage runs manually, or `Microsoft.VisualStudio.Services.TFS` otherwise. <br><br>Note: This value can contain whitespace or other invalid label characters.

| Property | Value |
| --- | --- |
| Example | `Jamal Hartnett` |
| Macro syntax | `$(Build.StageRequestedBy)` |
| Runtime syntax | `$[ variables['Build.StageRequestedBy'] ]` |
| Template syntax | Not available |

### Build.StageRequestedForId

The GUID of identity of the person who triggered the stage when the stage runs manually, or `00000002-0000-8888-8000-000000000000` otherwise.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.StageRequestedForId)` |
| Runtime syntax | `$[ variables['Build.StageRequestedForId'] ]` |
| Template syntax | Not available |

### Build.StagingDirectory

The local path on the agent where any artifacts are copied to before being pushed to their destination. For example: `c:\agent_work\1\a`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).<br><br>A typical way to use this folder is to publish your build artifacts with the [Copy files](/azure/devops/pipelines/tasks/reference/copy-files-v2) and [Publish build artifacts](/azure/devops/pipelines/tasks/reference/publish-build-artifacts-v1) tasks.<br><br>Note: Build.ArtifactStagingDirectory and Build.StagingDirectory are interchangeable. This directory is purged before each new build, so you don't have to clean it up yourself.<br><br> See [Artifacts in Azure Pipelines](../../artifacts/artifacts-overview.md).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Build.StagingDirectory)` |
| Runtime syntax | `$[ variables['Build.StagingDirectory'] ]` |
| Template syntax | Not available |

### Build.TriggeredBy.BuildId

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the BuildID of the triggering build. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.<br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead.

| Property | Value |
| --- | --- |
| Example | `1764` |
| Macro syntax | `$(Build.TriggeredBy.BuildId)` |
| Runtime syntax | `$[ variables['Build.TriggeredBy.BuildId'] ]` |
| Template syntax | Not available |

### Build.TriggeredBy.BuildNumber

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the number of the triggering build. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.<br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead.

| Property | Value |
| --- | --- |
| Example | `20260511.1` |
| Macro syntax | `$(Build.TriggeredBy.BuildNumber)` |
| Runtime syntax | `$[ variables['Build.TriggeredBy.BuildNumber'] ]` |
| Template syntax | Not available |

### Build.TriggeredBy.DefinitionId

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the DefinitionID of the triggering build. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. <br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead.

| Property | Value |
| --- | --- |
| Example | `42` |
| Macro syntax | `$(Build.TriggeredBy.DefinitionId)` |
| Runtime syntax | `$[ variables['Build.TriggeredBy.DefinitionId'] ]` |
| Template syntax | Not available |

### Build.TriggeredBy.DefinitionName

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the name of the triggering build pipeline. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. <br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead.

| Property | Value |
| --- | --- |
| Example | `MyApp-CI` |
| Macro syntax | `$(Build.TriggeredBy.DefinitionName)` |
| Runtime syntax | `$[ variables['Build.TriggeredBy.DefinitionName'] ]` |
| Template syntax | Not available |

### Build.TriggeredBy.ProjectID

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to ID of the project that contains the triggering build. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. <br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead.

| Property | Value |
| --- | --- |
| Example | `b3e7e7c4-0000-0000-0000-000000000000` |
| Macro syntax | `$(Build.TriggeredBy.ProjectID)` |
| Runtime syntax | `$[ variables['Build.TriggeredBy.ProjectID'] ]` |
| Template syntax | Not available |

### Checks.StageAttempt

Set to 1 the first time this stage is attempted, and increments every time the stage is retried.<br><br>This variable can only be used within an [approval or check](../../process/approvals.md) for an environment. For example, you could use `$(Checks.StageAttempt)` within an [Invoke REST API check](../../process/approvals.md#invoke-rest-api).<br><br>:::image type="content" source="../media/checks-stageattempt-var.png" alt-text="Add the stage attempt as a parameter.":::

| Property | Value |
| --- | --- |
| Macro syntax | `$(Checks.StageAttempt)` |
| Runtime syntax | `$[ variables['Checks.StageAttempt'] ]` |
| Template syntax | Not available |

### Common.TestResultsDirectory

The local path on the agent where the test results are created. For example: `c:\agent_work\1\TestResults`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Common.TestResultsDirectory)` |
| Runtime syntax | `$[ variables['Common.TestResultsDirectory'] ]` |
| Template syntax | Not available |

### Environment.Id

ID of the environment targeted in the deployment job. For example, `10`.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Environment.Id)` |
| Runtime syntax | `$[ variables['Environment.Id'] ]` |
| Template syntax | Not available |

### Environment.Name

Name of the environment targeted in the deployment job to run the deployment steps and record the deployment history. For example, `smarthotel-dev`.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Environment.Name)` |
| Runtime syntax | `$[ variables['Environment.Name'] ]` |
| Template syntax | Not available |

### Environment.ResourceId

ID of the specific resource within the environment targeted in the deployment job to run the deployment steps. For example, `4`.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Environment.ResourceId)` |
| Runtime syntax | `$[ variables['Environment.ResourceId'] ]` |
| Template syntax | Not available |

### Environment.ResourceName

Name of the specific resource within the environment targeted in the deployment job to run the deployment steps and record the deployment history. For example, `bookings` which is a Kubernetes namespace that is added as a resource to the environment `smarthotel-dev`.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Environment.ResourceName)` |
| Runtime syntax | `$[ variables['Environment.ResourceName'] ]` |
| Template syntax | Not available |

### Pipeline.Workspace

Workspace directory for a particular pipeline. This variable has the same value as `Agent.BuildDirectory`. For example, `/home/vsts/work/1`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).

| Property | Value |
| --- | --- |
| Macro syntax | `$(Pipeline.Workspace)` |
| Runtime syntax | `$[ variables['Pipeline.Workspace'] ]` |
| Template syntax | Not available |

### Strategy.CycleName

The current cycle name in a deployment. Options are `PreIteration`, `Iteration`, or `PostIteration`.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Strategy.CycleName)` |
| Runtime syntax | `$[ variables['Strategy.CycleName'] ]` |
| Template syntax | Not available |

### Strategy.Name

The name of the deployment strategy: `canary`, `runOnce`, or `rolling`.

| Property | Value |
| --- | --- |
| Macro syntax | `$(Strategy.Name)` |
| Runtime syntax | `$[ variables['Strategy.Name'] ]` |
| Template syntax | Not available |

### System.AccessToken

[Use the OAuth token to access the REST API](../../scripts/powershell.md#example-powershell-script-access-rest-api).<br><br>[Use System.AccessToken from YAML scripts](../variables.md#systemaccesstoken).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Example | `(opaque OAuth bearer token)` |
| Macro syntax | `$(System.AccessToken)` |
| Runtime syntax | Not available |
| Template syntax | `${{ variables['System.AccessToken'] }}` |

### System.AccessTokenRequestUri

The URI used to request a federated access token when calling Microsoft Entra ID. Companion to `System.OidcRequestUri` for workload identity federation. [Learn more](/azure/devops/release-notes/2024/sprint-240-update#pipelines-and-tasks-populate-variables-to-customize-workload-identity-federation-authentication)

| Property | Value |
| --- | --- |
| Example | `https://vstoken.dev.azure.com/...` |
| Macro syntax | `$(System.AccessTokenRequestUri)` |
| Runtime syntax | `$[ variables['System.AccessTokenRequestUri'] ]` |
| Template syntax | `${{ variables['System.AccessTokenRequestUri'] }}` |

### System.CollectionId

The GUID of the Azure DevOps organization or collection.

| Property | Value |
| --- | --- |
| Example | `6c6f3423-0000-0000-0000-000000000000` |
| Macro syntax | `$(System.CollectionId)` |
| Runtime syntax | `$[ variables['System.CollectionId'] ]` |
| Template syntax | `${{ variables['System.CollectionId'] }}` |

### System.CollectionUri

The URI of the Azure DevOps organization or collection.

| Property | Value |
| --- | --- |
| Example | `https://dev.azure.com/fabrikamfiber/` |
| Macro syntax | `$(System.CollectionUri)` |
| Runtime syntax | `$[ variables['System.CollectionUri'] ]` |
| Template syntax | `${{ variables['System.CollectionUri'] }}` |

### System.DefaultWorkingDirectory

[!INCLUDE [include](../includes/variables-build-sources-directory.md)]

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.DefaultWorkingDirectory)` |
| Runtime syntax | `$[ variables['System.DefaultWorkingDirectory'] ]` |
| Template syntax | `${{ variables['System.DefaultWorkingDirectory'] }}` |

### System.DefinitionId

The ID of the build pipeline.

| Property | Value |
| --- | --- |
| Example | `42` |
| Macro syntax | `$(System.DefinitionId)` |
| Runtime syntax | `$[ variables['System.DefinitionId'] ]` |
| Template syntax | `${{ variables['System.DefinitionId'] }}` |

### System.HostType

Set to `build` if the pipeline is a build. For a release, the values are `deployment` for a Deployment group job, `gates` during evaluation of gates, and `release` for other (Agent and Agentless) jobs.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.HostType)` |
| Runtime syntax | `$[ variables['System.HostType'] ]` |
| Template syntax | `${{ variables['System.HostType'] }}` |

### System.IsTriggeringRepository

Set to `True` for the repository whose change triggered the run. Useful in multi-repository checkouts to detect which repository caused the run.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.IsTriggeringRepository)` |
| Runtime syntax | `$[ variables['System.IsTriggeringRepository'] ]` |
| Template syntax | `${{ variables['System.IsTriggeringRepository'] }}` |

### System.JobAttempt

Set to 1 the first time this job is attempted, and increments every time the job is retried.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.JobAttempt)` |
| Runtime syntax | `$[ variables['System.JobAttempt'] ]` |
| Template syntax | Not available |

### System.JobDisplayName

The human-readable name given to a job.

| Property | Value |
| --- | --- |
| Example | `Build` |
| Macro syntax | `$(System.JobDisplayName)` |
| Runtime syntax | `$[ variables['System.JobDisplayName'] ]` |
| Template syntax | Not available |

### System.JobId

A unique identifier for a single attempt of a single job. The value is unique to the current pipeline.

| Property | Value |
| --- | --- |
| Example | `12f1170f-0000-0000-0000-000000000000` |
| Macro syntax | `$(System.JobId)` |
| Runtime syntax | `$[ variables['System.JobId'] ]` |
| Template syntax | Not available |

### System.JobIdentifier

A composite identifier for a job, including matrix and multi-config slice information. Use `System.JobName` for the human-readable job name.

| Property | Value |
| --- | --- |
| Example | `Build.Build.__default` |
| Macro syntax | `$(System.JobIdentifier)` |
| Runtime syntax | `$[ variables['System.JobIdentifier'] ]` |
| Template syntax | Not available |

### System.JobName

The name of the job, typically used for expressing dependencies and accessing output variables.

| Property | Value |
| --- | --- |
| Example | `Build` |
| Macro syntax | `$(System.JobName)` |
| Runtime syntax | `$[ variables['System.JobName'] ]` |
| Template syntax | Not available |

### System.OidcRequestUri

Generate an `idToken` for authentication with Entra ID using OpenID Connect (OIDC). [Learn more](/azure/devops/release-notes/2024/sprint-240-update#pipelines-and-tasks-populate-variables-to-customize-workload-identity-federation-authentication)

| Property | Value |
| --- | --- |
| Example | `https://vstoken.dev.azure.com/...` |
| Macro syntax | `$(System.OidcRequestUri)` |
| Runtime syntax | `$[ variables['System.OidcRequestUri'] ]` |
| Template syntax | `${{ variables['System.OidcRequestUri'] }}` |

### System.PhaseAttempt

Set to 1 the first time this phase is attempted, and increments every time the job is retried.<br><br>Note: "Phase" is a mostly redundant concept, which represents the design-time for a job (whereas job was the runtime version of a phase). The concept of *phase* is mostly removed from Azure Pipelines. Matrix and multi-config jobs are the only place where a phase is still distinct from a job. One phase can instantiate multiple jobs, which differ only in their inputs.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.PhaseAttempt)` |
| Runtime syntax | `$[ variables['System.PhaseAttempt'] ]` |
| Template syntax | Not available |

### System.PhaseDisplayName

The human-readable name given to a phase.

| Property | Value |
| --- | --- |
| Example | `Build` |
| Macro syntax | `$(System.PhaseDisplayName)` |
| Runtime syntax | `$[ variables['System.PhaseDisplayName'] ]` |
| Template syntax | Not available |

### System.PhaseName

A string-based identifier for a job, typically used for expressing dependencies and accessing output variables.

| Property | Value |
| --- | --- |
| Example | `Phase_1` |
| Macro syntax | `$(System.PhaseName)` |
| Runtime syntax | `$[ variables['System.PhaseName'] ]` |
| Template syntax | Not available |

### System.PlanId

A string-based identifier for a single pipeline run.

| Property | Value |
| --- | --- |
| Example | `9e4ec8c3-0000-0000-0000-000000000000` |
| Macro syntax | `$(System.PlanId)` |
| Runtime syntax | `$[ variables['System.PlanId'] ]` |
| Template syntax | Not available |

### System.PullRequest.ForkSecretsRemoved

Set to `True` when secret variables have been stripped from a pull request build because the PR comes from a fork. Otherwise unset or `False`. Use this to detect when secret-dependent steps should be skipped.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.PullRequest.ForkSecretsRemoved)` |
| Runtime syntax | `$[ variables['System.PullRequest.ForkSecretsRemoved'] ]` |
| Template syntax | Not available |

### System.PullRequest.IsFork

If the pull request is from a fork of the repository, this variable is set to `True`.<br><br>Otherwise, it's set to `False`.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.PullRequest.IsFork)` |
| Runtime syntax | `$[ variables['System.PullRequest.IsFork'] ]` |
| Template syntax | `${{ variables['System.PullRequest.IsFork'] }}` |

### System.PullRequest.MergedAt

The ISO 8601 timestamp when the pull request was merged. Example: `2026-05-11T18:30:00Z`

**Scope and availability:**

- Only available for **GitHub-connected repositories**. This variable is never set for Azure Repos pull requests.
- Only populated when a pipeline is triggered by a **GitHub PR merge event**. When a GitHub PR is merged, GitHub sends a "closed" webhook to Azure DevOps, which queues a new build on the merge commit with this variable set to the merge timestamp.
- Empty (`""`) during normal PR validation runs (the pipeline that runs while the PR is still open).

**When to use it:**

Use this variable to distinguish a post-merge pipeline run from a pre-merge validation run. For example, you can conditionally run deployment steps only after the PR has been merged:

```yaml
- script: echo "PR was merged at $(System.PullRequest.MergedAt)"
  condition: ne(variables['System.PullRequest.MergedAt'], '')
```

You can also check `Build.Reason` (which is `PullRequest` for both pre- and post-merge runs triggered by a GitHub PR) together with this variable to identify the exact build context.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.PullRequest.MergedAt)` |
| Runtime syntax | `$[ variables['System.PullRequest.MergedAt'] ]` |
| Template syntax | Not available |

### System.PullRequest.PullRequestId

The ID of the pull request that caused this build. For example: `17`. (This variable is initialized only if the build ran because of a [Git PR affected by a branch policy](../../../repos/git/branch-policies.md#build-validation)).

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.PullRequest.PullRequestId)` |
| Runtime syntax | `$[ variables['System.PullRequest.PullRequestId'] ]` |
| Template syntax | Not available |

### System.PullRequest.PullRequestIteration

The PR iteration that caused the build. Each new push to a PR that re-runs validation increments this value (1, 2, 3, ...). Useful for differentiating between PR builds for the same `System.PullRequest.PullRequestId`.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.PullRequest.PullRequestIteration)` |
| Runtime syntax | `$[ variables['System.PullRequest.PullRequestIteration'] ]` |
| Template syntax | Not available |

### System.PullRequest.PullRequestNumber

The number of the pull request that caused this build. This variable is populated for pull requests from GitHub that have a different pull request ID and pull request number. This variable is only available in a YAML pipeline if a branch policy affects the PR.

| Property | Value |
| --- | --- |
| Example | `42` |
| Macro syntax | `$(System.PullRequest.PullRequestNumber)` |
| Runtime syntax | `$[ variables['System.PullRequest.PullRequestNumber'] ]` |
| Template syntax | Not available |

### System.PullRequest.SourceBranch

The branch that is being reviewed in a pull request. For example: `refs/heads/users/raisa/new-feature` for Azure Repos. (This variable is initialized only if the build ran because of a [Git PR affected by a branch policy](../../../repos/git/branch-policies.md#build-validation)). This variable is only available in a YAML pipeline if a branch policy affects the PR.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.PullRequest.SourceBranch)` |
| Runtime syntax | `$[ variables['System.PullRequest.SourceBranch'] ]` |
| Template syntax | Not available |

### System.PullRequest.SourceCommitId

The commit that is being reviewed in a pull request. (This variable is initialized only if the build ran because of a [Git PR affected by a branch policy](../../../repos/git/branch-policies.md#build-validation)). This variable is only available in a YAML pipeline if a branch policy affects the PR.

| Property | Value |
| --- | --- |
| Example | `a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0` |
| Macro syntax | `$(System.PullRequest.SourceCommitId)` |
| Runtime syntax | `$[ variables['System.PullRequest.SourceCommitId'] ]` |
| Template syntax | Not available |

### System.PullRequest.SourceRepositoryUri

The URL to the repo that contains the pull request.

| Property | Value |
| --- | --- |
| Example | `https://dev.azure.com/ouraccount/_git/OurProject` |
| Macro syntax | `$(System.PullRequest.SourceRepositoryUri)` |
| Runtime syntax | `$[ variables['System.PullRequest.SourceRepositoryUri'] ]` |
| Template syntax | Not available |

### System.PullRequest.TargetBranch

The branch that is the target of a pull request. For example: `refs/heads/main` when your repository is in Azure Repos and `main` when your repository is in GitHub. This variable is initialized only if the build ran because of a [Git PR affected by a branch policy](../../../repos/git/branch-policies.md#build-validation). This variable is only available in a YAML pipeline if a branch policy affects the PR.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.PullRequest.TargetBranch)` |
| Runtime syntax | `$[ variables['System.PullRequest.TargetBranch'] ]` |
| Template syntax | Not available |

### System.PullRequest.targetBranchName

The name of the target branch for a pull request. This variable can be used in a pipeline to conditionally execute tasks or steps based on the target branch of the pull request. For example, you might want to trigger a different set of tests or code analysis tools depending on the branch that the changes are being merged into.

| Property | Value |
| --- | --- |
| Example | `main` |
| Macro syntax | `$(System.PullRequest.targetBranchName)` |
| Runtime syntax | `$[ variables['System.PullRequest.targetBranchName'] ]` |
| Template syntax | Not available |

### System.StageAttempt

Set to 1 the first time this stage is attempted, and increments every time the stage is retried.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.StageAttempt)` |
| Runtime syntax | `$[ variables['System.StageAttempt'] ]` |
| Template syntax | Not available |

### System.StageDisplayName

The human-readable name given to a stage.

| Property | Value |
| --- | --- |
| Example | `Build` |
| Macro syntax | `$(System.StageDisplayName)` |
| Runtime syntax | `$[ variables['System.StageDisplayName'] ]` |
| Template syntax | Not available |

### System.StageName

A string-based identifier for a stage, typically used for expressing dependencies and accessing output variables.

| Property | Value |
| --- | --- |
| Example | `Stage_1` |
| Macro syntax | `$(System.StageName)` |
| Runtime syntax | `$[ variables['System.StageName'] ]` |
| Template syntax | Not available |

### System.TeamFoundationCollectionUri

The URI of the Azure DevOps organization or collection. For example: `https://dev.azure.com/fabrikamfiber/`.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(System.TeamFoundationCollectionUri)` |
| Runtime syntax | `$[ variables['System.TeamFoundationCollectionUri'] ]` |
| Template syntax | `${{ variables['System.TeamFoundationCollectionUri'] }}` |

### System.TeamProject

The name of the project that contains this build.

| Property | Value |
| --- | --- |
| Example | `Fabrikam` |
| Macro syntax | `$(System.TeamProject)` |
| Runtime syntax | `$[ variables['System.TeamProject'] ]` |
| Template syntax | `${{ variables['System.TeamProject'] }}` |

### System.TeamProjectId

The ID of the project that this build belongs to.

| Property | Value |
| --- | --- |
| Example | `b3e7e7c4-0000-0000-0000-000000000000` |
| Macro syntax | `$(System.TeamProjectId)` |
| Runtime syntax | `$[ variables['System.TeamProjectId'] ]` |
| Template syntax | `${{ variables['System.TeamProjectId'] }}` |

### System.TimelineId

A string-based identifier for the execution details and logs of a single pipeline run.

| Property | Value |
| --- | --- |
| Example | `33b55a2d-0000-0000-0000-000000000000` |
| Macro syntax | `$(System.TimelineId)` |
| Runtime syntax | `$[ variables['System.TimelineId'] ]` |
| Template syntax | Not available |

### TF_BUILD

A sentinel variable that the agent sets to `True` on every task in a pipeline run. Scripts and tools use `TF_BUILD` to detect that they're running inside Azure Pipelines (as opposed to a local developer machine or another CI system), so they can suppress interactive prompts, disable progress spinners, or change output formatting for non-interactive logs. The name is a legacy holdover from Team Foundation Build, which is why it doesn't follow the `Build.` / `System.` / `Agent.` naming convention.<br><br>`TF_BUILD` is set agent-side, so it's available only during job execution. It isn't defined for template-expression evaluation, and it isn't present at all when scripts run outside of a pipeline.<br><br>Example: skip a long-running profile build when running locally:

# [PowerShell](#tab/powershell)

```powershell
if ($env:TF_BUILD -eq 'True') {
    .\build.ps1 -CI
} else {
    .\build.ps1 -Interactive
}
```

# [Bash](#tab/bash)

```bash
if [ "$TF_BUILD" = "True" ]; then
  ./build.sh --no-progress --ci
else
  ./build.sh --interactive
fi
```

# [Batch](#tab/batch)

```bat
if "%TF_BUILD%"=="True" (
    call build.cmd /ci
) else (
    call build.cmd /interactive
)
```

---

This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

| Property | Value |
| --- | --- |
| Macro syntax | `$(TF_BUILD)` |
| Runtime syntax | `$[ variables['TF_BUILD'] ]` |
| Template syntax | Not available |


> [!TIP]
> If you're using classic release pipelines, you can use [classic releases and artifacts variables](../../release/variables.md) to store and access data throughout your pipeline.
