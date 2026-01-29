# Developer Assignments & Module Ownership

## Overview

This document defines the exact file ownership for parallel development, ensuring clear separation of concerns and preventing merge conflicts.

---

## DEVELOPER 1: HRM MODULE

### Primary Responsibilities
- Employee Management (CRUD operations)
- Employee Designations & Promotions
- Resignation & Termination Workflows
- Holiday Management
- HR Analytics & Reports

### Frontend Files Assigned (13 files)

#### Employee Management
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [employeesList.tsx](react/src/feature-module/hrm/employees/employeesList.tsx) | 19 emit, 10 on | HIGH | useEmployeesREST ✅ |
| [employeesGrid.tsx](react/src/feature-module/hrm/employees/employeesGrid.tsx) | 13 emit, 7 on | HIGH | useEmployeesREST ✅ |
| [employeedetails.tsx](react/src/feature-module/hrm/employees/employeedetails.tsx) | 28 emit, 17 on | HIGH | useEmployeesREST ✅ |
| [createemployee.tsx](react/src/feature-module/hrm/employees/createemployee.tsx) | 15 emit, 8 on | MEDIUM | useEmployeesREST ✅ |
| [updateemployee.tsx](react/src/feature-module/hrm/employees/updateemployee.tsx) | 12 emit, 6 on | MEDIUM | useEmployeesREST ✅ |

#### Designations
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [designations.tsx](react/src/feature-module/hrm/designation/designations.tsx) | 12 emit, 7 on | MEDIUM | useDesignationsREST ❌ |
| [designationDepartment.tsx](react/src/feature-module/hrm/designation/designationDepartment.tsx) | 8 emit, 4 on | LOW | useDesignationsREST ❌ |

#### Promotions
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [promotion.tsx](react/src/feature-module/hrm/promotion/promotion.tsx) | 12 emit, 12 on | MEDIUM | usePromotionsREST ❌ |
| [promotionGrid.tsx](react/src/feature-module/hrm/promotion/promotionGrid.tsx) | 6 emit, 6 on | LOW | usePromotionsREST ❌ |

#### Resignation & Termination
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [resignation.tsx](react/src/feature-module/hrm/resignation/resignation.tsx) | 18 emit, 9 on | HIGH | useResignationsREST ❌ |
| [resignationGrid.tsx](react/src/feature-module/hrm/resignation/resignationGrid.tsx) | 8 emit, 4 on | MEDIUM | useResignationsREST ❌ |
| [termination.tsx](react/src/feature-module/hrm/termination/termination.tsx) | 18 emit, 9 on | HIGH | useTerminationsREST ❌ |
| [terminationGrid.tsx](react/src/feature-module/hrm/termination/terminationGrid.tsx) | 8 emit, 4 on | MEDIUM | useTerminationsREST ❌ |

#### Holidays
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [holidays.tsx](react/src/feature-module/hrm/holidays/holidays.tsx) | 16 emit, 9 on | MEDIUM | useHolidaysREST ❌ |

### Backend Files Assigned

#### REST API Routes
| File | Endpoints | Status |
|------|-----------|--------|
| [employees.routes.js](backend/routes/api/employees.routes.js) | 15 endpoints | ✅ Complete |
| [designations.routes.js](backend/routes/api/designations.routes.js) | 8 endpoints | ✅ Complete |
| [promotions.routes.js](backend/routes/api/promotions.routes.js) | 6 endpoints | ❌ Missing |
| [resignations.routes.js](backend/routes/api/resignations.routes.js) | 8 endpoints | ❌ Missing |
| [terminations.routes.js](backend/routes/api/terminations.routes.js) | 8 endpoints | ❌ Missing |
| [holidays.routes.js](backend/routes/api/holidays.routes.js) | 8 endpoints | ❌ Missing |

#### Controllers
| File | Status |
|------|--------|
| [employee.controller.js](backend/controllers/employee/employee.controller.js) | ✅ Complete |
| [designation.controller.js](backend/controllers/designation/designation.controller.js) | ✅ Complete |
| [promotion.controller.js](backend/controllers/promotion/promotion.controller.js) | ❌ Missing |
| [resignation.controller.js](backend/controllers/resignation/resignation.controller.js) | ❌ Missing |
| [termination.controller.js](backend/controllers/termination/termination.controller.js) | ❌ Missing |
| [holiday.controller.js](backend/controllers/holiday/holiday.controller.js) | ❌ Missing |

