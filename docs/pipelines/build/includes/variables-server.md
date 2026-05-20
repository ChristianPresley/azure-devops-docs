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

## Predefined variables (Azure DevOps Server)

Predefined variables are available as environment variables in scripts and as parameters in build tasks. When a variable isn't marked as available in templates, it doesn't render in [templates](../../process/templates.md) because the value isn't available in template scope.

The following sections group predefined variables by scenario. Each table includes an example value so you can quickly identify the variable you need.

## Agent and workspace

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | Agent.BuildDirectory | `/home/vsts/work/1` | Root working directory for the pipeline run on the agent. Same value as `Pipeline.Workspace`. | No |
> | Agent.ContainerMapping | `{"one_container":{"id":"bdbb357d73a0..."}}` | Maps YAML container resource names to Docker container IDs at runtime. | No |
> | Agent.HomeDirectory | `c:\agent` | Folder where the agent software is installed. | No |
> | Agent.Id | `2` | Numeric identifier of the agent. | No |
> | Agent.JobName | `Job` | Name of the running job, or the current matrix slice in multi-config runs. | No |
> | Agent.JobStatus | `Succeeded` | Status of the job. Possible values: `Succeeded`, `SucceededWithIssues`, `Failed`, `Canceled`, `Skipped`, `Abandoned`. | No |
> | Agent.MachineName | `fv-az200-123` | Machine name where the agent is installed. | No |
> | Agent.Name | `Hosted Agent` | Agent name registered in the pool. | No |
> | Agent.OS | `Linux` | Operating system of the agent host. Valid values: `Windows_NT`, `Darwin`, `Linux`. If you run the agent in a container, this reports the container OS rather than the host OS. | No |
> | Agent.OSArchitecture | `X64` | Processor architecture of the agent host. Valid values: `X86`, `X64`, `ARM`, `ARM64`. | No |
> | Agent.TempDirectory | `/home/vsts/work/_temp` | Temporary folder cleaned after each job. | No |
> | Agent.ToolsDirectory | `/opt/hostedtoolcache` | Shared tool cache used by installer tasks such as Node and Python. | No |
> | Agent.WorkFolder | `c:\agent_work` | Base working folder for the agent. Not guaranteed to be writable by every pipeline task (for example, in container scenarios). | No |
> | Common.TestResultsDirectory | `c:\agent_work\1\TestResults` | Default folder for test result files. This directory is purged before each new build. | No |
> | Pipeline.Workspace | `/home/vsts/work/1` | Workspace directory for a specific pipeline run. | No |
> | TF_BUILD | `True` | Sentinel variable set by the agent to `True` for every task. Scripts use it to detect that they're running inside Azure Pipelines (versus a local build or other CI system) so they can suppress interactive prompts, disable progress spinners, or change output formatting. Only available during job execution; not available at template-expression time. | No |

