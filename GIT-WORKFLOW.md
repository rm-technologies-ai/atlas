# Git Workflow for Atlas Repository

## Repository Structure

Atlas is a **meta-repository** that contains multiple sub-projects, each potentially having its own version control:

- **Atlas root** → GitHub private repo: `https://github.com/repotest182/atlas.git`
- **Subfolders** → May contain cloned repos from GitHub or GitLab (e.g., `/issues/`, future project folders)

## Working with Multiple Repositories

### Atlas Root Repository Commands

From `/mnt/e/repos/atlas/` (or `E:\repos\atlas\`):

```bash
# Check status of Atlas root
git status

# Add and commit changes to Atlas root
git add .
git commit -m "Description of changes"

# Push to GitHub
git push origin main

# Pull latest changes
git pull origin main

# View commit history
git log --oneline
```

### Subfolder Repository Commands

When working with cloned repos inside Atlas (e.g., after cloning archon or other tools):

```bash
# Navigate to subfolder
cd /mnt/e/repos/atlas/<project-folder>

# Check which repo you're in
git remote -v

# Work with the subfolder's repo
git status
git add .
git commit -m "Changes in subfolder project"
git push origin main  # This pushes to the subfolder's remote, NOT Atlas

# Return to Atlas root
cd /mnt/e/repos/atlas
```

### Best Practices

1. **Always check which repository you're in** before running git commands:
   ```bash
   pwd && git remote -v
   ```

2. **Atlas root tracks folder structure only**:
   - Don't commit nested `.git` directories (handled by `.gitignore`)
   - Commit scripts, configs, and documentation at Atlas level
   - Subfolder repos maintain their own history independently

3. **Initial commit workflow**:
   ```bash
   # From Atlas root
   git status                    # Review staged files
   git commit -m "Initial Atlas setup with issues tool and CLAUDE.md"
   git push origin main
   ```

4. **Adding new cloned projects**:
   ```bash
   # Clone a project into Atlas
   cd /mnt/e/repos/atlas
   git clone https://github.com/example/tool.git

   # Atlas will ignore the tool/.git directory
   # To track that a tool exists, you might add a README or config
   cd /mnt/e/repos/atlas
   git add tool/README.md  # Add specific files, not the .git folder
   git commit -m "Added tool project"
   git push origin main
   ```

## Git Configuration

Current global git configuration:
- **User:** Roy Mayfield
- **Email:** roymayfield@hotmail.com
- **Default branch:** main

## Authentication

Git is configured to use credential helper for authentication with GitHub. If prompted for credentials during push/pull:
- Use your GitHub username
- Use a Personal Access Token (PAT) as password, not your GitHub password

## Common Scenarios

### Scenario 1: Update Atlas documentation
```bash
cd /mnt/e/repos/atlas
git add CLAUDE.md GIT-WORKFLOW.md
git commit -m "Updated documentation"
git push origin main
```

### Scenario 2: Work on a cloned GitLab project
```bash
cd /mnt/e/repos/atlas/lion-project
git checkout -b feature-branch
# ... make changes ...
git add .
git commit -m "Implemented feature"
git push origin feature-branch
```

### Scenario 3: Update multiple repos in one session
```bash
# Update Atlas root
cd /mnt/e/repos/atlas
git add . && git commit -m "Root updates" && git push origin main

# Update subfolder repo
cd /mnt/e/repos/atlas/subfolder-project
git add . && git commit -m "Subfolder updates" && git push origin main

# Return to Atlas root
cd /mnt/e/repos/atlas
```

## Checking Repository Context

Before any git operation, verify your context:
```bash
# Where am I?
pwd

# Which repo am I in?
git remote -v

# What branch am I on?
git branch

# Combined check
echo "Location: $(pwd)" && echo "Remote: $(git remote get-url origin 2>/dev/null || echo 'No remote')" && echo "Branch: $(git branch --show-current 2>/dev/null || echo 'No branch')"
```
