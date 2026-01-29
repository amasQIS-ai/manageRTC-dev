# ============================================================================
# Parallel Development Workspace Setup Script (PowerShell)
# ============================================================================
# This script helps set up the workspace for parallel development
# Usage: .\scripts\setup-dev-workspace.ps1 -DeveloperId dev1
#        .\scripts\setup-dev-workspace.ps1 -DeveloperId dev2
#
# Example:
#   .\scripts\setup-dev-workspace.ps1 -DeveloperId dev1   # Setup for Developer 1 (HRM)
#   .\scripts\setup-dev-workspace.ps1 -DeveloperId dev2   # Setup for Developer 2 (PM)
# ============================================================================

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev1", "dev2")]
    [string]$DeveloperId
)

# Color functions
function Print-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Print-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Print-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Print-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

# Main script
try {
    Print-Header "Setting up workspace for Developer: $DeveloperId"

    # Set module-specific variables
    if ($DeveloperId -eq "dev1") {
        $Module = "HRM (Human Resource Management)"
        $BranchPrefix = "dev1-hrm"
        $AssignedDirs = @(
            "react/src/feature-module/hrm/employees",
            "react/src/feature-module/hrm/designation",
            "react/src/feature-module/hrm/promotion",
            "react/src/hooks/useEmployeesREST.ts",
            "backend/routes/api/employees.js",
            "backend/controllers/employee/"
        )
    } else {
        $Module = "Project Management"
        $BranchPrefix = "dev2-pm"
        $AssignedDirs = @(
            "react/src/feature-module/projects",
            "react/src/hooks/useProjectsREST.ts",
            "react/src/hooks/useResourcesREST.ts",
            "backend/routes/api/projects.js",
            "backend/controllers/project/"
        )
    }

    Print-Success "Module: $Module"
    Print-Success "Branch Prefix: $BranchPrefix"
    Write-Host ""

    # Step 1: Check git status
    Print-Header "Step 1: Checking Git Status"

    if (Test-Path ".git") {
        Print-Success "Git repository detected"

        # Check for uncommitted changes
        $gitStatus = git status --porcelain 2>$null
        if ($gitStatus) {
            Print-Warning "You have uncommitted changes!"
            Write-Host "Please commit or stash them before setting up workspace."
            Write-Host ""
            git status --short
            Write-Host ""

            $continue = Read-Host "Continue anyway? (y/N)"
            if ($continue -ne "y" -and $continue -ne "Y") {
                exit 1
            }
        }
    } else {
        Print-Error "Not a git repository!"
        exit 1
    }

    # Step 2: Fetch latest changes
    Print-Header "Step 2: Fetching Latest Changes"

    git fetch origin
    Print-Success "Fetched latest changes from origin"

    # Step 3: Create/Update develop branch
    Print-Header "Step 3: Setting Up Develop Branch"

    $developExists = git show-ref --verify --quiet refs/heads/develop 2>$null
    if ($developExists) {
        Print-Success "Develop branch already exists locally"
        git checkout develop
        git pull origin develop
    } else {
        Print-Warning "Develop branch not found locally"
        git checkout -b develop origin/develop
        Print-Success "Created and checked out develop branch"
    }

    # Step 4: Create workspace configuration
    Print-Header "Step 4: Creating Workspace Configuration"

    $devConfigFile = ".dev-config.json"
    $assignedDirsJson = $AssignedDirs | ForEach-Object { "    `"$_`"," }
    $assignedDirsJson[-1] = $assignedDirsJson[-1] -replace ',$'

    $configContent = @"
{
  "developerId": "$DeveloperId",
  "module": "$Module",
  "branchPrefix": "$BranchPrefix",
  "assignedDirectories": [
$assignedDirsJson
  ],
  "setupDate": "$(Get-Date -Format 'o')",
  "lastUpdated": "$(Get-Date -Format 'o')"
}
"@

    Set-Content -Path $devConfigFile -Value $configContent
    Print-Success "Created workspace configuration: $devConfigFile"

    # Step 5: Display assignment information
    Print-Header "Your Assigned Directories"

    Write-Host "You are responsible for the following directories:"
    Write-Host ""

    foreach ($dir in $AssignedDirs) {
        if (Test-Path $dir) {
            Print-Success $dir
        } else {
            Print-Warning "$dir (does not exist yet)"
        }
    }

    Write-Host ""
    Write-Host "WARNING: Avoid editing files outside these directories"
    Write-Host "unless you've coordinated with the other developer."

    # Step 6: Create helpful git aliases
    Print-Header "Step 5: Creating Git Aliases"

    if ($DeveloperId -eq "dev1") {
        git config --local alias.hrm-branch '!f() { git checkout develop && git pull origin develop && git checkout -b "dev1-hrm/feature/$1"; }; f'
        git config --local alias.hrm-pr '!gh pr create --base develop --title "HRM: $1"'
        Print-Success "Created aliases: git hrm-branch, git hrm-pr"
    } else {
        git config --local alias.pm-branch '!f() { git checkout develop && git pull origin develop && git checkout -b "dev2-pm/feature/$1"; }; f'
        git config --local alias.pm-pr '!gh pr create --base develop --title "PM: $1"'
        Print-Success "Created aliases: git pm-branch, git pm-pr"
    }

    # Step 7: Create example feature branch
    Print-Header "Step 6: Creating Example Feature Branch"

    Print-Warning "To create a new feature branch, use:"
    if ($DeveloperId -eq "dev1") {
        Write-Host "  git hrm-branch <feature-name>"
        Write-Host "  Example: git hrm-branch migrate-employees-to-rest"
    } else {
        Write-Host "  git pm-branch <feature-name>"
        Write-Host "  Example: git pm-branch migrate-projects-to-rest"
    }

    # Final summary
    Print-Header "Setup Complete!"

    Print-Success "Workspace configured for Developer: $DeveloperId"
    Print-Success "Module: $Module"
    Print-Success "Current branch: develop"

    Write-Host ""
    Write-Host "Next Steps:"
    Write-Host "  1. Create a feature branch:"
    if ($DeveloperId -eq "dev1") {
        Write-Host "     git hrm-branch <feature-name>"
    } else {
        Write-Host "     git pm-branch <feature-name>"
    }
    Write-Host "  2. Make your changes"
    Write-Host "  3. Commit and push:"
    Write-Host "     git add ."
    Write-Host "     git commit -m 'feat: description'"
    Write-Host "     git push origin <branch-name>"
    Write-Host "  4. Create pull request to develop branch"
    Write-Host ""
    Write-Host "For more information, see: .github/workflows/parallel-dev-guide.md"
    Write-Host ""

    # Optional: Ask if user wants to create first feature branch
    $createBranch = Read-Host "Create your first feature branch now? (y/N)"
    if ($createBranch -eq "y" -or $createBranch -eq "Y") {
        $featureName = Read-Host "Enter feature name (e.g., migrate-to-rest)"
        if ($featureName) {
            $branchName = "$BranchPrefix/feature/$featureName"
            git checkout develop
            git pull origin develop
            git checkout -b $branchName
            Print-Success "Created branch: $branchName"
        }
    }

    Print-Success "All done! Happy coding!"

} catch {
    Print-Error "Error: $_"
    Write-Host $_.ScriptStackTrace
    exit 1
}
