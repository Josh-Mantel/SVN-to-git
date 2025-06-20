# Mercurial to Git Batch Converter

A simple yet powerful Bash script to batch convert multiple local Mercurial (`hg`) repositories into Git repositories. This script is ideal for migrating a collection of projects from Mercurial to Git while preserving the full commit history.

## Features

-   **Batch Conversion**: Converts all Mercurial repositories within a specified parent directory.
-   **History Preservation**: Migrates all commits, branches, and tags from Mercurial to Git.
-   **Idempotent**: Safely skips repositories that have already been converted in the destination directory.
-   **Bare Repositories**: Creates clean, bare Git repositories (`<repo_name>.git`), which are ideal for pushing to a remote server.
-   **Dependency Check**: Verifies that required tools (`hg-fast-export`) are installed before running.

## Prerequisites

Before you can use this script, you must have Git, Mercurial, and the `hg-fast-export` utility installed on your system.
update the full path directory in the shell script file for the repos

### Installation

#### macOS (with Homebrew)

```bash
brew install mercurial git hg-fast-export
```

usage

```bash
./svn-to-git.sh {Mercurial repos directory} {Path_to_exported_git_repos}