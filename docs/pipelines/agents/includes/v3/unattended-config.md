---
ms.topic: include
ms.service: azure-devops-pipelines
ms.manager: wiwagn
ms.author: sdanie
author: steved0x
ms.date: 04/17/2024
---

To configure an agent, it must know the URL to your organization or collection and credentials of someone authorized to set up agents.
All other responses are optional.
Any command-line parameter can be specified using an environment variable instead:
put its name in upper case and prepend `VSTS_AGENT_INPUT_`.
For example, `VSTS_AGENT_INPUT_PASSWORD` instead of specifying `--password`.

### Required options

- `--unattended` - agent setup will not prompt for information, and all settings must be provided on the command line
- `--url <url>` - URL of the server. For example: https://dev.azure.com/myorganization or http://my-azure-devops-server:8080/tfs
- `--auth <type>` - authentication type. Valid values are:
  - `pat` (Personal access token)
  - `SP` (Service Principal) (Requires [agent version 3.227.1](https://github.com/microsoft/azure-pipelines-agent/releases/tag/v3.227.1) or newer)
  - `negotiate` (Kerberos or NTLM)
  - `alt` (Basic authentication)
  - `integrated` (Windows default credentials)

### Authentication options

- If you chose `--auth pat`:
  - `--token <token>` - specifies your personal access token
  - You can also pass an OAuth 2.0 token as the `--token` parameter.
- If you chose `--auth negotiate` or `--auth alt`:
  - `--userName <userName>` - specifies a Windows username in the format `domain\userName` or `userName@domain.com`
  - `--password <password>` - specifies a password
- If you chose `--auth SP`:
  - `--clientID <clientID>` - specifies the Client ID of the Service Principal with access to register agents
  - `--tenantId <tenantID>` - specifies the Tenant ID which the Service Principal is registered in
  - `--clientSecret <clientSecret>` - specifies the Client Secret of the Service Principal
  - See [Register an agent using a service principal](../../service-principal-agent-registration.md) for more information


### Pool and agent names
- `--pool <pool>` - pool name for the agent to join
- `--agent <agent>` - agent name
- `--replace` - replace the agent in a pool. If another agent is listening by the same name, it will start failing with a conflict

### Agent setup
- `--work <workDirectory>` - work directory where job data is stored. Defaults to `_work` under the
root of the agent directory. The work directory is owned by a given
agent and should not be shared between multiple agents.
- `--acceptTeeEula` - accept the Team Explorer Everywhere End User License Agreement (macOS and Linux only)
- `--disableloguploads` - don't stream or send console log output to the server. Instead, you may retrieve them from the agent host's filesystem after the job completes.

### Windows-only startup
- `--runAsService` - configure the agent to run as a Windows service (requires administrator permission)
- `--runAsAutoLogon` - configure auto-logon and run the agent on startup (requires administrator permission)
- `--windowsLogonAccount <account>` - used with `--runAsService` or `--runAsAutoLogon` to specify the Windows user
name in the format `domain\userName` or `userName@domain.com`
- `--windowsLogonPassword <password>` - used with `--runAsService` or `--runAsAutoLogon` to specify Windows logon password (not required for [Group Managed Service Accounts](https://aka.ms/gmsa) and Windows built in accounts such as 'NT AUTHORITY\NETWORK SERVICE')
- `--enableservicesidtypeunrestricted` - used with `--runAsService` to configure the agent with service SID type as `SERVICE_SID_TYPE_UNRESTRICTED` (requires administrator permission)
- `--overwriteAutoLogon` - used with `--runAsAutoLogon` to overwrite the existing auto logon on the machine
- `--noRestart` - used with `--runAsAutoLogon` to stop the host from restarting after agent configuration completes

[!INCLUDE [troubleshooting-autologon](./troubleshooting-autologon.md)]

### Deployment group only
- `--deploymentGroup` - configure the agent as a deployment group agent
- `--deploymentGroupName <name>` - used with `--deploymentGroup` to specify the deployment group for the agent to join
- `--projectName <name>` - used with `--deploymentGroup` to set the project name
- `--addDeploymentGroupTags` - used with `--deploymentGroup` to indicate that deployment group tags should be added
- `--deploymentGroupTags <tags>` - used with `--addDeploymentGroupTags` to specify the comma separated list of tags for
the deployment group agent - for example "web, db"

### Environments only
- `--addvirtualmachineresourcetags` - used to indicate that environment resource tags should be added
- `--virtualmachineresourcetags  <tags>` - used with `--addvirtualmachineresourcetags` to specify the comma separated list of tags for
the environment resource agent - for example "web, db"

### Diagnostic and advanced flags

These flags are accepted by `config.cmd`/`config.sh` and `run.cmd`/`run.sh` to help with operator-side troubleshooting and advanced installs. They are defined in the agent source ([Constants.cs](https://github.com/microsoft/azure-pipelines-agent/blob/master/src/Microsoft.VisualStudio.Services.Agent/Constants.cs) under `Agent.CommandLine.Flags`).

- `--debug` - run the agent (or configuration) with verbose debug logging emitted to the console.
- `--diagnostics` - generate a diagnostic bundle in the agent's `_diag` folder. Pair with `--once` (`./run.sh --once --diagnostics`) to capture a single job's diagnostics for a support ticket.
- `--restreamlogstofiles` - in addition to the normal upload, write console log output to local files. Useful when you also pass `--disableloguploads` and need a local copy of every job's log.
- `--alwaysextracttask` - force the agent to extract every task package to disk on every job, even when the cached payload appears unchanged. Use this when troubleshooting "stale task" behavior on self-hosted agents.
- `--launchbrowser` - during interactive configuration, automatically open the device-code URL in the default browser instead of printing it for manual copy/paste. See [Configure agents using device code flow](../../device-code-flow-agent-registration.md).
- `--preventservicestart` - on Windows, used with `--runAsService` to install the agent service without starting it. Useful when the agent is configured by automation and the service should be started later by another tool.
- `--commit` - print the Git commit SHA the agent binaries were built from and exit. Use this to confirm the exact build a self-hosted host is running when investigating regressions.

### Re-authenticate an existing agent

To replace the credentials an already-configured agent uses without unconfiguring and reconfiguring, run the agent with the `reauth` verb:

```bash
./config.sh reauth --auth pat --token <new-pat>
```

```cmd
.\config.cmd reauth --auth pat --token <new-pat>
```

`reauth` accepts the same authentication flags as `configure` (`--auth`, `--token`, `--clientID`, `--clientSecret`, `--tenantId`, etc.). Use it when a personal access token expires or you migrate an agent from PAT to service principal authentication. The `reauth` verb is implemented in `azure-pipelines-agent/src/Agent.Listener/CommandLine/ReAuthAgent.cs`.
