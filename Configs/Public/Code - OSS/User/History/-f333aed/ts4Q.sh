# Paths to snapshots with git
dirs=(
    "~/.Snapshots/Automated/Dropbox/"
)
for dir in "${dirs[@]}"; do
    cd "$dir" || continue  # If cd fails, skip this directory
    # Redundancy
    git config user.username "kaiser"
    git config user.email "jkaisermp@protonmail.com"
    git init
    git branch automatic || :
    # Trim snapshots older than 10 days
    git checkout --orphan new-branch  # Create a new branch without history
    git commit --allow-empty -m "Starting fresh with last 10 days of commits"  # Allow an empty commit if needed
    git cherry-pick $(git rev-list --reverse --after="10 days ago" automatic)
    git branch -D automatic
    git branch -m automatic
    git gc --prune=now --aggressive  # Clean up unreachable commits

    # Snap: update snapshot
    git checkout automatic
    if [[ "$dir" == "~/.Snapshots/Automated/Dropbox/" ]]; then
        git add Dropbox/
    else
        git add --all
    fi
    current_date=$(date "+%Y-%m-%d %H:%M:%S")
    git commit -m "Auto commit on $current_date"
done
