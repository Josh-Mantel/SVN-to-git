#!/bin/bash

# A script to batch convert local offline Mercurial repositories to Git.

# --- Configuration ---
# The parent directory containing your Mercurial repositories.
HG_PARENT_DIR="$1"
# The directory where the new Git repositories will be created.
GIT_PARENT_DIR="$2"

FullDir="~/Documents/GitHub/SVN-to-git"

# --- Pre-flight Checks ---

# Check for the required 'hg-fast-export' tool.
if ! command -v hg-fast-export.sh &> /dev/null; then
    echo "❌ Error: 'hg-fast-export' is not installed."
    echo "Please install it to proceed. On macOS: 'brew install hg-fast-export'. On Debian/Ubuntu: 'sudo apt-get install mercurial-fast-export'."
    exit 1
fi

# Check if source and destination directories are provided.
if [ -z "$HG_PARENT_DIR" ] || [ -z "$GIT_PARENT_DIR" ]; then
    echo "Usage: $0 <source_hg_directory> <destination_git_directory>"
    exit 1
fi

# Check if the source directory exists.
if [ ! -d "$HG_PARENT_DIR" ]; then
    echo "❌ Error: Source directory '$HG_PARENT_DIR' not found."
    exit 1
fi

# Create the destination directory if it doesn't exist.
mkdir -p "$GIT_PARENT_DIR"

# --- Conversion Loop ---

echo "🚀 Starting conversion from '$HG_PARENT_DIR' to '$GIT_PARENT_DIR'..."

for hg_repo in "$HG_PARENT_DIR"/*; do
    # Check if it's a directory and a Mercurial repository.
    if [ -d "$hg_repo" ] && [ -d "$hg_repo/.hg" ]; then
        REPO_NAME=$(basename "$hg_repo")
        GIT_REPO_PATH="$GIT_PARENT_DIR/$REPO_NAME"

        echo "-----------------------------------------------------"
        echo "⏳ Converting repository: $REPO_NAME"

        # Check if the destination Git repo already exists.
        if [ -d "$GIT_REPO_PATH" ]; then
            echo "⚠️  Skipping: Git repository '$GIT_REPO_PATH' already exists."
            continue
        fi

        # 1. Initialize a new bare Git repository.
        
        git init --bare "$GIT_REPO_PATH"

        # 2. Navigate into the new Git repo and run the conversion.
        (
            cd "$GIT_REPO_PATH" && \
            git config core.IgnoreCase false && \
            hg-fast-export.sh -r "$FullDir/$hg_repo" -f && \
            git checkout HEAD
        )

        if [ $? -eq 0 ]; then
            echo "✅ Successfully converted '$REPO_NAME' to '$GIT_REPO_PATH'"
        else
            echo "❌ Error converting '$REPO_NAME'. Please check for errors."
            # Optional: remove partially created repo on failure
            # rm -rf "$GIT_REPO_PATH"
        fi
    fi
done

echo "-----------------------------------------------------"
echo "🎉 All repositories processed."