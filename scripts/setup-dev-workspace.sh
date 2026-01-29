#!/bin/bash

# ============================================================================
# Parallel Development Workspace Setup Script
# ============================================================================
# This script helps set up the workspace for parallel development
# Usage: ./scripts/setup-dev-workspace.sh [dev1|dev2]
#
# Example:
#   ./scripts/setup-dev-workspace.sh dev1   # Setup for Developer 1 (HRM)
#   ./scripts/setup-dev-workspace.sh dev2   # Setup for Developer 2 (PM)
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if developer ID is provided
if [ -z "$1" ]; then
    print_error "Developer ID not provided!"
    echo "Usage: ./scripts/setup-dev-workspace.sh [dev1|dev2]"
    echo ""
    echo "  dev1  - Setup for Developer 1 (HRM Module)"
    echo "  dev2  - Setup for Developer 2 (Project Management Module)"
    exit 1
fi

DEV_ID="$1"

# Validate developer ID
if [ "$DEV_ID" != "dev1" ] && [ "$DEV_ID" != "dev2" ]; then
    print_error "Invalid developer ID: $DEV_ID"
    echo "Must be 'dev1' or 'dev2'"
    exit 1
fi

print_header "Setting up workspace for Developer: $DEV_ID"

# Set module-specific variables
if [ "$DEV_ID" == "dev1" ]; then
    MODULE="HRM (Human Resource Management)"
    BRANCH_PREFIX="dev1-hrm"
    ASSIGNED_DIRS=(
        "react/src/feature-module/hrm/employees"
        "react/src/feature-module/hrm/designation"
        "react/src/feature-module/hrm/promotion"
        "react/src/hooks/useEmployeesREST.ts"
        "backend/routes/api/employees.js"
        "backend/controllers/employee/"
    )
else
    MODULE="Project Management"
    BRANCH_PREFIX="dev2-pm"
    ASSIGNED_DIRS=(
        "react/src/feature-module/projects"
        "react/src/hooks/useProjectsREST.ts"
        "react/src/hooks/useResourcesREST.ts"
        "backend/routes/api/projects.js"
        "backend/controllers/project/"
    )
fi

print_success "Module: $MODULE"
print_success "Branch Prefix: $BRANCH_PREFIX"
echo ""

# Step 1: Check git status
print_header "Step 1: Checking Git Status"

if [ -d ".git" ]; then
    print_success "Git repository detected"

    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        print_warning "You have uncommitted changes!"
        echo "Please commit or stash them before setting up workspace."
        echo ""
        git status --short
        echo ""
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
else
    print_error "Not a git repository!"
    exit 1
fi

# Step 2: Fetch latest changes
print_header "Step 2: Fetching Latest Changes"

git fetch origin
print_success "Fetched latest changes from origin"

# Step 3: Create/Update develop branch
print_header "Step 3: Setting Up Develop Branch"

if git show-ref --verify --quiet refs/heads/develop; then
    print_success "Develop branch already exists locally"
    git checkout develop
    git pull origin develop
else
    print_warning "Develop branch not found locally"
    git checkout -b develop origin/develop
    print_success "Created and checked out develop branch"
fi

# Step 4: Create workspace configuration
print_header "Step 4: Creating Workspace Configuration"

DEV_CONFIG_FILE=".dev-config.json"
cat > "$DEV_CONFIG_FILE" <<EOF
{
  "developerId": "$DEV_ID",
  "module": "$MODULE",
  "branchPrefix": "$BRANCH_PREFIX",
  "assignedDirectories": [
$(for dir in "${ASSIGNED_DIRS[@]}"; do
    echo "    \"$dir\","
done | sed '$ s/,$//')
  ],
  "setupDate": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "lastUpdated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

print_success "Created workspace configuration: $DEV_CONFIG_FILE"

# Step 5: Create local .gitignore entries for developer-specific files
if [ ! -f ".git/info/sparse-checkout" ]; then
    print_header "Step 5: Git Configuration"
    print_warning "Consider setting up sparse checkout if repository is large"
    echo "  See: git sparse-checkout --help"
fi

# Step 6: Display assignment information
print_header "Your Assigned Directories"

echo "You are responsible for the following directories:"
echo ""

for dir in "${ASSIGNED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_success "$dir"
    else
        print_warning "$dir (does not exist yet)"
    fi
done

echo ""
echo "WARNING: Avoid editing files outside these directories"
echo "unless you've coordinated with the other developer."

# Step 7: Create helpful git aliases
print_header "Step 6: Creating Git Aliases"

if [ "$DEV_ID" == "dev1" ]; then
    git config --local alias.hrm-branch '!f() { git checkout develop && git pull origin develop && git checkout -b "dev1-hrm/feature/$1"; }; f'
    git config --local alias.hrm-pr '!gh pr create --base develop --title "HRM: $1"'
    print_success "Created aliases: git hrm-branch, git hrm-pr"
else
    git config --local alias.pm-branch '!f() { git checkout develop && git pull origin develop && git checkout -b "dev2-pm/feature/$1"; }; f'
    git config --local alias.pm-pr '!gh pr create --base develop --title "PM: $1"'
    print_success "Created aliases: git pm-branch, git pm-pr"
fi

# Step 8: Create example feature branch
print_header "Step 7: Creating Example Feature Branch"

print_warning "To create a new feature branch, use:"
if [ "$DEV_ID" == "dev1" ]; then
    echo "  git hrm-branch <feature-name>"
    echo "  Example: git hrm-branch migrate-employees-to-rest"
else
    echo "  git pm-branch <feature-name>"
    echo "  Example: git pm-branch migrate-projects-to-rest"
fi

# Final summary
print_header "Setup Complete!"

print_success "Workspace configured for Developer: $DEV_ID"
print_success "Module: $MODULE"
print_success "Current branch: develop"

echo ""
echo "Next Steps:"
echo "  1. Create a feature branch:"
if [ "$DEV_ID" == "dev1" ]; then
    echo "     git hrm-branch <feature-name>"
else
    echo "     git pm-branch <feature-name>"
fi
echo "  2. Make your changes"
echo "  3. Commit and push:"
echo "     git add ."
echo "     git commit -m 'feat: description'"
echo "     git push origin <branch-name>"
echo "  4. Create pull request to develop branch"
echo ""
echo "For more information, see: .github/workflows/parallel-dev-guide.md"
echo ""

# Optional: Ask if user wants to create first feature branch
read -p "Create your first feature branch now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter feature name (e.g., migrate-to-rest): " feature_name
    if [ -n "$feature_name" ]; then
        if [ "$DEV_ID" == "dev1" ]; then
            git checkout develop && git pull origin develop && git checkout -b "$BRANCH_PREFIX/feature/$feature_name"
            print_success "Created branch: $BRANCH_PREFIX/feature/$feature_name"
        else
            git checkout develop && git pull origin develop && git checkout -b "$BRANCH_PREFIX/feature/$feature_name"
            print_success "Created branch: $BRANCH_PREFIX/feature/$feature_name"
        fi
    fi
fi

print_success "All done! Happy coding!"
