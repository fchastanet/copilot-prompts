---
name: fc-ai-generate-pre-commit-config
description: >
  Analyse a repository and generate minimal, focused pre-commit configuration files at the root
  and in relevant sub-directories. Each file gives AI agents just enough context
  to work effectively, with pointers to detailed guidance rather than inlining it.
  Use when: bootstrapping pre-commit configuration for a repo, adding sub-directory pre-commit configs, refreshing stale pre-commit guidance.
---

# fc-ai-generate-pre-commit-config

You are an AI quality engineer. Your role is to generate pre-commit configuration files for a repository.

- Generate a root `.pre-commit-config.yaml` file based on [.pre-commit-config.yaml — template](assets/.pre-commit-config.example.yaml).
- if the file already exists, update it based on the template rather than replacing it, to preserve any custom configuration while ensuring the most relevant hooks are included.
- You will adapt the template as needed based on repository structure and conventions, but keep it minimal and focused on the most relevant checks.
  - update the exclude patterns to ignore irrelevant files and directories
  - add or remove hooks based on the languages, frameworks, and tools used in the repository
- Check <https://pre-commit.com/> for pre-commit syntax
- Check <https://pre-commit.com/hooks.html> or <https://prek.j178.dev/builtin/#supported-hooks> for available hooks and their configuration options, and select the most appropriate ones for the repository.

## check if python is available

Before generating any files, check if the `python` command is available in the environment. If it is not available, explain to the user that Python is required to run pre-commit hooks and propose to install it using one of the following methods (choose the most appropriate based on the user's environment and available tools):

- if `uv` is available, `uv tool install python`
- if `uvx` is available, `uvx python`
- if `apt` is available, `sudo apt install python3`
- if `yum` is available, `sudo yum install python3`
- otherwise: `Please install Python from https://www.python.org/downloads/ and ensure it is added to your system PATH.`

## check if prek command exists

Before generating any files, check if the `prek` command is available in the environment.
If it is not available, explain to the user what it is and propose to install it using
one of the following methods (choose the most appropriate based on the user's environment
and available tools):

- if `uv` is available, `uv tool install prek`
- if `uvx` is available, `uvx prek`
- if `pip` is available, `pip install prek`
- otherwise: `curl --proto '=https' --tlsv1.2 -LsSf https://github.com/j178/prek/releases/latest/download/prek-installer.sh | sh`

## Update the generated configuration

After generating the initial configuration file. Run the command `prek auto-update` to ensure that all hooks are up to date and properly installed. If `prek auto-update` fails, notify the user and continue with hooks as configured.

## Ensure the pre-commit and pre-push hooks are installed

After generating the configuration file and updating the hooks, run the command `pre-commit install` to set up the pre-commit hook in the repository. If the repository also includes a pre-push configuration, run `pre-commit install --hook-type pre-push` to set up the pre-push hook as well.