#### Services
| File | Status |
|------|--------|
| [hrm.employee.js](backend/services/hr/hrm.employee.js) | ✅ Complete |
| [hrm.designation.js](backend/services/hr/hrm.designation.js) | ✅ Complete |
| [hrm.promotion.js](backend/services/hr/hrm.promotion.js) | ❌ Missing |
| [hrm.resignation.js](backend/services/hr/hrm.resignation.js) | ❌ Missing |
| [hrm.termination.js](backend/services/hr/hrm.termination.js) | ❌ Missing |
| [hrm.holiday.js](backend/services/hr/hrm.holiday.js) | ❌ Missing |

### REST Hooks Created
| Hook | File | Status |
|------|------|--------|
| useEmployeesREST | [react/src/hooks/useEmployeesREST.ts](react/src/hooks/useEmployeesREST.ts) | ✅ Complete |
| useDesignationsREST | [react/src/hooks/useDesignationsREST.ts](react/src/hooks/useDesignationsREST.ts) | ✅ Complete |
| usePromotionsREST | [react/src/hooks/usePromotionsREST.ts](react/src/hooks/usePromotionsREST.ts) | ❌ Missing |
| useResignationsREST | [react/src/hooks/useResignationsREST.ts](react/src/hooks/useResignationsREST.ts) | ❌ Missing |
| useTerminationsREST | [react/src/hooks/useTerminationsREST.ts](react/src/hooks/useTerminationsREST.ts) | ❌ Missing |
| useHolidaysREST | [react/src/hooks/useHolidaysREST.ts](react/src/hooks/useHolidaysREST.ts) | ❌ Missing |

---

## DEVELOPER 2: PROJECT MANAGEMENT MODULE

### Primary Responsibilities
- Project Management (CRUD operations)
- Resource Allocation & Management
- Budget Tracking & Management
- Time Tracking
- Project Analytics & Reports

### Frontend Files Assigned (8 files)

#### Project Management
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [project.tsx](react/src/feature-module/projects/project/project.tsx) | 22 emit, 14 on | HIGH | useProjectsREST ✅ |
| [projectGrid.tsx](react/src/feature-module/projects/project/projectGrid.tsx) | 10 emit, 8 on | HIGH | useProjectsREST ✅ |
| [projectdetails.tsx](react/src/feature-module/projects/project/projectdetails.tsx) | 18 emit, 12 on | HIGH | useProjectsREST ✅ |
| [createproject.tsx](react/src/feature-module/projects/project/createproject.tsx) | 12 emit, 8 on | MEDIUM | useProjectsREST ✅ |

#### Resource Management
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [resources.tsx](react/src/feature-module/projects/resources/resources.tsx) | 14 emit, 10 on | HIGH | useResourcesREST ❌ |
| [resourceAllocation.tsx](react/src/feature-module/projects/resources/resourceAllocation.tsx) | 16 emit, 12 on | HIGH | useResourcesREST ❌ |

#### Budget Management
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [budgets.tsx](react/src/feature-module/projects/budgets/budgets.tsx) | 12 emit, 8 on | MEDIUM | useBudgetsREST ❌ |

#### Time Tracking
| File | Socket Calls | Priority | REST Hook Needed |
|------|--------------|----------|------------------|
| [timeTracking.tsx](react/src/feature-module/projects/timeTracking/timeTracking.tsx) | 20 emit, 14 on | HIGH | useTimeTrackingREST ❌ |

### Backend Files Assigned

#### REST API Routes
| File | Endpoints | Status |
|------|-----------|--------|
| [projects.routes.js](backend/routes/api/projects.routes.js) | 12 endpoints | ✅ Complete |
| [resources.routes.js](backend/routes/api/resources.routes.js) | 10 endpoints | ❌ Missing |
| [budgets.routes.js](backend/routes/api/budgets.routes.js) | 8 endpoints | ❌ Missing |
| [timeTracking.routes.js](backend/routes/api/timeTracking.routes.js) | 12 endpoints | ❌ Missing |

#### Controllers
| File | Status |
|------|--------|
| [project.controller.js](backend/controllers/project/project.controller.js) | ✅ Complete |
| [resource.controller.js](backend/controllers/resource/resource.controller.js) | ❌ Missing |
| [budget.controller.js](backend/controllers/budget/budget.controller.js) | ❌ Missing |
| [timeTracking.controller.js](backend/controllers/timeTracking/timeTracking.controller.js) | ❌ Missing |

#### Services
| File | Status |
|------|--------|
| [project.service.js](backend/services/projects/project.service.js) | ✅ Complete |
| [resource.service.js](backend/services/projects/resource.service.js) | ❌ Missing |
| [budget.service.js](backend/services/projects/budget.service.js) | ❌ Missing |
| [timeTracking.service.js](backend/services/projects/timeTracking.service.js) | ❌ Missing |

