---
title: Connect to an Azure Artifacts feed
description: Connect to an Azure Artifacts feed from your package manager — NuGet, npm, Maven, Python, Cargo, or Universal Packages.
ms.service: azure-devops-artifacts
ms.topic: how-to
ms.author: rabououn
author: ramiMSFT
ms.date: 05/01/2026
monikerRange: "<=azure-devops"
"recommendations": "true"
---

# Connect to an Azure Artifacts feed

[!INCLUDE [version-lt-eq-azure-devops](../../includes/version-lt-eq-azure-devops.md)]

Azure Artifacts feeds work with NuGet, npm, Maven, Python, Cargo, and Universal Packages. The general flow is the same for every package type:

1. Create a feed (or pick an existing one).
1. Open the **Connect to Feed** dialog and pick your package manager.
1. Apply the generated configuration to your local tooling and authenticate.

This article walks you through the shared steps and points you to protocol-specific guidance for the package manager you use.

## Prerequisites

| **Product**        | **Requirements**                                                                                                                                                                                                                                                                                              |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Azure DevOps**   | - An Azure DevOps [organization](../../organizations/accounts/create-organization.md) and [project](../../organizations/projects/create-project.md).<br>- At least the **Feed Reader** role on the target feed. See [Manage permissions](../feeds/feed-permissions.md).<br>- The package manager CLI for your package type installed locally. |

## Create a feed

If you don't have a feed yet, create one. If you already have a feed, skip ahead to [Connect to your feed](#connect-to-your-feed).

[!INCLUDE [](../includes/create-feed.md)]

## Connect to your feed

The **Connect to Feed** dialog is the single starting point for every package manager. It generates the configuration snippets and endpoint URLs you need.

::: moniker range="azure-devops"

1. Sign in to your Azure DevOps organization, and then go to your project.

1. Select **Artifacts**, and then select your feed from the dropdown menu.

1. Select **Connect to Feed**.

1. In the left navigation pane, select your package manager (for example, **NuGet.exe**, **npm**, **Maven**, **pip**, **twine**, **Cargo**, or **Universal Packages**).

1. Follow the instructions under **Project setup** to add the feed as a package source in your local configuration file (for example, *nuget.config*, *.npmrc*, *pom.xml*, *pip.conf*, or *config.toml*).

::: moniker-end

::: moniker range="=azure-devops-2022"

1. Sign in to your Azure DevOps server, and then go to your project.

1. Select **Artifacts**, and then select your feed from the dropdown menu.

1. Select **Connect to Feed**.

1. In the left navigation pane, select your package manager.

1. Follow the instructions under **Project setup** to add the feed as a package source in your local configuration file.

::: moniker-end

## Authenticate to your feed

Azure Artifacts authenticates against your Azure DevOps identity. The recommended authentication method depends on your package manager:

| Package type            | Recommended authentication                                                                          |
|-------------------------|------------------------------------------------------------------------------------------------------|
| **NuGet** / **dotnet**  | [Azure Artifacts Credential Provider](https://github.com/microsoft/artifacts-credprovider)           |
| **npm**                 | [vsts-npm-auth](../npm/npmrc.md) (Windows) or a personal access token (PAT) in *.npmrc* (Linux/macOS) |
| **Maven** / **Gradle**  | Personal access token in *settings.xml* or *build.gradle*                                            |
| **Python**              | [artifacts-keyring](../quickstarts/python-cli.md) or a personal access token                         |
| **Cargo**               | Personal access token via `cargo login`                                                              |
| **Universal Packages**  | Azure CLI sign-in (`az login`) with the [Azure DevOps extension](../../cli/index.md)                 |

For details on creating personal access tokens, see [Use personal access tokens](../../organizations/accounts/use-personal-access-tokens-to-authenticate.md).

## Next steps by package type

After you've connected, follow the package-specific quickstart for publishing and consuming packages:

- [Get started with NuGet packages](../get-started-nuget.md)
- [Get started with npm packages](../get-started-npm.md)
- [Get started with Maven packages](../get-started-maven.md)
- [Get started with Python packages](../quickstarts/python-cli.md)
- [Get started with Cargo packages](../get-started-cargo.md)
- [Get started with Universal Packages](../quickstarts/universal-packages.md)

## Related articles

- [What is Azure Artifacts?](../start-using-azure-artifacts.md)
- [What are feeds?](../concepts/feeds.md)
- [Manage feed permissions](../feeds/feed-permissions.md)
- [Set up upstream sources](set-up-upstream-sources.md)
