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

The **Template `${{ }}`**, **Macro `$(var)`**, and **Runtime `$[ ]`** columns indicate availability in each form: ✓ = available, ✗ = not available. When you reference a variable in a [template](../../process/templates.md) that isn't marked as available in templates, the expression doesn't render because the value isn't accessible within the template's scope. You can use agent variables as environment variables in scripts and as parameters in build tasks; you can't use them to customize the build number or to apply a version control label or tag.

> [!div class="mx-tdCol2BreakAll"]
> | Variable | Description | Template | Macro | Runtime |
> |:---------|:------------|:---------|:------|:--------|
> | [Agent.BuildDirectory](#agentbuilddirectory) | The local path on the agent where all folders for a given build pipeline are created. | ✗ | ✓ | ✓ |
> | [Agent.ContainerMapping](#agentcontainermapping) | A mapping from container resource names in YAML to their Docker IDs at runtime. | ✗ | ✓ | ✓ |
> | [Agent.HomeDirectory](#agenthomedirectory) | The directory the agent is installed into. | ✗ | ✓ | ✓ |
> | [Agent.Id](#agentid) | The ID of the agent. | ✗ | ✓ | ✓ |
> | [Agent.JobName](#agentjobname) | The name of the running job. | ✗ | ✓ | ✓ |
> | [Agent.JobStatus](#agentjobstatus) | The status of the build. | ✗ | ✓ | ✓ |
> | [Agent.MachineName](#agentmachinename) | The name of the machine on which the agent is installed. | ✗ | ✓ | ✓ |
> | [Agent.Name](#agentname) | The name of the agent that is registered with the pool. | ✗ | ✓ | ✓ |
> | [Agent.OS](#agentos) | The operating system of the agent host. | ✗ | ✓ | ✓ |
> | [Agent.OSArchitecture](#agentosarchitecture) | The operating system processor architecture of the agent host. | ✗ | ✓ | ✓ |
> | [Agent.TempDirectory](#agenttempdirectory) | A temporary folder that is cleaned after each pipeline job. | ✗ | ✓ | ✓ |
> | [Agent.ToolsDirectory](#agenttoolsdirectory) | The directory used by tasks such as [Node Tool Installer](/azure/devops/pipelines/tasks/reference/node-tool-v0) and [Use Python... | ✗ | ✓ | ✓ |
> | [Agent.WorkFolder](#agentworkfolder) | The working directory for this agent. | ✗ | ✓ | ✓ |
> | [Build.ArtifactStagingDirectory](#buildartifactstagingdirectory) | The local path on the agent where any artifacts are copied to before being pushed to their destination. | ✗ | ✓ | ✓ |
> | [Build.BinariesDirectory](#buildbinariesdirectory) | The local path on the agent you can use as an output folder for compiled binaries. | ✗ | ✓ | ✓ |
> | [Build.BuildId](#buildbuildid) | The ID of the record for the completed build. | ✗ | ✓ | ✓ |
> | [Build.BuildNumber](#buildbuildnumber) | The name of the completed build, also known as the run number. | ✗ | ✓ | ✓ |
> | [Build.BuildUri](#buildbuilduri) | The URI for the build. | ✗ | ✓ | ✓ |
> | [Build.ContainerId](#buildcontainerid) | The ID of the container for your artifact. | ✗ | ✓ | ✓ |
> | [Build.CronSchedule.DisplayName](#buildcronscheduledisplayname) | The `displayName` of the cron schedule that triggered the pipeline run. | ✓ | ✓ | ✓ |
> | [Build.DefinitionFolderPath](#builddefinitionfolderpath) | The folder path of the pipeline definition in the **Pipelines** list. | ✓ | ✓ | ✓ |
> | [Build.DefinitionName](#builddefinitionname) | The name of the build pipeline. | ✓ | ✓ | ✓ |
> | [Build.DefinitionVersion](#builddefinitionversion) | The version of the build pipeline. | ✓ | ✓ | ✓ |
> | [Build.QueuedBy](#buildqueuedby) | See [How are the identity variables set?](#identity_values). | ✓ | ✓ | ✓ |
> | [Build.QueuedById](#buildqueuedbyid) | See [How are the identity variables set?](#identity_values). | ✓ | ✓ | ✓ |
> | [Build.Reason](#buildreason) | The event that caused the build to run. | ✓ | ✓ | ✓ |
> | [Build.Repository.Clean](#buildrepositoryclean) | The value you selected for **Clean** in the [source repository settings](../../repos/index.md). | ✗ | ✓ | ✓ |
> | [Build.Repository.Git.SubmoduleCheckout](#buildrepositorygitsubmodulecheckout) | The value you selected for **Checkout submodules** on the [repository tab](../../repos/index.md). | ✗ | ✓ | ✓ |
> | [Build.Repository.ID](#buildrepositoryid) | The unique identifier of the [repository](../../repos/index.md). | ✓ | ✓ | ✓ |
> | [Build.Repository.LocalPath](#buildrepositorylocalpath) | The local path on the agent where your source code files are downloaded. | ✗ | ✓ | ✓ |
> | [Build.Repository.Name](#buildrepositoryname) | The name of the triggering [repository](../../repos/index.md). | ✓ | ✓ | ✓ |
> | [Build.Repository.Provider](#buildrepositoryprovider) | The type of the triggering [repository](../../repos/index.md). | ✗ | ✓ | ✓ |
> | [Build.Repository.Tfvc.Workspace](#buildrepositorytfvcworkspace) | Defined if your [repository](../../repos/index.md) is Team Foundation Version Control. | ✗ | ✓ | ✓ |
> | [Build.Repository.Uri](#buildrepositoryuri) | The URL for the triggering repository. | ✓ | ✓ | ✓ |
> | [Build.RequestedFor](#buildrequestedfor) | See [How are the identity variables set?](#identity_values). | ✓ | ✓ | ✓ |
> | [Build.RequestedForEmail](#buildrequestedforemail) | See [How are the identity variables set?](#identity_values). | ✓ | ✓ | ✓ |
> | [Build.RequestedForId](#buildrequestedforid) | See [How are the identity variables set?](#identity_values). | ✓ | ✓ | ✓ |
> | [Build.SourceBranch](#buildsourcebranch) | The branch of the triggering repo the build was queued for. | ✓ | ✓ | ✓ |
> | [Build.SourceBranchName](#buildsourcebranchname) | The name of the branch in the triggering repo the build was queued for. | ✓ | ✓ | ✓ |
> | [Build.SourcesDirectory](#buildsourcesdirectory) | The local path on the agent where your source code files are downloaded. | ✗ | ✓ | ✓ |
> | [Build.SourceTfvcShelveset](#buildsourcetfvcshelveset) | Defined if your [repository](../../repos/index.md) is Team Foundation Version Control. | ✗ | ✓ | ✓ |
> | [Build.SourceVersion](#buildsourceversion) | The latest version control change of the triggering repo that is included in this build. | ✓ | ✓ | ✓ |
> | [Build.SourceVersionAuthor](#buildsourceversionauthor) | The display name of the author of the commit referenced by `Build.SourceVersion`. | ✓ | ✓ | ✓ |
> | [Build.SourceVersionMessage](#buildsourceversionmessage) | The comment of the commit or changeset for the triggering repo. | ✗ | ✓ | ✓ |
> | [Build.StageRequestedBy](#buildstagerequestedby) | The person who triggered the stage when the stage runs manually, or `Microsoft.VisualStudio.Services.TFS` otherwise. | ✗ | ✓ | ✓ |
> | [Build.StageRequestedForId](#buildstagerequestedforid) | The GUID of identity of the person who triggered the stage when the stage runs manually, or `00000002-0000-8888-8000-000000000000`... | ✗ | ✓ | ✓ |
> | [Build.StagingDirectory](#buildstagingdirectory) | The local path on the agent where any artifacts are copied to before being pushed to their destination. | ✗ | ✓ | ✓ |
> | [Build.TriggeredBy.BuildId](#buildtriggeredbybuildid) | If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the BuildID of the triggering build. | ✗ | ✓ | ✓ |
> | [Build.TriggeredBy.BuildNumber](#buildtriggeredbybuildnumber) | If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the number of the triggering build. | ✗ | ✓ | ✓ |
> | [Build.TriggeredBy.DefinitionId](#buildtriggeredbydefinitionid) | If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the DefinitionID of the... | ✗ | ✓ | ✓ |
> | [Build.TriggeredBy.DefinitionName](#buildtriggeredbydefinitionname) | If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the name of the triggering build... | ✗ | ✓ | ✓ |
> | [Build.TriggeredBy.ProjectID](#buildtriggeredbyprojectid) | If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to ID of the project that contains... | ✗ | ✓ | ✓ |
> | [Checks.StageAttempt](#checksstageattempt) | Set to 1 the first time this stage is attempted, and increments every time the stage is retried. | ✗ | ✓ | ✓ |
> | [Common.TestResultsDirectory](#commontestresultsdirectory) | The local path on the agent where the test results are created. | ✗ | ✓ | ✓ |
> | [Environment.Id](#environmentid) | ID of the environment targeted in the deployment job. | ✗ | ✓ | ✓ |
> | [Environment.Name](#environmentname) | Name of the environment targeted in the deployment job to run the deployment steps and record the deployment history. | ✗ | ✓ | ✓ |
> | [Environment.ResourceId](#environmentresourceid) | ID of the specific resource within the environment targeted in the deployment job to run the deployment steps. | ✗ | ✓ | ✓ |
> | [Environment.ResourceName](#environmentresourcename) | Name of the specific resource within the environment targeted in the deployment job to run the deployment steps and record the... | ✗ | ✓ | ✓ |
> | [Pipeline.Workspace](#pipelineworkspace) | Workspace directory for a particular pipeline. | ✗ | ✓ | ✓ |
> | [Strategy.CycleName](#strategycyclename) | The current cycle name in a deployment. | ✗ | ✓ | ✓ |
> | [Strategy.Name](#strategyname) | The name of the deployment strategy: `canary`, `runOnce`, or `rolling`. | ✗ | ✓ | ✓ |
> | [System.AccessToken](#systemaccesstoken) | [Use the OAuth token to access the REST API](../../scripts/powershell.md#example-powershell-script-access-rest-api). | ✓ | ✓ | ✗ |
> | [System.AccessTokenRequestUri](#systemaccesstokenrequesturi) | The URI used to request a federated access token when calling Microsoft Entra ID. | ✓ | ✓ | ✓ |
> | [System.CollectionId](#systemcollectionid) | The GUID of the Azure DevOps organization or collection. | ✓ | ✓ | ✓ |
> | [System.CollectionUri](#systemcollectionuri) | The URI of the Azure DevOps organization or collection. | ✓ | ✓ | ✓ |
> | [System.DefaultWorkingDirectory](#systemdefaultworkingdirectory) | [!INCLUDE [include](../includes/variables-build-sources-directory.md)] | ✓ | ✓ | ✓ |
> | [System.DefinitionId](#systemdefinitionid) | The ID of the build pipeline. | ✓ | ✓ | ✓ |
> | [System.HostType](#systemhosttype) | Set to `build` if the pipeline is a build. | ✓ | ✓ | ✓ |
> | [System.IsTriggeringRepository](#systemistriggeringrepository) | Set to `True` for the repository whose change triggered the run. | ✓ | ✓ | ✓ |
> | [System.JobAttempt](#systemjobattempt) | Set to 1 the first time this job is attempted, and increments every time the job is retried. | ✗ | ✓ | ✓ |
> | [System.JobDisplayName](#systemjobdisplayname) | The human-readable name given to a job. | ✗ | ✓ | ✓ |
> | [System.JobId](#systemjobid) | A unique identifier for a single attempt of a single job. | ✗ | ✓ | ✓ |
> | [System.JobIdentifier](#systemjobidentifier) | A composite identifier for a job, including matrix and multi-config slice information. | ✗ | ✓ | ✓ |
> | [System.JobName](#systemjobname) | The name of the job, typically used for expressing dependencies and accessing output variables. | ✗ | ✓ | ✓ |
> | [System.OidcRequestUri](#systemoidcrequesturi) | Generate an `idToken` for authentication with Entra ID using OpenID Connect (OIDC). | ✓ | ✓ | ✓ |
> | [System.PhaseAttempt](#systemphaseattempt) | Set to 1 the first time this phase is attempted, and increments every time the job is retried. | ✗ | ✓ | ✓ |
> | [System.PhaseDisplayName](#systemphasedisplayname) | The human-readable name given to a phase. | ✗ | ✓ | ✓ |
> | [System.PhaseName](#systemphasename) | A string-based identifier for a job, typically used for expressing dependencies and accessing output variables. | ✗ | ✓ | ✓ |
> | [System.PlanId](#systemplanid) | A string-based identifier for a single pipeline run. | ✗ | ✓ | ✓ |
> | [System.PullRequest.ForkSecretsRemoved](#systempullrequestforksecretsremoved) | Set to `True` when secret variables have been stripped from a pull request build because the PR comes from a fork. | ✗ | ✓ | ✓ |
> | [System.PullRequest.IsFork](#systempullrequestisfork) | If the pull request is from a fork of the repository, this variable is set to `True`. | ✓ | ✓ | ✓ |
> | [System.PullRequest.MergedAt](#systempullrequestmergedat) | The ISO 8601 timestamp when the pull request was merged. | ✗ | ✓ | ✓ |
> | [System.PullRequest.PullRequestId](#systempullrequestpullrequestid) | The ID of the pull request that caused this build. | ✗ | ✓ | ✓ |
> | [System.PullRequest.PullRequestIteration](#systempullrequestpullrequestiteration) | The PR iteration that caused the build. | ✗ | ✓ | ✓ |
> | [System.PullRequest.PullRequestNumber](#systempullrequestpullrequestnumber) | The number of the pull request that caused this build. | ✗ | ✓ | ✓ |
> | [System.PullRequest.SourceBranch](#systempullrequestsourcebranch) | The branch that is being reviewed in a pull request. | ✗ | ✓ | ✓ |
> | [System.PullRequest.SourceCommitId](#systempullrequestsourcecommitid) | The commit that is being reviewed in a pull request. | ✗ | ✓ | ✓ |
> | [System.PullRequest.SourceRepositoryUri](#systempullrequestsourcerepositoryuri) | The URL to the repo that contains the pull request. | ✗ | ✓ | ✓ |
> | [System.PullRequest.TargetBranch](#systempullrequesttargetbranch) | The branch that is the target of a pull request. | ✗ | ✓ | ✓ |
> | [System.PullRequest.targetBranchName](#systempullrequesttargetbranchname) | The name of the target branch for a pull request. | ✗ | ✓ | ✓ |
> | [System.StageAttempt](#systemstageattempt) | Set to 1 the first time this stage is attempted, and increments every time the stage is retried. | ✗ | ✓ | ✓ |
> | [System.StageDisplayName](#systemstagedisplayname) | The human-readable name given to a stage. | ✗ | ✓ | ✓ |
> | [System.StageName](#systemstagename) | A string-based identifier for a stage, typically used for expressing dependencies and accessing output variables. | ✗ | ✓ | ✓ |
> | [System.TeamFoundationCollectionUri](#systemteamfoundationcollectionuri) | The URI of the Azure DevOps organization or collection. | ✓ | ✓ | ✓ |
> | [System.TeamProject](#systemteamproject) | The name of the project that contains this build. | ✓ | ✓ | ✓ |
> | [System.TeamProjectId](#systemteamprojectid) | The ID of the project that this build belongs to. | ✓ | ✓ | ✓ |
> | [System.TimelineId](#systemtimelineid) | A string-based identifier for the execution details and logs of a single pipeline run. | ✗ | ✓ | ✓ |
> | [TF_BUILD](#tf_build) | Sentinel set to `True` whenever a script runs inside an Azure Pipelines task; used to detect the CI environment. | ✗ | ✓ | ✓ |

### Agent.BuildDirectory

The local path on the agent where all folders for a given build pipeline are created. This variable has the same value as `Pipeline.Workspace`. For example: `/home/vsts/work/1`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

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

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.HomeDirectory

The directory the agent is installed into. This variable contains the agent software. For example: `c:\agent`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.Id

The ID of the agent. Example: `2`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.JobName

The name of the running job. This name is usually `Job`; or `__default`, but in multi-config scenarios, it's the configuration.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.JobStatus

The status of the build.<br><br>• `Canceled`<br>• `Failed`<br>• `Succeeded`<br>• `SucceededWithIssues` (partially successful)<br>• `Skipped` (last job)<br><br>The environment variable should be referenced as `AGENT_JOBSTATUS`. The older `agent.jobstatus` is available for backwards compatibility.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.MachineName

The name of the machine on which the agent is installed. Example: `fv-az200-123`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.Name

The name of the agent that is registered with the pool.<br><br>If you're using a self-hosted agent, you specify the name. See [agents](../../agents/agents.md). Example: `Hosted Agent`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.OS

The operating system of the agent host. Valid values are:<br><br>• `Windows_NT`<br>• `Darwin`<br>• `Linux`<br><br>If you're running in a container, the agent host and container can  run different operating systems.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.OSArchitecture

The operating system processor architecture of the agent host. Valid values are:<br><br>• `X86`<br>• `X64`<br>• `ARM`<br><br>

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.TempDirectory

A temporary folder that is cleaned after each pipeline job. This directory is used by tasks such as [.NET Core CLI task](/azure/devops/pipelines/tasks/reference/dotnet-core-cli-v2) to hold temporary items like test results before they're published.<br><br>For example: `/home/vsts/work/_temp` for Ubuntu.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.ToolsDirectory

The directory used by tasks such as [Node Tool Installer](/azure/devops/pipelines/tasks/reference/node-tool-v0) and [Use Python Version](/azure/devops/pipelines/tasks/reference/use-python-version-v0) to switch between multiple versions of a tool.<br><br>These tasks add tools from this directory to `PATH` so that subsequent build steps can use them.<br><br>Learn about [managing this directory on a self-hosted agent](https://go.microsoft.com/fwlink/?linkid=2008884). Example: `/opt/hostedtoolcache`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Agent.WorkFolder

The working directory for this agent.<br><br>For example: `c:\agent_work`.<br><br>Note: This directory isn't guaranteed to be writable by pipeline tasks (for example, when mapped into a container). For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.ArtifactStagingDirectory

The local path on the agent where any artifacts are copied to before being pushed to their destination. For example: `c:\agent_work\1\a`.<br><br>A typical way to use this folder is to publish your build artifacts with the [Copy files](/azure/devops/pipelines/tasks/reference/copy-files-v2) and [Publish build artifacts](/azure/devops/pipelines/tasks/reference/publish-build-artifacts-v1) tasks.<br><br>Note: Build.ArtifactStagingDirectory and Build.StagingDirectory are interchangeable. This directory is purged before each new build, so you don't have to clean it up yourself.<br><br>See [Artifacts in Azure Pipelines](../../artifacts/artifacts-overview.md). For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure). <br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.BinariesDirectory

The local path on the agent you can use as an output folder for compiled binaries.<br><br> On self-hosted agents, new build pipelines aren't set up to clean this directory by default. You can define your build to clean it up on the [Repository tab](../../repos/index.md).<br><br>For example: `c:\agent_work\1\b`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.BuildId

The ID of the record for the completed build. Example: `1764`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.BuildNumber

The name of the completed build, also known as the run number. You can specify [what is included](../../process/run-number.md) in this value.<br><br>A typical use of this variable is to make it part of the label format, which you specify on the [repository tab](../../repos/index.md).<br><br>Note: This value can contain whitespace or other invalid label characters. In these cases, the [label format](../../../repos/tfvc/labels-command.md) fails.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. Example: `20260511.1`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.BuildUri

The URI for the build. For example: `vstfs:///Build/Build/1430`.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.ContainerId

The ID of the container for your artifact. When you upload an artifact in your pipeline, it's added to a container that is specific for that particular artifact. Example: `2713905`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.CronSchedule.DisplayName

The `displayName` of the cron schedule that triggered the pipeline run. This variable is only set if a YAML scheduled trigger triggers the pipeline run. For more information, see [schedules.cron definition - Build.CronSchedule.DisplayName variable](/azure/devops/pipelines/yaml-schema/schedules-cron#buildcronscheduledisplayname-variable). Example: `Nightly build`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.DefinitionFolderPath

The folder path of the pipeline definition in the **Pipelines** list. For example, a pipeline at `\Infrastructure\Deploy\nightly-deploy` returns `\Infrastructure\Deploy`. Empty for pipelines at the root.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.DefinitionName

The name of the build pipeline.<br><br>Note: This value can contain whitespace or other invalid label characters. In these cases, the [label format](../../../repos/tfvc/labels-command.md) fails. Example: `MyApp-CI`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.DefinitionVersion

The version of the build pipeline. Example: `1`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.QueuedBy

See [How are the identity variables set?](#identity_values).<br><br>Note: This value can contain whitespace or other invalid label characters. In these cases, the [label format](../../../repos/tfvc/labels-command.md) fails. Example: `Jamal Hartnett`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.QueuedById

See [How are the identity variables set?](#identity_values). Example: `a1b2c3d4-0000-0000-0000-000000000000`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

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

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.Repository.Clean

The value you selected for **Clean** in the [source repository settings](../../repos/index.md).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. Example: `true`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.Repository.Git.SubmoduleCheckout

The value you selected for **Checkout submodules** on the [repository tab](../../repos/index.md). With multiple repos checked out, this value tracks the triggering repository's setting.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. Example: `true`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.Repository.ID

The unique identifier of the [repository](../../repos/index.md).<br><br>This value doesn't change, even if the name of the repository does. Example: `b3e7e7c4-0000-0000-0000-000000000000`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.Repository.LocalPath

The local path on the agent where your source code files are downloaded. For example: `c:\agent_work\1\s`.<br><br>On self-hosted agents, new build pipelines update only the changed files by default. You can modify how files are downloaded on the [Repository tab](../../repos/index.md).<br><br>Important note: If you check out only one Git repository, this path is the exact path to the code.<br><br>If you check out multiple repositories, the behavior is as follows (and might differ from the value of the Build.SourcesDirectory variable):<br><ul><li>If the checkout step for the self (primary) repository has no custom checkout path defined, or the checkout path is the multi-checkout default path `$(Pipeline.Workspace)/s/&<RepoName>` for the self repository, the value of this variable reverts to its default value, which is `$(Pipeline.Workspace)/s`.</li><li>If the checkout step for the self (primary) repository had a custom checkout path defined that is not its multi-checkout default path, this variable contains the exact path to the self repository.</li></ul>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.Repository.Name

The name of the triggering [repository](../../repos/index.md). Example: `Fabrikam-Scripts`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.Repository.Provider

The type of the triggering [repository](../../repos/index.md).<br><br>• `TfsGit`: [TFS Git repository](../../../repos/git/index.yml)<br>• `TfsVersionControl`: [Team Foundation Version Control](../../../repos/tfvc/what-is-tfvc.md)<br>• `Git`: Git repository hosted on an external server<br>• `GitHub`<br>• `Svn`: Subversion<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.Repository.Tfvc.Workspace

Defined if your [repository](../../repos/index.md) is Team Foundation Version Control. The name of the [TFVC workspace](../../../repos/tfvc/create-work-workspaces.md) used by the build agent.<br><br>For example, if the Agent.BuildDirectory is `c:\agent_work\12` and the Agent.Id is `8`, the workspace name could be: `ws_12_8`<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.Repository.Uri

The URL for the triggering repository. For example:<br><br>• Git: [https://fabrikamfiber@dev.azure.com/fabrikamfiber/_git/Scripts](https://fabrikamfiber@dev.azure.com/fabrikamfiber/_git/Scripts)<br>• TFVC: [https://dev.azure.com/fabrikamfiber/](https://dev.azure.com/fabrikamfiber/)<br><br>This variable can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.RequestedFor

See [How are the identity variables set?](#identity_values).<br><br>Note: This value can contain whitespace or other invalid label characters. In these cases, the [label format](../../../repos/tfvc/labels-command.md) fails. Example: `Jamal Hartnett`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.RequestedForEmail

See [How are the identity variables set?](#identity_values). Example: `fabrikamfiber4@example.com`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.RequestedForId

See [How are the identity variables set?](#identity_values). Example: `00000002-0000-8888-8000-000000000000`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.SourceBranch

The branch of the triggering repo the build was queued for. Some examples:<br><ul><li>Git repo branch: `refs/heads/main`</li><li>Git repo pull request: `refs/pull/1/merge`</li><li>TFVC repo branch: `$/teamproject/main`</li><li>TFVC repo gated check-in: `Gated_2016-06-06_05.20.51.4369;username@live.com`</li><li>TFVC repo shelveset build: `myshelveset;username@live.com`</li><li>When a tag triggers your pipeline: `refs/tags/your-tag-name`</li></ul>When you use this variable in your build number format, the forward slash characters (`/`) are replaced with underscore characters (`_`).<br><br>Note: In TFVC, if you're running a gated check-in build or manually building a shelveset, you can't use this variable in your build number format.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.SourceBranchName

The name of the branch in the triggering repo the build was queued for.<br><ul><li>Git repo branch, pull request, or tag: The last path segment in the ref. For example, in `refs/heads/main` this value is `main`. In `refs/heads/feature/tools`, this value is `tools`. In `refs/tags/your-tag-name`, the value is `your-tag-name`.</li><li>TFVC repo branch: The last path segment in the root server path for the workspace. For example, in `$/teamproject/main` this value is `main`.</li><li>TFVC repo gated check-in or shelveset build is the name of the shelveset. For example, `Gated_2016-06-06_05.20.51.4369;username@live.com` or `myshelveset;username@live.com`.</li></ul>Note: In TFVC, if you're running a gated check-in build or manually building a shelveset, you can't use this variable in your build number format.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.SourcesDirectory

The local path on the agent where your source code files are downloaded. For example: `c:\agent_work\1\s`.<br><br>On self-hosted agents, new build pipelines update only the changed files. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).<br><br>Important note: If you check out only one Git repository, this path is the exact path to the code. If you check out multiple repositories, it reverts to its default value, which is `$(Pipeline.Workspace)/s`, even if the self (primary) repository is checked out to a custom path different from its multi-checkout default path `$(Pipeline.Workspace)/s/<RepoName>` (in this respect, the variable differs from the behavior of the Build.Repository.LocalPath variable).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.SourceTfvcShelveset

Defined if your [repository](../../repos/index.md) is Team Foundation Version Control.<br><br>If you're running a [gated build](../../repos/tfvc.md#gated) or a [shelveset build](../../create-first-pipeline.md#queueabuild), this variable is set to the name of the [shelveset](../../../repos/tfvc/suspend-your-work-manage-your-shelvesets.md) you're building.<br><br>Note: This variable yields a value that is invalid for build use in a build number format. Example: `Gated_2026-05-11_05.20.51.4369;user@example.com`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.SourceVersion

The latest version control change of the triggering repo that is included in this build.<br><br>• Git: The [commit](../../../repos/git/commits.md) ID.<br>• TFVC: the [changeset](../../../repos/tfvc/find-view-changesets.md).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. Example: `a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.SourceVersionAuthor

The display name of the author of the commit referenced by `Build.SourceVersion`. This can differ from `Build.RequestedFor` (the user who triggered the run). Treated as personally identifiable information and scrubbed from agent diagnostic logs. Example: `Jamal Hartnett`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.SourceVersionMessage

The comment of the commit or changeset for the triggering repo. We truncate the message to the first line or 200 characters, whichever is shorter.<br><br>The `Build.SourceVersionMessage` corresponds to the message on `Build.SourceVersion` commit. The `Build.SourceVersion` commit for a PR build is the merge commit (not the commit on the source branch).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.<br><br>Also, this variable is only available on the step level and isn't available in the job or stage levels. That is, the message isn't extracted until the job starts and the code is checked out.<br><br>Note: The **Build.SourceVersionMessage** variable doesn't work with classic build pipelines in Bitbucket repositories when **Batch changes while a build is in progress** is enabled. Example: `Fix login bug`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.StageRequestedBy

The person who triggered the stage when the stage runs manually, or `Microsoft.VisualStudio.Services.TFS` otherwise. <br><br>Note: This value can contain whitespace or other invalid label characters. Example: `Jamal Hartnett`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.StageRequestedForId

The GUID of identity of the person who triggered the stage when the stage runs manually, or `00000002-0000-8888-8000-000000000000` otherwise.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.StagingDirectory

The local path on the agent where any artifacts are copied to before being pushed to their destination. For example: `c:\agent_work\1\a`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).<br><br>A typical way to use this folder is to publish your build artifacts with the [Copy files](/azure/devops/pipelines/tasks/reference/copy-files-v2) and [Publish build artifacts](/azure/devops/pipelines/tasks/reference/publish-build-artifacts-v1) tasks.<br><br>Note: Build.ArtifactStagingDirectory and Build.StagingDirectory are interchangeable. This directory is purged before each new build, so you don't have to clean it up yourself.<br><br> See [Artifacts in Azure Pipelines](../../artifacts/artifacts-overview.md).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.TriggeredBy.BuildId

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the BuildID of the triggering build. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.<br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead. Example: `1764`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.TriggeredBy.BuildNumber

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the number of the triggering build. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.<br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead. Example: `20260511.1`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.TriggeredBy.DefinitionId

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the DefinitionID of the triggering build. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. <br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead. Example: `42`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.TriggeredBy.DefinitionName

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to the name of the triggering build pipeline. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. <br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead. Example: `MyApp-CI`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Build.TriggeredBy.ProjectID

If [another build triggers](../../process/pipeline-triggers.md) the build, then this variable is set to ID of the project that contains the triggering build. In Classic pipelines, a build completion trigger triggers this variable.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. <br><br>If you're triggering a YAML pipeline using `resources`, you should use the [resources variables](/azure/devops/pipelines/yaml-schema/resources-pipelines-pipeline#the-pipeline-resource-metadata-as-predefined-variables) instead. Example: `b3e7e7c4-0000-0000-0000-000000000000`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Checks.StageAttempt

Set to 1 the first time this stage is attempted, and increments every time the stage is retried.<br><br>This variable can only be used within an [approval or check](../../process/approvals.md) for an environment. For example, you could use `$(Checks.StageAttempt)` within an [Invoke REST API check](../../process/approvals.md#invoke-rest-api).<br><br>:::image type="content" source="../media/checks-stageattempt-var.png" alt-text="Add the stage attempt as a parameter.":::

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Common.TestResultsDirectory

The local path on the agent where the test results are created. For example: `c:\agent_work\1\TestResults`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Environment.Id

ID of the environment targeted in the deployment job. For example, `10`.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Environment.Name

Name of the environment targeted in the deployment job to run the deployment steps and record the deployment history. For example, `smarthotel-dev`.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Environment.ResourceId

ID of the specific resource within the environment targeted in the deployment job to run the deployment steps. For example, `4`.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Environment.ResourceName

Name of the specific resource within the environment targeted in the deployment job to run the deployment steps and record the deployment history. For example, `bookings` which is a Kubernetes namespace that is added as a resource to the environment `smarthotel-dev`.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Pipeline.Workspace

Workspace directory for a particular pipeline. This variable has the same value as `Agent.BuildDirectory`. For example, `/home/vsts/work/1`. For more information about the agent directory structure, see [Agent directory structure](../../agents/agents.md#agent-directory-structure).

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Strategy.CycleName

The current cycle name in a deployment. Options are `PreIteration`, `Iteration`, or `PostIteration`.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### Strategy.Name

The name of the deployment strategy: `canary`, `runOnce`, or `rolling`.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.AccessToken

[Use the OAuth token to access the REST API](../../scripts/powershell.md#example-powershell-script-access-rest-api).<br><br>[Use System.AccessToken from YAML scripts](../variables.md#systemaccesstoken).<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag. Example: `(opaque OAuth bearer token)`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✗

### System.AccessTokenRequestUri

The URI used to request a federated access token when calling Microsoft Entra ID. Companion to `System.OidcRequestUri` for workload identity federation. [Learn more](/azure/devops/release-notes/2024/sprint-240-update#pipelines-and-tasks-populate-variables-to-customize-workload-identity-federation-authentication). Example: `https://vstoken.dev.azure.com/...`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.CollectionId

The GUID of the Azure DevOps organization or collection. Example: `6c6f3423-0000-0000-0000-000000000000`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.CollectionUri

The URI of the Azure DevOps organization or collection. For example: `https://dev.azure.com/fabrikamfiber/`.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.DefaultWorkingDirectory

[!INCLUDE [include](../includes/variables-build-sources-directory.md)]

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.DefinitionId

The ID of the build pipeline. Example: `42`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.HostType

Set to `build` if the pipeline is a build. For a release, the values are `deployment` for a Deployment group job, `gates` during evaluation of gates, and `release` for other (Agent and Agentless) jobs.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.IsTriggeringRepository

Set to `True` for the repository whose change triggered the run. Useful in multi-repository checkouts to detect which repository caused the run.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.JobAttempt

Set to 1 the first time this job is attempted, and increments every time the job is retried.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.JobDisplayName

The human-readable name given to a job. Example: `Build`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.JobId

A unique identifier for a single attempt of a single job. The value is unique to the current pipeline. Example: `12f1170f-0000-0000-0000-000000000000`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.JobIdentifier

A composite identifier for a job, including matrix and multi-config slice information. Use `System.JobName` for the human-readable job name. Example: `Build.Build.__default`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.JobName

The name of the job, typically used for expressing dependencies and accessing output variables. Example: `Build`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.OidcRequestUri

Generate an `idToken` for authentication with Entra ID using OpenID Connect (OIDC). [Learn more](/azure/devops/release-notes/2024/sprint-240-update#pipelines-and-tasks-populate-variables-to-customize-workload-identity-federation-authentication). Example: `https://vstoken.dev.azure.com/...`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PhaseAttempt

Set to 1 the first time this phase is attempted, and increments every time the job is retried.<br><br>Note: "Phase" is a mostly redundant concept, which represents the design-time for a job (whereas job was the runtime version of a phase). The concept of *phase* is mostly removed from Azure Pipelines. Matrix and multi-config jobs are the only place where a phase is still distinct from a job. One phase can instantiate multiple jobs, which differ only in their inputs.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PhaseDisplayName

The human-readable name given to a phase. Example: `Build`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PhaseName

A string-based identifier for a job, typically used for expressing dependencies and accessing output variables. Example: `Phase_1`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PlanId

A string-based identifier for a single pipeline run. Example: `9e4ec8c3-0000-0000-0000-000000000000`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.ForkSecretsRemoved

Set to `True` when secret variables have been stripped from a pull request build because the PR comes from a fork. Otherwise unset or `False`. Use this to detect when secret-dependent steps should be skipped.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.IsFork

If the pull request is from a fork of the repository, this variable is set to `True`.<br><br>Otherwise, it's set to `False`.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.MergedAt

The ISO 8601 timestamp when the pull request was merged. Only set after the PR has been completed. Example: `2026-05-11T18:30:00Z`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.PullRequestId

The ID of the pull request that caused this build. For example: `17`. (This variable is initialized only if the build ran because of a [Git PR affected by a branch policy](../../../repos/git/branch-policies.md#build-validation)).

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.PullRequestIteration

The PR iteration that caused the build. Each new push to a PR that re-runs validation increments this value (1, 2, 3, ...). Useful for differentiating between PR builds for the same `System.PullRequest.PullRequestId`.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.PullRequestNumber

The number of the pull request that caused this build. This variable is populated for pull requests from GitHub that have a different pull request ID and pull request number. This variable is only available in a YAML pipeline if a branch policy affects the PR. Example: `42`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.SourceBranch

The branch that is being reviewed in a pull request. For example: `refs/heads/users/raisa/new-feature` for Azure Repos. (This variable is initialized only if the build ran because of a [Git PR affected by a branch policy](../../../repos/git/branch-policies.md#build-validation)). This variable is only available in a YAML pipeline if a branch policy affects the PR.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.SourceCommitId

The commit that is being reviewed in a pull request. (This variable is initialized only if the build ran because of a [Git PR affected by a branch policy](../../../repos/git/branch-policies.md#build-validation)). This variable is only available in a YAML pipeline if a branch policy affects the PR. Example: `a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.SourceRepositoryUri

The URL to the repo that contains the pull request. For example: `https://dev.azure.com/ouraccount/_git/OurProject`.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.TargetBranch

The branch that is the target of a pull request. For example: `refs/heads/main` when your repository is in Azure Repos and `main` when your repository is in GitHub. This variable is initialized only if the build ran because of a [Git PR affected by a branch policy](../../../repos/git/branch-policies.md#build-validation). This variable is only available in a YAML pipeline if a branch policy affects the PR.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.PullRequest.targetBranchName

The name of the target branch for a pull request. This variable can be used in a pipeline to conditionally execute tasks or steps based on the target branch of the pull request. For example, you might want to trigger a different set of tests or code analysis tools depending on the branch that the changes are being merged into. Example: `main`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.StageAttempt

Set to 1 the first time this stage is attempted, and increments every time the stage is retried.

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.StageDisplayName

The human-readable name given to a stage. Example: `Build`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.StageName

A string-based identifier for a stage, typically used for expressing dependencies and accessing output variables. Example: `Stage_1`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.TeamFoundationCollectionUri

The URI of the Azure DevOps organization or collection. For example: `https://dev.azure.com/fabrikamfiber/`.<br><br>This variable is agent-scoped, and can be used as an environment variable in a script and as a parameter in a build task. It can't be used as part of the build number or as a version control tag.

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.TeamProject

The name of the project that contains this build. Example: `Fabrikam`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.TeamProjectId

The ID of the project that this build belongs to. Example: `b3e7e7c4-0000-0000-0000-000000000000`

**Available in**: Template `${{ }}` ✓ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

### System.TimelineId

A string-based identifier for the execution details and logs of a single pipeline run. Example: `33b55a2d-0000-0000-0000-000000000000`

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓

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

**Available in**: Template `${{ }}` ✗ &nbsp;·&nbsp; Macro `$(var)` ✓ &nbsp;·&nbsp; Runtime `$[ ]` ✓


> [!TIP]
> If you're using classic release pipelines, you can use [classic releases and artifacts variables](../../release/variables.md) to store and access data throughout your pipeline.