### REST Hooks Created
| Hook | File | Status |
|------|------|--------|
| useProjectsREST | [react/src/hooks/useProjectsREST.ts](react/src/hooks/useProjectsREST.ts) | ✅ Complete |
| useResourcesREST | [react/src/hooks/useResourcesREST.ts](react/src/hooks/useResourcesREST.ts) | ❌ Missing |
| useBudgetsREST | [react/src/hooks/useBudgetsREST.ts](react/src/hooks/useBudgetsREST.ts) | ❌ Missing |
| useTimeTrackingREST | [react/src/hooks/useTimeTrackingREST.ts](react/src/hooks/useTimeTrackingREST.ts) | ❌ Missing |

---

## SHARED RESPONSIBILITIES (Both Developers)

### Files Requiring Coordination
**DO NOT EDIT WITHOUT NOTIFYING THE OTHER DEVELOPER:**

#### Core Infrastructure
- [react/src/SocketContext.tsx](react/src/SocketContext.tsx)
- [react/src/services/api.ts](react/src/services/api.ts)
- [backend/config/db.js](backend/config/db.js)
- [backend/socket/index.js](backend/socket/index.js)
- [backend/server.js](backend/server.js)
- [package.json](package.json) (root, backend, react)

#### Shared Hooks
- [react/src/hooks/useApi.ts](react/src/hooks/useApi.ts)
- [react/src/hooks/useActivitiesREST.ts](react/src/hooks/useActivitiesREST.ts)

#### Shared Components
- [react/src/core/modals/](react/src/core/modals/) directory
- [react/src/core/data/redux/](react/src/core/data/redux/) directory

### Coordination Protocol
1. Create a **draft PR** before editing shared files
2. **Tag the other developer** in the PR
3. **Wait for approval** before proceeding
4. **Sync changes** within the same day

---

## COMPLETION TRACKING

### Developer 1 (HRM Module) Progress

#### Phase 1: Foundation (Week 1)
- [x] useEmployeesREST hook created
- [x] useDesignationsREST hook created
- [x] Employees REST API complete (15 endpoints)
- [x] Designations REST API complete (8 endpoints)

#### Phase 2: Frontend Migration (Week 2-3)
- [ ] employeesList.tsx → REST
- [ ] employeesGrid.tsx → REST
- [ ] employeedetails.tsx → REST
- [ ] designations.tsx → REST
- [ ] promotions.tsx → REST

#### Phase 3: Advanced Features (Week 4-5)
- [ ] Resignation REST API + hooks
- [ ] Termination REST API + hooks
- [ ] Holidays REST API + hooks
- [ ] Frontend migration for all HRM files

#### Phase 4: Testing & Documentation (Week 6)
- [ ] Unit tests for all HRM endpoints
- [ ] Integration tests for HRM workflows
- [ ] API documentation updated
- [ ] Test coverage > 80%

### Developer 2 (Project Management Module) Progress

#### Phase 1: Foundation (Week 1)
- [x] useProjectsREST hook created
- [ ] Projects REST API complete (12 endpoints)

#### Phase 2: Resource Management (Week 2-3)
- [ ] Resource allocation REST API
- [ ] useResourcesREST hook
- [ ] resources.tsx → REST
- [ ] resourceAllocation.tsx → REST

#### Phase 3: Budget & Time Tracking (Week 4-5)
- [ ] Budget tracking REST API
- [ ] Time tracking REST API
- [ ] useBudgetsREST hook
- [ ] useTimeTrackingREST hook
- [ ] Frontend migration for all PM files

#### Phase 4: Testing & Documentation (Week 6)
- [ ] Unit tests for all PM endpoints
- [ ] Integration tests for PM workflows
- [ ] API documentation updated
- [ ] Test coverage > 80%

---

## WORKFLOW COMMANDS

### Developer 1 Commands
```bash
# Setup workspace
.\scripts\setup-dev-workspace.ps1 -DeveloperId dev1

# Create new feature branch
git hrm-branch <feature-name>

# Create pull request
git hrm-pr "Migrate employeesList to REST"
```

### Developer 2 Commands
```bash
# Setup workspace
.\scripts\setup-dev-workspace.ps1 -DeveloperId dev2

# Create new feature branch
git pm-branch <feature-name>

# Create pull request
git pm-pr "Migrate projectList to REST"
```

---

## ESCALATION MATRIX

| Issue Type | Response Time | Escalation Path |
|------------|---------------|-----------------|
| Feature Block | 2 hours | Slack mention |
| Merge Conflict | 4 hours | Quick sync call |
| API Design | 1 day | Tech Lead review |
| Critical Bug | Immediate | Both devs + Tech Lead |

---

**Last Updated:** January 29, 2026
**Next Review:** Weekly during standup
