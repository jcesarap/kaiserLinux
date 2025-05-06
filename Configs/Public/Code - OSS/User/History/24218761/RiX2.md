
---
Section: Aðferð
---

# Quick Reference
> Use `grep` for precise search.
- `git -P`
- `git -h`
- `git help <command>`

# Main commands
- `git add .` to add all files
- `git log` - List commits (Add `-p` to the end for diff)
- `git commit --amend` - For edditing last commit - such as message
- `git branch <name>` - Create a branch for existing
- `git checkout <name>` - To switch branches
- `git merge <name>` - Merges the name with current branch
- `git push origin main` - Push to remote
- `git pull origin main` - To update local repository

# Revert
- `git reset --soft <hash>` - Keeps staging area
- `git reset --mixed <hash>` - Removes staging
- `git reset --hard <hash>` - COMPLETELY REMOVES/DELETES CHANGES, FROM HEAD BACKWARDS TO THE CHOSEN COMMIT

---
Section: GitHub
---

# Login
- Install github-cli
- run `gh auth login`

# Interface
- Use gh to create a GitHub repository and add it as a git remote;
    - `git remote add origin <https>`
- Use git to commit and push, like before;
    - Or use github-cli
        - `gh pr create --base main --head functional --title "Melhorando Docs, 1" --body "Instruções de compilação em Linux"`
- Use gh to create and list GitHub issues, etc.

---
Section: GitLab
---

# Clone
git clone https://gitlab.com/inkscape/inkscape

---
Section: Logic & Language
---

# General
- Head - The most recent commit
- Submodules - Nested git repositories, for libraries and dependencies of projects.

# Merge & Rebase
- Merge - Combines branches and creates a merge commit, preserving both branch histories.
- Rebase - Re-applies commits on top of another branch, creating a linear history without merge commits.
- Use merge for preserving history, and rebase for a cleaner, linear history.

# Zones
## List
- **Working Directory:** - The working directory is where your actual files reside. Changes here affect the **project files**, but they are not yet tracked by Git or connected to version history. It reflects the current state of your project, and any modifications made here are considered "untracked" or "unstaged" until added to Git.
- **Staging Area:** - The staging area is part of the **Git directory**. It is where specific file changes from the working directory are prepared to be included in the next commit. This step allows you to organize or split your work into meaningful commits without affecting the history yet. Changes in the staging area exist only in the Git directory and not in the actual files.
    - Where you run `git add .`
- **Local Repository:** - The local repository resides fully in the **Git directory** and contains the project’s complete version history, along with the metadata managed by Git. Once changes are committed from the staging area, they become part of the local repository. At this point, the changes are officially tracked and versioned.
- **Remote Repository:** - The remote repository is a copy of the local repository hosted on a server. It also contains the full version history and Git metadata but does not directly interact with your working directory. Instead, you sync changes between the local and remote repositories through Git operations like push, pull, or fetch.
## Nuance Summary:
- Changes to **files** occur in the working directory.
- Changes to the **Git directory** occur in the staging area and local repository.
- The remote repository is only updated when explicitly synchronized. 
## Explanation through examples
> Best explanation - https://www.youtube.com/watch?v=e9lnsKot_SQ
- `git clone`: Remote Repository -> Local Repository
- `"move to file"`: Working Directory
- `git add`: Stage a snapshot on Staging Area
- `git commit`: SNAPSHOT Of Staging Area (many snapshots) on L.Repo
- `git push`: To get changes to R.Repo
- `git pull`: Gets changes from R.Repo to L.Repo
    - Integrates the following commands:
        - `git fetch`: Updates L.Repo in regards to R.Repo
        - `git merge`: R.Repo to Working Directory

# Creating & Syncing
- `git init` with terminal focused on the folder you want, [creates the repository](The initialization process creates a .git folder within the project folder that stores the files and data for the repository).
- **Syncing repos** - You sync repositories via their URL (or SSH) - easily gotten from GitHub.
  - `git remote add repo-name https://url.com` - `remote` says you want to interact with a remote repo, `add` says how, `repo-name` serves as a shorthand for the URL.

---
Section: Context
---

# Forewords
> Global Information Tracker, designed to be simple as the English slang — Version control system: A system that records changes to a file or set of files over time so that you can recall specific versions later. It can be used to any kind of file - such as design, music...

# Language
- Repository - A central storage location for managing and tracking changes in files and directories.

# Logic
- Staging (I.e., selection) `git add`, `git add .` selects everything.
- Committing (I.e., A commit is a snapshot of your repository at a specific point in time) `git commit` saves the staged changes into the repository's history.
  - Flags:
    - `-m` adds a message
- Fetch

# Commands
- `git remote` - Says you want to interact with remote repos. Without arguments, lists remote repos.

# Tips
## General
- General conventions for repository names suggest using lower case. If there are multiple words, use dashes between the words, such as recipe-book.
- A `.gitignore` defines what Git's version tracking will ignore. E.g., For an application, you don't want to include intermediate build files, as they are often large and can easily be rebuilt from source files.
## Good commit messages
- Short.
- Structure, Subject/body - Insert an empty line after a summary, include more details after.
- Imperative mood on Subject.
- Context on Body - If necessary, use the body of the message to explain the context of the change, why it was needed, and how it affects the system. This helps reviewers and future developers understand the rationale behind the commit.
- Reference Related Issues - If it fixes or relates to issues or tickets in tracker, reference them in the end - E.g., "Resolves #123".
- Consider Using a Standard Format: Adopt a standard format for your commit messages, such as Conventional Commits, which uses prefixes like `feat:`, `fix:`, `style:`, `refactor:`, `test:`, `docs:`, and `chore:` to categorize the nature of the commit.
- Write Clearly About What and Why: Focus on explaining what changes were made and why, rather than how.

# GitHub
> GitHub is a company that seeks profit by easing collaboration of people by *syncing/mirroring their repositories via cloud* - also providing other services. They alo provide a GUI for Git.
> They also extend git functionality with stuff like: Bug tracking, task management, wikis, continuous integration - also, they try to be like a social network, where people can follow each other -, and many other bloat-services.


