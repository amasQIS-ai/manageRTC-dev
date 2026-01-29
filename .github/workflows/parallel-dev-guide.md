# Parallel Development Guide for manageRTC HRMS

## Overview

This document provides the complete workflow for 2 developers to work simultaneously on the manageRTC HRMS platform without merge conflicts.

---

## 🎯 MODULE ASSIGNMENT STRATEGY

### Developer 1: HRM Module (Human Resource Management)
- **Assigned Files:** 13 frontend files
- **REST Endpoints:** /api/employees/*
- **Branch Prefix:** `dev1-hrm/`
- **Primary Focus:** Employee management, designations, promotions

### Developer 2: Project Management Module
- **Assigned Files:** 8 frontend files
- **REST Endpoints:** /api/projects/*
- **Branch Prefix:** `dev2-pm/`
- **Primary Focus:** Projects, resources, budgets, time tracking

### Shared Work (Both Developers):
- Common utilities and services
- Shared components (modals, layouts)
- Authentication and authorization
- Error handling and validation

---

## 📁 RECOMMENDED GIT WORKFLOW

### Main Branches
```
main                    # Production-ready code
├── develop             # Integration branch for all features
    ├── dev1-hrm/*      # Developer 1 feature branches
    └── dev2-pm/*       # Developer 2 feature branches
```

### Branch Naming Convention

#### Developer 1 Branches (HRM)
```bash
# Feature branches
dev1-hrm/feature/employee-list-rest
dev1-hrm/feature/employee-grid-rest
dev1-hrm/feature/designations-rest
dev1-hrm/feature/promotions-rest

# Bugfix branches
dev1-hrm/fix/employee-validation
dev1-hrm/fix/designation-duplicate
```

#### Developer 2 Branches (Project Management)
```bash
# Feature branches
dev2-pm/feature/project-list-rest
dev2-pm/feature/resource-allocation
dev2-pm/feature/budget-tracking
dev2-pm/feature/time-tracking-rest
```

---

## 🔄 DAILY WORKFLOW

### 1. Morning Sync (Both Developers)
```bash
# Update local develop branch
git checkout develop
git pull origin develop

# Check for new changes
git log --oneline --graph --all -10
```

### 2. Developer 1 Starting New Feature
```bash
# Create feature branch from latest develop
git checkout develop
git pull origin develop
git checkout -b dev1-hrm/feature/employee-list-rest

# Work on feature...
git add .
git commit -m "feat: migrate employeesList to REST API"
git push origin dev1-hrm/feature/employee-list-rest
```

### 3. Developer 2 Starting New Feature
```bash
# Create feature branch from latest develop
git checkout develop
git pull origin develop
git checkout -b dev2-pm/feature/project-list-rest

# Work on feature...
git add .
git commit -m "feat: migrate projectList to REST API"
git push origin dev2-pm/feature/project-list-rest
```

### 4. Creating Pull Request
```bash
# Developer 1 creates PR to develop
gh pr create --base develop --title "HRM: Migrate employeesList to REST" --body "Closes #123"

# Developer 2 creates PR to develop
gh pr create --base develop --title "PM: Migrate projectList to REST" --body "Closes #124"
```

---

## 🚫 CONFLICT PREVENTION RULES

### Rule 1: Never Edit Shared Files Simultaneously
Both developers MUST NOT edit these files at the same time:
```
react/src/SocketContext.tsx
react/src/services/api.ts
backend/config/db.js
backend/socket/index.js
backend/server.js
package.json
```

**If you need to edit a shared file:**
1. Create a draft PR first
2. Notify the other developer
3. Wait for their approval before proceeding

### Rule 2: Use Module-Specific Folders
Keep your work in assigned folders:
```
# Developer 1 (HRM)
react/src/feature-module/hrm/employees/*
react/src/hooks/useEmployeesREST.ts
backend/routes/api/employees.js
backend/controllers/employee/employee.controller.js

# Developer 2 (Project Management)
react/src/feature-module/projects/*
react/src/hooks/useProjectsREST.ts
backend/routes/api/projects.js
backend/controllers/project/project.controller.js
```

### Rule 3: Coordinate REST API Changes
Before adding new REST endpoints:
1. Check existing endpoints in `backend/routes/api/`
2. Coordinate API design with the team
3. Document new endpoints in API docs

---

## 🔀 HANDLING MERGE CONFLICTS

### Scenario 1: Shared File Conflict
```bash
# Developer 1 gets conflict when merging to develop
git checkout develop
git merge dev1-hrm/feature/employee-list-rest

# Conflict detected in: react/src/services/api.ts

# Steps to resolve:
1. git status  # See conflict files
2. Open conflict file in editor
3. Look for: <<<<<<<, =======, >>>>>>> markers
4. Contact Developer 2 to coordinate changes
5. Resolve conflicts manually
6. git add <resolved-file>
7. git commit -m "resolve: merge conflict in api.ts"
8. git push origin develop
```

### Scenario 2: Same File Conflict (Different Functions)
```bash
# Both developers edited different parts of same file

# Resolution strategy:
1. Use 'git merge-file' for automatic merge
2. Review merged result
3. Test both features work
4. Commit with detailed message
```

---

## 📋 WEEKLY SYNC PROTOCOL

### Monday Morning (15 minutes)
- Review completed features from last week
- Plan this week's tasks
- Identify potential conflicts

### Wednesday Morning (10 minutes)
- Check progress on current tasks
- Identify any blocking issues
- Coordinate shared file changes

### Friday Afternoon (30 minutes)
- Demo completed features
- Review open PRs
- Plan next week's priorities

---

## 🛠️ DEVELOPMENT ENVIRONMENT SETUP

### Step 1: Clone Repository
```bash
git clone https://github.com/your-org/hrms-tool-amasqis.git
cd hrms-tool-amasqis
```

### Step 2: Install Dependencies
```bash
# Backend
cd backend
npm install

# Frontend
cd ../react
npm install
```

### Step 3: Configure Environment
```bash
# Backend
cp backend/.env.example backend/.env
# Edit backend/.env with your values

# Frontend
cp react/.env.example react/.env
# Edit react/.env with your values
```

### Step 4: Start Development Servers
```bash
# Terminal 1 - Backend
cd backend
npm run dev

# Terminal 2 - Frontend
cd react
npm start
```

---

## 📊 PROGRESS TRACKING

### Module Completion Criteria

#### HRM Module (Developer 1)
- [ ] All employee pages migrated to REST (13 files)
- [ ] All designations pages migrated (2 files)
- [ ] All promotions pages migrated (2 files)
- [ ] All resignation/termination pages migrated (4 files)
- [ ] REST API endpoints tested and documented
- [ ] Test coverage > 80%

#### Project Management Module (Developer 2)
- [ ] All project pages migrated to REST (8 files)
- [ ] Resource allocation module complete
- [ ] Budget tracking module complete
- [ ] Time tracking module complete
- [ ] REST API endpoints tested and documented
- [ ] Test coverage > 80%

### Weekly Status Report Template
```markdown
## Week of [Date]

### Developer 1 (HRM)
**Completed:**
- [x] Migrated employeesList.tsx to REST
- [x] Fixed designation validation bug

**In Progress:**
- [ ] employeesGrid.tsx migration (50% complete)

**Blocked:**
- None

**Plans for Next Week:**
- Complete employeesGrid.tsx
- Start employeedetails.tsx migration

### Developer 2 (Project Management)
**Completed:**
- [x] Migrated projectList.tsx to REST
- [x] Created resource allocation REST endpoints

**In Progress:**
- [ ] Budget tracking module (30% complete)

**Blocked:**
- Need clarification on budget calculation logic

**Plans for Next Week:**
- Complete budget tracking
- Start time tracking module
```

---

## 🚨 ESCALATION PATH

### Level 1: Feature Block
**Issue:** Can't proceed with current task due to missing information
**Action:** Tag the other developer in PR comments or Slack

### Level 2: Merge Conflict
**Issue:** Cannot resolve merge conflict after 30 minutes
**Action:** Schedule quick 15-minute sync to resolve together

### Level 3: Architectural Decision
**Issue:** Disagreement on implementation approach
**Action:** Escalate to Tech Lead for decision

### Level 4: Critical Bug
**Issue:** Production bug or security issue
**Action:** Immediately notify both developers + Tech Lead

---

## 📞 COMMUNICATION CHANNELS

### Daily Communication
- **Slack Channel:** #hrms-development
- **Standup:** Daily at 10:00 AM (15 minutes)
- **PR Reviews:** Respond within 2 hours during work hours

### Code Review Guidelines
1. All PRs must be reviewed before merging
2. At least one approval required
3. All tests must pass
4. No merge conflicts with develop branch

---

## ✅ SUCCESS CRITERIA

### Module Completion Checklist
- [ ] All assigned frontend files migrated to REST
- [ ] All Socket.IO calls removed from assigned files
- [ ] All REST API endpoints created and tested
- [ ] Test coverage > 80% for assigned modules
- [ ] No console.log statements in production code
- [ ] All environment variables properly configured
- [ ] Documentation updated

### Integration Checklist
- [ ] Both developer branches merge cleanly to develop
- [ ] No merge conflicts in shared files
- [ ] All tests pass in CI/CD pipeline
- [ ] Manual testing completed for cross-module functionality
- [ ] API documentation updated and published

---

**Last Updated:** January 29, 2026
**Version:** 1.0
**Maintained By:** Technical Lead
