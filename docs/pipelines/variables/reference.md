---
title: Variables reference
description: Reference predefined, system, agent, build, and Classic release variables in Azure Pipelines.
ms.topic: reference
ms.assetid: 3A1C529F-DF6B-470A-9047-2758644C3D95
ms.author: rabououn
author: ramiMSFT
ms.date: 02/13/2026
ms.custom:  copilot-scenario-highlight
monikerRange: '<= azure-devops'
---

# Variables reference

[!INCLUDE [version-lt-eq-azure-devops](../../includes/version-lt-eq-azure-devops.md)]

Variables give you a convenient way to get key bits of data into various parts of your pipeline. This reference lists common predefined variables for YAML, build, and Classic release pipelines. There might be a few other predefined variables, but they're mostly for internal use.

These variables are automatically set by the system and read-only. (The exceptions are Build.Clean and System.Debug.)

::: moniker range="<=azure-devops"

In YAML pipelines, you can reference predefined variables as environment variables. For example, the variable `Build.ArtifactStagingDirectory` becomes the variable `BUILD_ARTIFACTSTAGINGDIRECTORY`.

For Classic release pipelines, release-specific and artifact-specific variables are listed in [Classic release variables](#classic-release-variables).

::: moniker-end


To define your own variables and choose the right syntax, see [Define variables](index.md).

::: moniker range="azure-devops"

> [!TIP]
> You can ask [Copilot](/copilot/) for help with variables. To learn more, see [Ask Copilot to generate a stage with a condition based on variable values](#ask-copilot-to-generate-a-stage-with-a-condition-based-on-variable-values).

::: moniker-end

## Build.Clean

This is a deprecated variable that modifies how the build agent cleans up source.
To learn how to clean up source, see [Clean the local repo on the agent](../repos/pipeline-options-for-git.md#clean-the-local-repo-on-the-agent).

<h2 id="systemaccesstoken">System.AccessToken</h2>

`System.AccessToken` is a special variable that carries the security token used by the running build.

# [YAML](#tab/yaml)

In YAML, you must explicitly map `System.AccessToken` into the pipeline using a
variable. You can do this at the step or task level. For example, you can use `System.AccessToken` to authenticate with a container registry.

```yaml
steps:
- task: Docker@2
  inputs:
    command: login
    containerRegistry: '<docker connection>'
  env:
    SYSTEM_ACCESSTOKEN: $(System.AccessToken)
```

You can configure the default scope for `System.AccessToken` using [build job authorization scope](../process/access-tokens.md#job-authorization-scope).

# [Classic](#tab/classic)

You can allow scripts and tasks to access System.AccessToken at the job level.

1. Navigate to the job

1. Under **Additional options**, check the **Allow scripts to access the OAuth token** box.

Checking this box also leaves the credential set in Git so that you can run
pushes and pulls in your scripts.

---

## System.Debug

For more detailed logs to debug pipeline problems, define `System.Debug` and set it to `true`.

1. Edit your pipeline.
1. Select **Variables**.
1. Add a new variable with the name  `System.Debug` and value `true`.

    :::image type="content" source="../build/media/options/system-debug.png" alt-text="Set System Debug to true":::

1. Save the new variable.

Setting `System.Debug` to `true` configures verbose logs for all runs. You can also configure verbose logs for a single run with the **Enable system diagnostics** checkbox.

You can also set `System.Debug` to `true` as a variable in a pipeline or template.

```yaml
variables:
  system.debug: 'true'
```

::: moniker range=">azure-devops-2022"

When `System.Debug` is set to `true`, an extra variable named `Agent.Diagnostic` is set to `true`. When `Agent.Diagnostic` is `true`, the agent collects more logs that can be used for troubleshooting network issues for self-hosted agents. For more information, see [Network diagnostics for self-hosted agents](../troubleshooting/review-logs.md#network-diagnostics-for-self-hosted-agents).

> [!NOTE]
> The `Agent.Diagnostic` variable is available with [Agent v2.200.0](https://github.com/microsoft/azure-pipelines-agent/releases/tag/v2.200.0) and higher.

::: moniker-end

For more information, see [Review logs to diagnose pipeline issues](../troubleshooting/review-logs.md).

::: moniker range=">=azure-devops"

[!INCLUDE [include](../build/includes/variables-hosted.md)]

::: moniker-end

::: moniker range="= azure-devops-server"

[!INCLUDE [include](../build/includes/variables-server.md)]

::: moniker-end

::: moniker range="= azure-devops-2022"

[!INCLUDE [include](../build/includes/variables-server-2022.md)]

::: moniker-end

<a name="identity_values"></a>
### How are the identity variables set?

The value depends on what caused the build and are specific to Azure Repos repositories.

| If the build is triggered... | Then the Build.QueuedBy and Build.QueuedById values are based on... | Then the Build.RequestedFor and Build.RequestedForId values are based on... |
| --- | --- | --- |
| In Git or by the [Continuous integration (CI) triggers](../build/triggers.md) | The system identity, for example: `[DefaultCollection]\Project Collection Service Accounts` | The person who pushed or checked in the changes. |
| In Git or by a [branch policy build](../../repos/git/branch-policies.md#build-validation). | The system identity, for example: `[DefaultCollection]\Project Collection Service Accounts` | The person who checked in the changes. |
| In TFVC by a [gated check-in trigger](../build/triggers.md) | The person who checked in the changes. | The person who checked in the changes. |
| In Git or TFVC by the [Scheduled triggers](../build/triggers.md) | The system identity, for example: `[DefaultCollection]\Project Collection Service Accounts` | The system identity, for example: `[DefaultCollection]\Project Collection Service Accounts` |
| Because you clicked the **Queue build** button | You | You |

<a id="classic-release-variables"></a>
<a id="default-variables"></a>

## Classic release variables

Classic release pipelines use variables to exchange and transport data throughout a release. Each variable is stored as a string, and its value can change between pipeline runs.

::: moniker range="azure-devops"

Unlike [runtime parameters](../process/runtime-parameters.md), which are only available at template parsing time, variables in Classic release pipelines are accessible throughout the entire deployment process.

::: moniker-end

When you set up tasks to deploy your application in each stage of your Classic release pipeline, variables can help you:

- **Simplify customization**: Define a generic deployment pipeline once and easily adapt it for different stages. For instance, use a variable to represent a web deployment's connection string, adjusting its value as needed for each stage. These variables are known as *custom variables*.

- **Leverage contextual information**: Access details about the release context, such as a [stage](../process/stages.md), an [artifact](../release/artifacts.md), or the [agent](../agents/agents.md) running the deployment. For example, your scripts might require the build location for download, or the agent's working directory to create temporary files. These variables are referred to as *default variables*.

Default variables provide essential information about the execution context to your running tasks and scripts. These variables give you access to details about the *system*, *release*, *stage*, or *agent* in which they're running.

With the exception of *System.Debug*, default variables are read-only, and the system automatically sets their values.

### Classic release system variables

| Variable name | Description |
| --- | --- |
| **System.TeamFoundationServerUri** | The URL of the service connection in Azure Pipelines. Use this variable in your scripts or tasks to call Azure Pipelines REST APIs.<br/><br />Example: `https://fabrikam.vsrm.visualstudio.com/` |
| **System.TeamFoundationCollectionUri** | The URL of the Team Foundation collection or Azure Pipelines. Use this variable in your scripts or tasks to call REST APIs on other services such as Build and Version control.<br/><br />Example: `https://dev.azure.com/fabrikam/` |
| **System.CollectionId** | The ID of the collection to which this build or release belongs.<br/><br />Example: `6c6f3423-1c84-4625-995a-f7f143a1e43d` |
| **System.DefinitionId** | The ID of the release pipeline to which the current release belongs.<br/><br />Example: `1` |
| **System.TeamProject** | The name of the project to which this build or release belongs.<br/><br />Example: `Fabrikam` |
| **System.TeamProjectId** | The ID of the project to which this build or release belongs.<br/><br />Example: `79f5c12e-3337-4151-be41-a268d2c73344` |
| **System.ArtifactsDirectory** | The directory to which the pipeline downloads artifacts during deployment of a release. The pipeline clears the directory before every deployment if it requires artifacts to be downloaded to the agent. Same as `Agent.ReleaseDirectory` and `System.DefaultWorkingDirectory`.<br/><br />Example: `C:\agent\_work\r1\a` |
| **System.DefaultWorkingDirectory** | The directory to which the pipeline downloads artifacts during deployment of a release. The pipeline clears the directory before every deployment if it requires artifacts to be downloaded to the agent. Same as `Agent.ReleaseDirectory` and `System.ArtifactsDirectory`.<br/><br />Example: `C:\agent\_work\r1\a` |
| **System.WorkFolder** | The working directory for this agent, where the pipeline creates subfolders for every build or release. Same as `Agent.RootDirectory` and `Agent.WorkFolder`.<br/><br />Example: `C:\agent\_work` |
| **System.Debug** | This is the only system variable that users can *set*. Set this variable to `true` to [run the release in debug mode](#run-a-release-in-debug-mode) to assist in fault-finding.<br/><br />Example: `true` |

<a id="release-variables"></a>

### Release variables

| Variable name | Description |
| --- | --- |
| **Release.AttemptNumber** | The number of times this release is deployed in this stage.<br/><br />Example: `1` |
| **Release.DefinitionEnvironmentId** | The ID of the stage in the corresponding release pipeline.<br/><br />Example: `1` |
| **Release.DefinitionId** | The ID of the release pipeline to which the current release belongs.<br/><br />Example: `1` |
| **Release.DefinitionName** | The name of the release pipeline to which the current release belongs.<br/><br />Example: `fabrikam-cd` |
| **Release.Deployment.RequestedFor** | The display name of the identity that triggered (started) the deployment currently in progress.<br/><br />Example: `Mateo Escobedo` |
| **Release.Deployment.RequestedForEmail** | The email address of the identity that triggered (started) the deployment currently in progress.<br/><br />Example: `mateo@fabrikam.com` |
| **Release.Deployment.RequestedForId** | The ID of the identity that triggered (started) the deployment currently in progress.<br/><br />Example: `2f435d07-769f-4e46-849d-10d1ab9ba6ab` |
| **Release.DeploymentID** | The ID of the deployment. Unique per job.<br/><br />Example: `254` |
| **Release.DeployPhaseID** | The ID of the phase where deployment is running.<br/><br />Example: `127` |
| **Release.EnvironmentId** | The ID of the stage instance in a release to which the deployment is currently in progress.<br/><br />Example: `276` |
| **Release.EnvironmentName** | The name of stage to which deployment is currently in progress.<br/><br />Example: `Dev` |
| **Release.EnvironmentUri** | The URI of the stage instance in a release to which deployment is currently in progress.<br/><br />Example: `vstfs://ReleaseManagement/Environment/276` |
| **Release.Environments.{stage-name}.status** | The deployment status of the stage.<br/><br />Example: `InProgress` |
| **Release.PrimaryArtifactSourceAlias** | The alias of the primary artifact source.<br/><br />Example: `fabrikam\_web` |
| **Release.Reason** | The reason for the deployment. Supported values are:<br> `ContinuousIntegration` - the release started in Continuous Deployment after a build completed.<br> `Manual` - the release started manually.<br> `None` - the deployment reason isn't specified.<br> `Schedule` - the release started from a schedule. |
| **Release.ReleaseDescription** | The text description provided at the time of the release.<br/><br />Example: `Critical security patch` |
| **Release.ReleaseId** | The identifier of the current release record.<br/><br />Example: `118` |
| **Release.ReleaseName** | The name of the current release.<br/><br />Example: `Release-47` |
| **Release.ReleaseUri** | The URI of the current release.<br/><br />Example: `vstfs://ReleaseManagement/Release/118` |
| **Release.ReleaseWebURL** | The URL for this release.<br/><br />Example: `https://dev.azure.com/fabrikam/f3325c6c/_release?releaseId=392&_a=release-summary` |
| **Release.RequestedFor** | The display name of the identity that triggered the release.<br/><br />Example: `Mateo Escobedo` |
| **Release.RequestedForEmail** | The email address of the identity that triggered the release.<br/><br />Example: `mateo@fabrikam.com` |
| **Release.RequestedForId** | The ID of the identity that triggered the release.<br/><br />Example: `2f435d07-769f-4e46-849d-10d1ab9ba6ab` |
| **Release.SkipArtifactsDownload** | Boolean value that specifies whether to skip downloading of artifacts to the agent.<br/><br />Example: `FALSE` |
| **Release.TriggeringArtifact.Alias** | The alias of the artifact which triggered the release. This value is empty when the release is scheduled or triggered manually.<br/><br />Example: `fabrikam\_app` |

### Release-stage variables

| Variable name | Description |
| --- | --- |
| **Release.Environments.{stage name}.Status** | The status of deployment of this release within a specified stage.<br/><br />Example: `NotStarted` |

### Classic release agent variables

| Variable name | Description |
| --- | --- |
| **Agent.Name** | The name of the agent as registered with the [agent pool](../agents/pools-queues.md). This name is likely different from the computer name.<br/><br />Example: `fabrikam-agent` |
| **Agent.MachineName** | The name of the computer on which the agent is configured.<br/><br />Example: `fabrikam-agent` |
| **Agent.Version** | The version of the agent software.<br/><br />Example: `2.109.1` |
| **Agent.JobName** | The name of the job that runs, such as Release or Build.<br/><br />Example: `Release` |
| **Agent.HomeDirectory** | The folder where the agent is installed. This folder contains the code and resources for the agent.<br/><br />Example: `C:\agent` |
| **Agent.ReleaseDirectory** | The directory to which the deployment of a release downloads artifacts. The directory is cleared before every deployment if it requires artifacts to be downloaded to the agent. It's the same as `System.ArtifactsDirectory` and `System.DefaultWorkingDirectory`.<br/><br />Example: `C:\agent\_work\r1\a` |
| **Agent.RootDirectory** | The working directory for this agent, where subfolders are created for every build or release. It's the same as `Agent.WorkFolder` and `System.WorkFolder`.<br/><br />Example: `C:\agent\_work` |
| **Agent.WorkFolder** | The working directory for this agent, where subfolders are created for every build or release. It's the same as `Agent.RootDirectory` and `System.WorkFolder`.<br/><br />Example: `C:\agent\_work` |
| **Agent.DeploymentGroupId** | The ID of the deployment group the agent registers with. This ID is available only in deployment group jobs.<br/><br />Example: `1` |

<a id="release-artifacts-variables"></a>

## Classic release artifacts variables

For each artifact that you reference in a Classic release, use the following artifact variables. Not all variables apply to every artifact type. If an example is empty, it indicates that the variable isn't applicable for that artifact type.

Replace the `{alias}` placeholder with the value you specify for the [artifact source alias](../release/artifacts.md#artifact-source-alias) or with the default value generated for the release pipeline.

| Variable name | Description |
| --- | --- |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.DefinitionId | The identifier of the build pipeline or repository. Examples:<br /><br />Azure Pipelines: `1`<br />GitHub: `fabrikam/asp` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.DefinitionName | The name of the build pipeline or repository. Examples:<br /><br />Azure Pipelines: `fabrikam-ci`<br />TFVC: `$/fabrikam`<br />Git: `fabrikam`<br />GitHub: `fabrikam/asp (main)` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.BuildNumber | The build number or the commit identifier. Examples:<br /><br />Azure Pipelines: `20170112.1`<br />Jenkins: `20170112.1`<br />TFVC: `Changeset 3`<br />Git: `38629c964`<br />GitHub: `38629c964` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.BuildId | The build identifier. Examples:<br /><br />Azure Pipelines: `130`<br />Jenkins: `130`<br />GitHub: `38629c964d21fe405ef830b7d0220966b82c9e11` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.BuildURI | The URL for the build. Examples:<br /><br />Azure Pipelines: `vstfs://build-release/Build/130`<br />GitHub: `https://github.com/fabrikam/asp` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.SourceBranch | The full path and name of the branch from which the source was built. Examples:<br /><br />Azure Pipelines: `refs/heads/main` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.SourceBranchName | The name only of the branch from which the source was built. Examples:<br /><br />Azure Pipelines: `main` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.SourceVersion | The commit that was built. Examples:<br /><br />Azure Pipelines: `bc0044458ba1d9298cdc649cb5dcf013180706f7` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.Repository.Provider | The type of repository from which the source was built. Examples:<br /><br />Azure Pipelines: `Git` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.RequestedForID | The identifier of the account that triggered the build. Examples:<br /><br />Azure Pipelines: `2f435d07-769f-4e46-849d-10d1ab9ba6ab` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.RequestedFor | The name of the account that requested the build. Examples:<br /><br />Azure Pipelines: `Mateo Escobedo` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.Type | The type of artifact source, such as Build. Examples:<br /><br />Azure Pipelines: `Build`<br />Jenkins: `Jenkins`<br />Azure DevOps Services: `TFVC`<br />Git: `Git`<br />GitHub: `GitHub` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.PullRequest.TargetBranch | The full path and name of the branch that is the target of a pull request. This variable is initialized only if the release is triggered by a pull request flow. Examples:<br /><br />Azure Pipelines: `refs/heads/main` |
| Release.Artifacts.{[alias](../release/artifacts.md#artifact-source-alias)}.PullRequest.TargetBranchName | The name only of the branch that is the target of a pull request. This variable is initialized only if the release is triggered by a pull request flow. Examples:<br /><br />Azure Pipelines: `main` |

<a id="primary-artifact-variables"></a>

## Primary artifact variables

In Classic release pipelines, if you use multiple artifacts, you can designate one artifact as the primary artifact. Azure Pipelines then populates the following variables for the designated primary artifact.

| Variable name | Same as |
| --- | --- |
| **Build.DefinitionId** | Release.Artifacts.{Primary artifact alias}.DefinitionId |
| **Build.DefinitionName** | Release.Artifacts.{Primary artifact alias}.DefinitionName |
| **Build.BuildNumber** | Release.Artifacts.{Primary artifact alias}.BuildNumber |
| **Build.BuildId** | Release.Artifacts.{Primary artifact alias}.BuildId |
| **Build.BuildURI** | Release.Artifacts.{Primary artifact alias}.BuildURI |
| **Build.SourceBranch** | Release.Artifacts.{Primary artifact alias}.SourceBranch |
| **Build.SourceBranchName** | Release.Artifacts.{Primary artifact alias}.SourceBranchName |
| **Build.SourceVersion** | Release.Artifacts.{Primary artifact alias}.SourceVersion |
| **Build.Repository.Provider** | Release.Artifacts.{Primary artifact alias}.Repository.Provider |
| **Build.RequestedForID** | Release.Artifacts.{Primary artifact alias}.RequestedForID |
| **Build.RequestedFor** | Release.Artifacts.{Primary artifact alias}.RequestedFor |
| **Build.Type** | Release.Artifacts.{Primary artifact alias}.Type |
| **Build.PullRequest.TargetBranch** | Release.Artifacts.{Primary artifact alias}.PullRequest.TargetBranch |
| **Build.PullRequest.TargetBranchName** | Release.Artifacts.{Primary artifact alias}.PullRequest.TargetBranchName |

## Use Classic release default variables

You can use Classic release default variables in two ways: as parameters to tasks in a release pipeline or within your scripts.

Use a default variable directly as an input to a task. For example, to pass `Release.Artifacts.{Artifact alias}.DefinitionName` as an argument to a PowerShell task for an artifact with *ASPNET4.CI* as its alias, use `$(Release.Artifacts.ASPNET4.CI.DefinitionName)`.

:::image type="content" source="../release/media/variables-01.png" alt-text="A screenshot displaying how to use a default variable as an argument.":::

To use a default variable in your script, replace the `.` in the default variable names with `_`. For example, to print the value of `Release.Artifacts.{Artifact alias}.DefinitionName` for an artifact with *ASPNET4.CI* as its alias in a PowerShell script, use `$env:RELEASE_ARTIFACTS_ASPNET4_CI_DEFINITIONNAME`. The original alias, *ASPNET4.CI*, is replaced with *ASPNET4_CI*.

:::image type="content" source="../release/media/variables-02.png" alt-text="A screenshot displaying how to use a default variable in an inline PowerShell script.":::

<a id="custom-variables"></a>

## Classic release custom variables

You can define custom variables at different scopes.

- **Variable groups**: Use variable groups to share values across all definitions in a project. This approach is useful when you want to use the same values throughout definitions, stages, and tasks within a project, and manage them from a single location. Define and manage variable groups in **Pipelines** > **Library**.

- **Release pipeline variables**: Use release pipeline variables to share values across all stages within a release pipeline. This approach is ideal for scenarios where you need a consistent value across stages and tasks, with the ability to update it from a single location. Define and manage these variables in the **Variables** tab of the release pipeline. In the Pipeline Variables page, set the **Scope** drop-down list to *Release* when adding a variable.

- **Stage variables**: Use stage variables to share values within a specific stage of a release pipeline. This approach is useful for values that differ from stage to stage but are consistent across all tasks within a stage. Define and manage these variables in the **Variables** tab of the release pipeline. In the Pipeline Variables page, set the **Scope** drop-down list to the appropriate environment when adding a variable.

By using custom variables at the project, release pipeline, and stage levels, you can:

- Avoid duplicating values, making it easier to update all occurrences with a single change.

- Secure sensitive values by preventing them from being viewed or modified by users. To mark a variable as secure (secret), select the :::image type="icon" source="../release/media/padlock-icon.png" alt-text="padlock icon"::: icon next to the variable.

  > [!IMPORTANT]
  > The values of the hidden variables (secret) are securely stored on the server and users can't view them after they're saved. During deployment, Azure Pipelines decrypts these values when tasks reference them and passes them to the agent over a secure HTTPS channel.

> [!NOTE]
> Creating custom variables can overwrite standard variables. For example, if you define a custom **Path** variable on a Windows agent, it overwrites the *$env:Path* variable and might prevent PowerShell from running properly.

### Use Classic release custom variables

To use custom variables in your tasks, enclose the variable name in parentheses and precede it with a **$** character. For example, if you have a variable named *adminUserName*, insert its current value into a task as `$(adminUserName)`.

> [!NOTE]
> Variables from different groups linked to a pipeline at the same scope (for example, job or stage) can conflict and lead to unpredictable results. To avoid this problem, ensure that variables across all your variable groups have unique names.

[!INCLUDE [set-variables-in-scripts](../includes/set-variables-in-scripts.md)]

## View Classic release variable values

1. Select **Pipelines** > **Releases**, and then select your release pipeline.

1. Open the summary view for your release, and select the stage you're interested in. In the list of steps, choose **Initialize job**.

    :::image type="content" source="../release/media/view-variable-values-link.png" alt-text="A screenshot displaying the initialize job step.":::

1. This step opens the logs. Scroll down to see the values the agent uses for this job.

    :::image type="content" source="../release/media/view-variable-values.png" alt-text="A screenshot displaying the variables used by the agent.":::

<a id="run-a-release-in-debug-mode"></a>

## Run a Classic release in debug mode

Running a release in debug mode can help you diagnose and resolve problems by displaying extra information during the release execution. You can turn on debug mode for the whole release or just for the tasks in a specific release stage.

- To turn on debug mode for the whole release, add a variable named `System.Debug` with the value `true` to the **Variables** tab of the release pipeline.

- To turn on debug mode for a specific stage, open the **Configure stage** dialog from the shortcut menu of the stage, and add a variable named `System.Debug` with the value `true` to the **Variables** tab.

- Alternatively, create a [variable group](../library/variable-groups.md) containing a variable named `System.Debug` with the value `true`, and link this variable group to the release pipeline.

> [!TIP]
> If you encounter an error related to Azure Resource Manager service connections, see [How to: Troubleshoot Azure Resource Manager service connections](../release/azure-rm-endpoint.md) for more details.

::: moniker range="azure-devops"

## Ask Copilot to generate a stage with a condition based on variable values

Use [Copilot](/copilot/) to generate a stage with a condition determined by the value of a variable.

This example prompt defines a stage that runs when `Agent.JobStatus` indicates that the previous stage ran successfully:

> Create a new Azure DevOps stage that only runs when `Agent.JobStatus` is `Succeeded` or `SucceededWithIssues`.

You can customize the prompt to use values that meet your requirements. For example, you can ask for help creating a stage that only runs when a pipeline fails.

> [!NOTE]
> GitHub Copilot is powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions. For more information about the general use of GitHub Copilot, product impact, human oversight, and privacy, see [GitHub Copilot FAQs](https://github.com/features/copilot#faq).

::: moniker-end
