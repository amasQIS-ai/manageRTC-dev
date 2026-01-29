# PARALLEL DEVELOPMENT SETUP GUIDE
## manageRTC HRMS Platform - 2 Developer Workflow

**Created:** January 29, 2026
**Purpose:** Enable simultaneous development without merge conflicts
**Team Size:** 2 Developers (1 Backend, 1 Frontend initially)

---

## 🎯 DEVELOPMENT STRATEGY

### Module Assignment for Parallel Work

#### **Phase 1 (Week 1-3): HRM Module**
| Developer | Modules | Files | Branch |
|-----------|---------|-------|--------|
| **Dev 1 (Backend)** | HRM Backend | backend/models/hrm, backend/controllers/rest/hrm, backend/routes/api/hrm | `feature/hrm-backend` |
| **Dev 2 (Frontend)** | HRM Frontend | react/src/feature-module/hrm, react/src/hooks/*HRM* | `feature/hrm-frontend` |

#### **Phase 2 (Week 4-6): Project Management Module**
| Developer | Modules | Files | Branch |
|-----------|---------|-------|--------|
| **Dev 1 (Backend)** | PM Backend | backend/models/project, backend/controllers/rest/project, backend/routes/api/project | `feature/pm-backend` |
| **Dev 2 (Frontend)** | PM Frontend | react/src/feature-module/projects, react/src/hooks/*Project*, react/src/hooks/*Task* | `feature/pm-frontend` |

#### **Phase 3 (Week 7-9): CRM Module**
| Developer | Modules | Files | Branch |
|-----------|---------|-------|--------|
| **Dev 1 (Backend)** | CRM Backend | backend/models/crm, backend/controllers/rest/crm, backend/routes/api/crm | `feature/crm-backend` |
| **Dev 2 (Frontend)** | CRM Frontend | react/src/feature-module/crm, react/src/hooks/*Lead*, react/src/hooks/*Client* | `feature/crm-frontend` |

#### **Phase 4 (Week 10+): Other Modules**
| Developer | Modules | Files | Branch |
|-----------|---------|-------|--------|
| **Dev 1 (Backend)** | Remaining | All other backend modules | `feature/other-backend` |
| **Dev 2 (Frontend)** | Remaining | All other frontend modules | `feature/other-frontend` |

---

## 📁 FOLDER STRUCTURE FOR PARALLEL DEVELOPMENT

### Current Structure (Reorganize This)

```
hrms-tool-amasqis/
├── backend/
│   ├── controllers/        # ❌ CONFLICT RISK - Both devs access
│   ├── models/             # ❌ CONFLICT RISK - Both devs access
│   ├── routes/             # ❌ CONFLICT RISK - Both devs access
│   └── services/           # ❌ CONFLICT RISK - Both devs access
├── react/
│   └── src/
│       ├── feature-module/ # ❌ CONFLICT RISK - Both devs access
│       ├── hooks/           # ❌ CONFLICT RISK - Both devs access
│       └── services/        # ✅ Safe - Shared code
└── .ferb/docs/             # ✅ Safe - Documentation
```

### Proposed Structure (Conflict-Free)

```
hrms-tool-amasqis/
│
├── 📦 SHARED/ (Read-only for developers)
│   ├── backend-shared/     # Common backend code
│   │   ├── middleware/      # Auth, error handling, validation
│   │   ├── utils/           # Logger, emailer, helpers
│   │   ├── config/          # Database, Swagger, env
│   │   └── socket/          # Socket.IO configuration
│   │
│   ├── react-shared/        # Common frontend code
│   │   ├── core/            # Core components (dataTable, header, sidebar)
│   │   ├── services/        # API service layer
│   │   ├── hooks/           # Base hooks (useApi, useSocket)
│   │   ├── types/           # TypeScript definitions
│   │   ├── utils/           # Utility functions
│   │   └── styles/          # Global styles
│   │
│   └── docs/                # All documentation
│       ├── architecture/    # Architecture diagrams
│       ├── api/             # API documentation
│       └── guides/          # Development guides
│
├── 👥 DEVELOPER-1 (Backend Focus)
│   ├── backend-dev1/
│   │   ├── modules/         # Module-specific backend code
│   │   │   ├── hrm/          # ✅ Dev 1 works here exclusively
│   │   │   ├── project/      # ✅ Dev 1 works here exclusively
│   │   │   ├── crm/          # ✅ Dev 1 works here exclusively
│   │   │   └── other/        # ✅ Dev 1 works here exclusively
│   │   │
│   │   ├── controllers/     # REST controllers (organized by module)
│   │   │   ├── routes/        # API routes (organized by module)
│   │   │   └── tests/         # Backend tests
│   │   │
│   │   └── server-dev1.js    # Dev 1's server instance
│   │
│   └── react-dev1/           # Dev 1's React workspace (for full-stack testing)
│       └── .dev1-local       # Dev 1's local configuration
│
├── 👥 DEVELOPER-2 (Frontend Focus)
│   ├── react-dev2/
│   │   ├── modules/         # Module-specific frontend code
│   │   │   ├── hrm/          # ✅ Dev 2 works here exclusively
│   │   │   ├── project/      # ✅ Dev 2 works here exclusively
│   │   │   ├── crm/          # ✅ Dev 2 works here exclusively
│   │   │   └── other/        # ✅ Dev 2 works here exclusively
│   │   │
│   │   ├── hooks/           # REST hooks (organized by module)
│   │   │   ├── components/    # Module-specific components
│   │   │   └── tests/         # Frontend tests
│   │   │
│   │   └── index-dev2.tsx    # Dev 2's entry point
│   │
│   └── backend-dev2/         # Dev 2's backend workspace (for full-stack testing)
│       └── .dev2-local       # Dev 2's local configuration
│
├── 🚀 DEPLOYMENT/           # Deployment configurations
│   ├── docker/              # Docker configurations
│   ├── kubernetes/          # K8s configurations (if using)
│   └── scripts/             # Deployment scripts
│
└── 🧪 TESTING/              # Testing infrastructure
    ├── e2e/                 # E2E tests
    ├── integration/         # Integration tests
    └── performance/         # Performance tests
```

---

## 🔄 MIGRATION PLAN

### Step 1: Create New Folder Structure

Run these scripts to reorganize the codebase:

```bash
# From repository root
cd c:\Users\SUDHAKAR\Documents\GitHub\hrms-tool-amasqis

# Create shared directories
mkdir -p backend-shared/middleware
mkdir -p backend-shared/utils
mkdir -p backend-shared/config
mkdir -p backend-shared/socket
mkdir -p react-shared/core
mkdir -p react-shared/services
mkdir -p react-shared/hooks
mkdir -p react-shared/types
mkdir -p react-shared/utils
mkdir -p react-shared/styles
mkdir -p docs/architecture
mkdir -p docs/api
mkdir -p docs/guides

# Create developer directories
mkdir -p backend-dev1/modules/{hrm,project,crm,other}
mkdir -p backend-dev1/{controllers,routes,tests}
mkdir -p react-dev1/modules/{hrm,project,crm,other}
mkdir -p react-dev1/{hooks,components,tests}

mkdir -p react-dev2/modules/{hrm,project,crm,other}
mkdir -p react-dev2/{hooks,components,tests}
mkdir -p backend-dev2 # For testing only

# Create deployment directories
mkdir -p deployment/docker
mkdir -p deployment/scripts

# Create testing directories
mkdir -p testing/e2e
mkdir -p testing/integration
mkdir -p testing/performance
```

### Step 2: Move Shared Code

```bash
# Backend shared code (reference only, create symlinks)
# These stay in backend/ but are imported via backend-shared

# React shared code
mv react/src/core/* react-shared/core/
mv react/src/services/* react-shared/services/
mv react/src/hooks/useApi.ts react-shared/hooks/
mv react/src/hooks/useSocket.ts react-shared/hooks/
mv react/src/types react-shared/types/
mv react/src/utils react-shared/utils/
mv react/src/style react-shared/styles/
```

### Step 3: Create Module Symlinks

For each developer, create symlinks to their assigned modules:

**Developer 1 (Backend HRM):**
```bash
# In backend-dev1/controllers/
ln -s ../../backend/controllers/rest/* ./  # Reference existing

# Create module-specific symlinks
cd backend-dev1/modules/hrm/
ln -s ../../backend/controllers/rest/employee.controller.js ./controllers/
ln -s ../../backend/controllers/rest/attendance.controller.js ./controllers/
ln -s ../../backend/models/employee ./models/
ln -s ../../backend/routes/api/employees.js ./routes/
```

**Developer 2 (Frontend HRM):**
```bash
# In react-dev2/modules/hrm/
ln -s ../../react/src/feature-module/hrm ./components

# Create module-specific symlinks
cd react-dev2/hooks/
ln -s ../../react/src/hooks/useEmployeesREST.ts ./hooks/
ln -s ../../react/src/hooks/useAttendanceREST.ts ./hooks/
ln -s ../../react/src/hooks/useLeaveREST.ts ./hooks/
```

---

## 🚀 GIT WORKFLOW FOR PARALLEL DEVELOPMENT

### Branch Strategy

```
main (production)
  ├── develop (integration)
  │   ├── feature/hrm-backend (Dev 1 - HRM backend)
  │   ├── feature/hrm-frontend (Dev 2 - HRM frontend)
  │   ├── feature/pm-backend (Dev 1 - PM backend)
  │   ├── feature/pm-frontend (Dev 2 - PM frontend)
  │   ├── feature/crm-backend (Dev 1 - CRM backend)
  │   ├── feature/crm-frontend (Dev 2 - CRM frontend)
  │   ├── feature/other-backend (Dev 1 - Other backend)
  │   └── feature/other-frontend (Dev 2 - Other frontend)
  │
  ├── hotfix/* (Emergency fixes)
  └── release/* (Release branches)
```

### Development Workflow

#### 1. Developer 1 Workflow (Backend HRM)

```bash
# 1. Create feature branch
git checkout develop
git pull origin develop
git checkout -b feature/hrm-backend

# 2. Work in backend-dev1/modules/hrm/
cd backend-dev1/modules/hrm

# 3. Make changes (create/edit files)
# 4. Test changes locally
npm test
npm run lint

# 5. Commit frequently
git add .
git commit -m "feat(hrm): add employee validation"

# 6. Push to feature branch
git push origin feature/hrm-backend

# 7. Create Pull Request to develop
# Use GitHub UI or: gh pr create --base develop
```

#### 2. Developer 2 Workflow (Frontend HRM)

```bash
# 1. Create feature branch
git checkout develop
git pull origin develop
git checkout -b feature/hrm-frontend

# 2. Work in react-dev2/modules/hrm/
cd react-dev2/modules/hrm

# 3. Make changes (create/edit files)
# 4. Test changes locally
npm test
npm run lint

# 5. Commit frequently
git add .
git commit -m "feat(hrm): migrate employee list to REST"

# 6. Push to feature branch
git push origin feature/hrm-frontend

# 7. Create Pull Request to develop
# Use GitHub UI or: gh pr create --base develop
```

### Merge Strategy

**Use GitHub's "Squash and Merge" strategy:**

```bash
# When merging feature branches to develop:
# 1. Review PR
# 2. Ensure tests pass
# 3. Squash and merge
# 4. Delete feature branch

# No rebase merges (prevents duplicate commits)
# No fast-forward merges (keeps history clean)
```

---

## 🔀 MERGING PHASES

### Phase Integration (When Moving to Next Module)

When completing HRM module and starting Project Management:

**1. Create Integration Branch**
```bash
git checkout develop
git checkout -b integrate/hrm-complete

# Merge both HRM branches
git merge feature/hrm-backend --squash
git merge feature/hrm-frontend --squash

# Test integration
npm test
npm run build

# Push to develop
git push origin integrate/hrm-complete
# Create PR to main
```

**2. Tag Release**
```bash
# After merge to main
git tag v0.1.0-hrm-complete
git push origin v0.1.0-hrm-complete
```

**3. Start Next Phase**
```bash
# Create new branches for Project Management
git checkout develop
git checkout -b feature/pm-backend
git checkout -b feature/pm-frontend
```

---

## 📋 MODULE COMPLETION CHECKLIST

### HRM Module Completion Criteria

**Backend (Dev 1):**
- [ ] All REST controllers created and tested
- [ ] All routes registered in server.js
- [ ] All models validated and indexed
- [ ] API documentation complete (Swagger)
- [ ] Unit tests passing (80%+ coverage)
- [ ] Integration tests passing
- [ ] Code reviewed by peer

**Frontend (Dev 2):**
- [ ] All pages migrated to REST hooks
- [ ] No Socket.IO emits remaining
- [ ] All TypeScript errors resolved
- [ ] Components tested
- [ ] E2E tests passing
- [ ] Performance acceptable (< 3s load time)
- [ ] Code reviewed by peer

### Sign-off Process

**Before marking module complete:**

1. **Developer Self-Review**
   - [ ] Code follows linting rules
   - [ ] No console.log statements
   - [ ] No TODO/FIXME comments
   - [ ] All commits have clear messages

2. **Peer Code Review**
   - [ ] Code reviewed by other developer
   - [ ] All feedback addressed
   - [ ] Approval received

3. **Testing Review**
   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing complete
   - [ ] No known bugs

4. **Documentation Review**
   - [ ] API docs updated
   - [ ] Component docs updated
   - [ ] Architecture docs updated
   - [ ] Migration guide updated

---

## 🚫 CONFLICT PREVENTION RULES

### Rule 1: File Ownership
- **Each file has ONE owner** based on module assignment
- Dev 1 owns all backend files in their assigned modules
- Dev 2 owns all frontend files in their assigned modules
- Never edit files owned by the other developer without communication

### Rule 2: Communication Before Changes
- **Before editing shared code:**
  - Post in Slack channel: #dev-coordination
  - Describe what you want to change
  - Wait for acknowledgement from other developer
  - Make changes together if needed

### Rule 3: Commit Message Format
Use conventional commits:
```
feat(module): description
fix(module): description
refactor(module): description
docs(module): description
test(module): description
chore(module): description
```

### Rule 4: Branch Naming
- `feature/<module>-backend` - Backend features
- `feature/<module>-frontend` - Frontend features
- `hotfix/<issue>` - Emergency fixes
- `refactor/<component>` - Code refactoring

### Rule 5: Pull Request Guidelines
- **Title:** Must follow commit message format
- **Description:** Must include:
  - What was changed
  - Why it was changed
  - How to test
  - Screenshots (if UI changes)
- **Labels:** Must include module label (hrm, project, crm, etc.)
- **Reviewers:** Must request review from other developer

---

## 📊 PROGRESS TRACKING

### Weekly Status Report Template

```markdown
## Week X Status Report - HRM Module

### Developer 1 (Backend)
**Completed:**
- [x] Employee controller (11 endpoints)
- [x] Attendance controller (10 endpoints)
- [x] Leave controller (10 endpoints)

**In Progress:**
- [ ] Payroll controller (0/9 endpoints)
- [ ] Performance controller (5/9 endpoints)

**Blocked:**
- None

**Planned Next Week:**
- Complete payroll controller
- Add database indexes
- Write unit tests

### Developer 2 (Frontend)
**Completed:**
- [x] Department page migration
- [x] Policy page migration
- [x] useDepartmentsREST hook
- [x] usePoliciesREST hook

**In Progress:**
- [ ] Promotion page migration (0/12 socket calls)
- [ ] Resignation page migration (0/18 socket calls)

**Blocked:**
- Waiting on backend: Designation REST endpoints

**Planned Next Week:**
- Complete promotion, resignation, termination migrations
- Fix type errors in HRM pages
- E2E testing for HRM module

### Integration Status
**Merge Conflicts:** 0
**Resolved Issues:** 23
**Open Issues:** 7
**Test Coverage:** 65%

### Overall Progress
**HRM Module:** 60% complete
**On Track:** Yes (1 week behind schedule)
```

---

## 🎯 SUCCESS METRICS

### Phase Completion Criteria

**HRM Module Complete When:**
- [ ] All REST endpoints implemented and tested
- [ ] All frontend pages migrated to REST
- [ ] Zero Socket.IO emits in HRM pages
- [ ] Test coverage > 80%
- [ ] Performance benchmarks met
- [ ] Documentation complete
- [ ] No known critical bugs
- [ ] Code review complete

**Project Management Module Complete When:**
- [ ] All REST endpoints implemented and tested
- [ ] All frontend pages migrated to REST
- [ ] Zero Socket.IO emits in PM pages
- [ ] Test coverage > 80%
- [ ] Performance benchmarks met
- [ ] Documentation complete
- [ ] No known critical bugs
- [ ] Code review complete

**CRM Module Complete When:**
- [ ] All REST endpoints implemented and tested
- [ ] All frontend pages migrated to REST
- [ ] Zero Socket.IO emits in CRM pages
- [ ] Test coverage > 80%
- [ ] Performance benchmarks met
- [ ] Documentation complete
- [ ] No known critical bugs
- [ ] Code review complete

---

## 📞 COMMUNICATION CHANNELS

### Slack Channels
- **#dev-coordination** - Daily standups, coordination
- **#code-reviews** - PR notifications, reviews
- **#backend-dev** - Backend-specific discussions
- **#frontend-dev** - Frontend-specific discussions
- **#help** - Ask for help when blocked
- **#announcements** - Important updates

### Meetings
- **Daily Standup** - 15 minutes, 10:00 AM
  - What did you complete yesterday?
  - What will you work on today?
  - Any blockers?

- **Weekly Planning** - 30 minutes, Monday 10:30 AM
  - Review previous week progress
  - Plan this week's tasks
  - Identify dependencies

- **Bi-weekly Demo** - 1 hour, Fridays 3:00 PM
  - Demo completed features
  - Gather feedback
  - Adjust plan if needed

---

## 🚦 GETTING STARTED

### Day 1 Setup

**Developer 1 (Backend):**
```bash
# 1. Clone and setup
git clone <repo-url>
cd hrms-tool-amasqis

# 2. Install dependencies
cd backend
npm install

# 3. Add Joi dependency
npm install joi

# 4. Create feature branch
git checkout develop
git checkout -b feature/hrm-backend

# 5. Start development server
npm run dev
```

**Developer 2 (Frontend):**
```bash
# 1. Clone and setup
git clone <repo-url>
cd hrms-tool-amasqis

# 2. Install dependencies
cd react
npm install

# 3. Create feature branch
git checkout develop
git checkout -b feature/hrm-frontend

# 4. Start development server
npm start
```

### First Week Tasks

**Developer 1 (Backend):**
- [ ] Fix critical security issues (see Critical Issues Report)
- [ ] Complete employee schema
- [ ] Complete payroll schema
- [ ] Create missing HRM controllers
- [ ] Add database indexes
- [ ] Write unit tests for HRM endpoints

**Developer 2 (Frontend):**
- [ ] Fix critical security issues (see Critical Issues Report)
- [ ] Add error boundaries
- [ ] Migrate HRM pages to REST (promotion, resignation, termination)
- [ ] Create missing HRM hooks
- [ ] Fix type errors in HRM pages
- [ ] Write tests for HRM components

---

## 📚 DOCUMENTATION

### Required Reading for Both Developers
1. [CRITICAL_ISSUES_REPORT.md](.ferb/docs/docs_output/25_CRITICAL_ISSUES_REPORT.md) - **READ FIRST**
2. [24_LINTING_CODE_QUALITY_GUIDE.md](.ferb/docs/docs_output/24_LINTING_CODE_QUALITY_GUIDE.md)
3. This document (Parallel Development Setup)

### Module-Specific Documentation
- HRM: `.ferb/docs/docs_output/26_HRM_MODULE_REPORT.md` (to be created)
- Project Management: `.ferb/docs/docs_output/27_PM_MODULE_REPORT.md` (to be created)
- CRM: `.ferb/docs/docs_output/28_CRM_MODULE_REPORT.md` (to be created)

---

## 🆘 ESCALATION PATH

### If You Encounter a Blocker

**Level 1: Self-Resolve (15 minutes)**
- Try to solve yourself
- Check documentation
- Search for similar solutions

**Level 2: Peer Support (30 minutes)**
- Ask in Slack #help channel
- Pair program with other developer

**Level 3: Tech Lead (1 hour)**
- If still blocked after peer support
- Escalate to Technical Lead
- Schedule call if needed

**Level 4: Emergency (Immediate)**
- Production issue
- Security vulnerability
- Data loss risk
- Contact Tech Lead immediately via phone

---

**Document Owner:** Technical Lead
**Last Updated:** January 29, 2026
**Next Review:** After HRM module completion
**Version:** 1.0