## Pipeline, job, and stage execution context

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | Checks.StageAttempt | `1` | Set to `1` the first time this stage is attempted, and increments every time the stage is retried. This variable can only be used within an [approval or check](../../process/approvals.md) for an environment. For example, you can use `$(Checks.StageAttempt)` within an [Invoke REST API check](../../process/approvals.md#invoke-rest-api). | No |
> | Build.BuildId | `1764` | Record ID of the completed build. | No |
> | Build.BuildNumber | `20260511.1` | Run number of the completed build. This value can contain whitespace or other invalid label characters, which can cause label format failures. It can't be used as part of the build number or as a version control tag. | No |
> | Build.BuildUri | `vstfs:///Build/Build/1430` | Build URI. | No |
> | Build.ContainerId | `2713905` | Artifact container ID for the run. | No |
> | Build.DefinitionFolderPath | `\Infrastructure\Deploy` | Folder path of the pipeline definition in the **Pipelines** list. | Yes |
> | Build.DefinitionName | `MyApp-CI` | Name of the build pipeline. This value can contain whitespace or other invalid label characters, which can cause label format failures. | Yes |
> | Build.DefinitionVersion | `1` | Version of the build pipeline definition. | Yes |
> | System.DefinitionId | `42` | Build pipeline definition ID. | Yes |
> | System.JobAttempt | `1` | Set to `1` the first time this job is attempted, and increments every time the job is retried. | No |
> | System.JobDisplayName | `Build` | Human-readable name of the current job. | No |
> | System.JobId | `12f1170f-0000-0000-0000-000000000000` | Unique identifier for the current job attempt. | No |
> | System.JobIdentifier | `Build.Build.__default` | Composite identifier for the job, including matrix slice details. | No |
> | System.JobName | `Build` | Identifier used for dependencies and output variables. | No |
> | System.PhaseAttempt | `1` | Set to `1` the first time this phase is attempted, and increments every time the phase is retried. Note: *Phase* is a mostly redundant concept that represents the design-time form of a job (a job is the runtime version of a phase). Matrix and multi-configuration jobs are the only places where a phase is still distinct from a job. One phase can instantiate multiple jobs that differ only in their inputs. | No |
> | System.PhaseDisplayName | `Build` | Human-readable name of the current phase. | No |
> | System.PhaseName | `Phase_1` | Identifier for the current phase. | No |
> | System.PlanId | `9e4ec8c3-0000-0000-0000-000000000000` | Identifier for the current pipeline run. | No |
> | System.StageAttempt | `1` | Set to `1` the first time this stage is attempted, and increments every time the stage is retried. | No |
> | System.StageDisplayName | `Build` | Human-readable name of the current stage. | No |
> | System.StageName | `Stage_1` | Identifier for the current stage. | No |
> | System.TimelineId | `33b55a2d-0000-0000-0000-000000000000` | Identifier for the execution timeline and logs. | No |

## Source control

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | Build.Repository.Clean | `true` | Value selected for **Clean** in repository settings. | No |
> | Build.Repository.Git.SubmoduleCheckout | `true` | Whether submodules are checked out for the self or primary repository. | No |
> | Build.Repository.ID | `b3e7e7c4-0000-0000-0000-000000000000` | Unique repository ID. | Yes |
> | Build.Repository.LocalPath | `c:\agent_work\1\s` | Agent path for the self or primary repository checkout. In multi-checkout, it can differ from `Build.SourcesDirectory` when the self repository uses a custom checkout path. | No |
> | Build.Repository.Name | `Fabrikam-Scripts` | Name of the triggering repository. | Yes |
> | Build.Repository.Provider | `GitHub` | Repository type. Possible values: `TfsGit`, `TfsVersionControl`, `Git` (external Git server), `GitHub`, `GitHubEnterprise`, `Bitbucket`, or `Svn`. | No |
> | Build.Repository.Tfvc.Workspace | `ws_12_8` | TFVC workspace name used by the build agent. | No |
> | Build.Repository.Uri | `https://dev.azure.com/fabrikamfiber/_git/Scripts` | URL of the triggering repository. | Yes |
> | Build.SourceBranch | `refs/heads/main` | Ref or branch that queued the build. Examples: `refs/heads/main` (Git branch), `refs/pull/1/merge` (Git pull request), `refs/tags/your-tag-name` (Git tag), or `$/teamproject/main` (TFVC branch). Forward slashes are replaced with underscores when used in the build number. In TFVC gated check-in or shelveset builds, you can't use this variable in the build number format. | Yes |
> | Build.SourceBranchName | `main` | Last path segment of the triggering branch or tag. For example, `refs/heads/feature/tools` yields `tools`, and `refs/tags/your-tag-name` yields `your-tag-name`. For TFVC gated check-ins or shelveset builds, the full shelveset identifier is returned and can't be used in the build number format. | Yes |
> | Build.SourcesDirectory | `c:\agent_work\1\s` | Default sources folder on the agent. With multiple checked-out repositories, this reverts to `$(Pipeline.Workspace)/s` even if the primary repository uses a custom checkout path (in this respect, this variable differs from `Build.Repository.LocalPath`). | No |
> | Build.SourceTfvcShelveset | `myshelveset;user@example.com` | TFVC shelveset name for gated or shelveset builds. | No |
> | Build.SourceVersion | `a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0` | Commit ID or TFVC changeset included in the build. | Yes |
> | Build.SourceVersionAuthor | `Jamal Hartnett` | Author of the triggering commit or changeset. | No |
> | Build.SourceVersionMessage | `Fix login bug` | Comment of the triggering commit or changeset, truncated to the first line or 200 characters, whichever is shorter. Available only at the step level (not at the job or stage level). For pull request builds, this message corresponds to the merge commit; Bitbucket pull requests are an exception because Bitbucket doesn't expose the merge commit. This variable doesn't work with classic build pipelines in Bitbucket repositories when **Batch changes while a build is in progress** is enabled. | No |
> | System.DefaultWorkingDirectory | `c:\agent_work\1\s` | Default working directory for the checked-out sources. | Yes |
> | System.IsTriggeringRepository | `True` | Indicates which repository change triggered the run in a multi-repo checkout. | Yes |

## Triggers and upstream builds

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | Build.CronSchedule.DisplayName | `Nightly build` | `displayName` of the cron schedule that triggered the run. Available in Azure DevOps Server 2022.1 and later. | Yes |
> | Build.Reason | `Manual` | Event that caused the pipeline to run. | Yes |
> | Build.TriggeredBy.BuildId | `1764` | Build ID of the upstream triggering build. Set by Classic build completion triggers. For YAML pipeline resource triggers, use `resources` variables instead. | No |
> | Build.TriggeredBy.BuildNumber | `20260511.1` | Build number of the upstream triggering build. Set by Classic build completion triggers. For YAML pipeline resource triggers, use `resources` variables instead. | No |
> | Build.TriggeredBy.DefinitionId | `42` | Pipeline definition ID of the upstream triggering build. Set by Classic build completion triggers. For YAML pipeline resource triggers, use `resources` variables instead. | No |
> | Build.TriggeredBy.DefinitionName | `MyApp-CI` | Pipeline name of the upstream triggering build. Set by Classic build completion triggers. For YAML pipeline resource triggers, use `resources` variables instead. | No |
> | Build.TriggeredBy.ProjectID | `b3e7e7c4-0000-0000-0000-000000000000` | Project ID that contains the upstream triggering build. Set by Classic build completion triggers. For YAML pipeline resource triggers, use `resources` variables instead. | No |

### Build.Reason values

- `Manual`: A user manually queued the build from the Azure DevOps portal.
- `IndividualCI`: **Continuous integration (CI)** triggered by a Git push or a Team Foundation Version Control (TFVC) check-in.
- `BatchedCI`: **Continuous integration (CI)** triggered by a Git push or a TFVC check-in with **Batch changes** enabled.
- `Schedule`: **Scheduled** trigger.
- `ScheduleForced`: A user manually ran a scheduled trigger, bypassing the **Always run** evaluation.
- `UserCreated`: The build was created through the REST API or `az pipelines run`.
- `ValidateShelveset`: A user manually queued the build of a TFVC shelveset.
- `CheckInShelveset`: **Gated check-in** trigger.
- `PullRequest`: A pull request triggered the build. Azure Repos branch-policy validation builds are one example.
- `BuildCompletion`: Another build triggered the run.
- `ResourceTrigger`: A resource or pipeline trigger started the run.

## Pull requests

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | System.PullRequest.ForkSecretsRemoved | `True` | Indicates secret variables were stripped because the PR came from a fork. | No |
> | System.PullRequest.IsFork | `True` | Indicates whether the pull request comes from a fork. | Yes |
> | System.PullRequest.PullRequestId | `17` | Pull request ID that caused the build. Set only when a Git PR triggered by a branch policy ran the build. | No |
> | System.PullRequest.PullRequestIteration | `3` | PR iteration that triggered the current validation run. | No |
> | System.PullRequest.PullRequestNumber | `42` | Pull request number from GitHub (when it differs from the ID). Set only when a branch policy triggers the build. | No |
> | System.PullRequest.SourceBranch | `refs/heads/users/raisa/new-feature` | Source branch under review. Set only when a Git PR triggered by a branch policy ran the build. | No |
> | System.PullRequest.SourceCommitId | `a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0` | Commit currently under review in the pull request. Set only when a Git PR triggered by a branch policy ran the build. | No |
> | System.PullRequest.SourceRepositoryUri | `https://dev.azure.com/ouraccount/_git/OurProject` | Repository URL that contains the pull request. Set only when a Git PR triggered by a branch policy ran the build. | No |
> | System.PullRequest.TargetBranch | `refs/heads/main` | Target branch for the pull request (`refs/heads/main` for Azure Repos, `main` for GitHub). Set only when a Git PR triggered by a branch policy ran the build. | No |
> | System.PullRequest.targetBranchName | `main` | Name of the target branch without the full git reference, for example `main` instead of `refs/heads/main`. Set only when a Git PR triggered by a branch policy ran the build. | No |

## Identity and auditing

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | Build.QueuedBy | `Jamal Hartnett` | Identity that queued the build. This value can contain whitespace or other invalid label characters, which can cause label format failures. | Yes |
> | Build.QueuedById | `a1b2c3d4-0000-0000-0000-000000000000` | ID of the identity that queued the build. | Yes |
> | Build.RequestedFor | `Jamal Hartnett` | Identity the build is requested for. This value can contain whitespace or other invalid label characters, which can cause label format failures. | Yes |
> | Build.RequestedForEmail | `fabrikamfiber4@example.com` | Email address for `Build.RequestedFor`. | Yes |
> | Build.RequestedForId | `00000002-0000-8888-8000-000000000000` | ID for `Build.RequestedFor`. | Yes |
> | Build.StageRequestedBy | `Jamal Hartnett` | Identity that requested a manually triggered stage. | No |
> | Build.StageRequestedForId | `00000002-0000-8888-8000-000000000000` | ID of the user that requested the manually triggered stage, or `00000002-0000-8888-8000-000000000000` when there was no manual intervention. | No |

## Artifacts and output directories

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | Build.ArtifactStagingDirectory | `c:\agent_work\1\a` | Folder used to stage artifacts before publishing. This directory is purged before each new build. | No |
> | Build.BinariesDirectory | `c:\agent_work\1\b` | Output folder for compiled binaries. This directory isn't cleaned by default on self-hosted agents. | No |
> | Build.StagingDirectory | `c:\agent_work\1\a` | Alias of `Build.ArtifactStagingDirectory`. This directory is purged before each new build. | No |
> | System.ArtifactsDirectory | `c:\agent_work\1\a` | Alias of `Build.ArtifactStagingDirectory` and `Build.StagingDirectory`. This directory is purged before each new build. | No |

## Organization, project, and security

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | System.AccessToken | `(opaque OAuth bearer token)` | OAuth token for scripts and tasks that call Azure DevOps APIs. It resolves at job execution time and isn't available in template expressions. | No |
> | System.CollectionId | `6c6f3423-0000-0000-0000-000000000000` | GUID of the Azure DevOps organization or collection. | Yes |
> | System.CollectionUri | `https://tfs.contoso.com/DefaultCollection/` | URI of the Azure DevOps organization or collection. | Yes |
> | System.HostType | `build` | Host type for the current job, such as `build`, `deployment`, `gates`, or `release`. | Yes |
> | System.TeamFoundationCollectionUri | `https://tfs.contoso.com/DefaultCollection/` | Legacy name for the collection URI variable. | Yes |
> | System.TeamProject | `Fabrikam` | Name of the project that contains the build. | Yes |
> | System.TeamProjectId | `b3e7e7c4-0000-0000-0000-000000000000` | Project ID for the build. | Yes |

## Deployment jobs (CD)

These variables are available only inside a [deployment job](../../process/deployment-jobs.md) and resolve at job execution time.

> [!div class="mx-tdBreakAll"]
> | Variable | Example value | Description | Available in templates? |
> | --- | --- | --- | --- |
> | Environment.Id | `10` | ID of the targeted environment. | No |
> | Environment.Name | `smarthotel-dev` | Name of the targeted environment. | No |
> | Environment.ResourceId | `4` | ID of the targeted resource inside the environment. | No |
> | Environment.ResourceName | `bookings` | Name of the targeted resource inside the environment. | No |
> | Strategy.CycleName | `Iteration` | Current cycle in the deployment strategy. | No |
> | Strategy.Name | `canary` | Deployment strategy name, such as `canary`, `runOnce`, or `rolling`. | No |

> [!TIP]
> If you're using classic release pipelines, you can use [classic releases and artifacts variables](../../release/variables.md) to store and access data throughout your pipeline.
