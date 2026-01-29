# Project Management Module - Issues & Technical Debt

**Module:** Project Management
**Assigned To:** Developer 2
**Last Updated:** January 29, 2026

---

## 🔴 CRITICAL ISSUES (Must Fix Before Development)

### Issue #1: Missing Resource Management API
**Severity:** 🔴 CRITICAL
**Location:** Backend
**Impact:** Cannot allocate resources to projects, blocks core PM functionality

**Description:**
- Resource REST controller doesn't exist
- No resource allocation tracking
- No resource utilization calculations
- Cannot check resource availability

**Fix Required:**
```bash
# Create controller
backend/controllers/rest/resource.controller.js

# Create route
backend/routes/api/resources.js

# Create service
backend/services/projects/resource.service.js

# Create hook
react/src/hooks/useResourcesREST.ts
```

**Endpoints Needed:**
- GET /api/resources - List all resources
- POST /api/resources - Create resource
- PUT /api/resources/:id - Update resource
- DELETE /api/resources/:id - Delete resource
- GET /api/resources/available - Get available resources
- POST /api/resources/allocate - Allocate to project
- PUT /api/resources/:id/deallocate - Deallocate
- GET /api/resources/utilization - Get utilization
- GET /api/resources/:id/assignments - Get assignments

**Estimated Time:** 12 hours
**Assigned To:** Developer 2
**Priority:** BLOCKING

---

### Issue #2: Missing Budget Management API
**Severity:** 🔴 CRITICAL
**Location:** Backend
**Impact:** Cannot track project budgets, blocks financial reporting

**Description:**
- Budget REST controller doesn't exist
- No budget tracking
- No budget vs actual comparison
- Cannot approve budgets

**Fix Required:**
```bash
# Create controller
backend/controllers/rest/budget.controller.js

# Create route
backend/routes/api/budgets.js

# Create service
backend/services/projects/budget.service.js

# Create hook
react/src/hooks/useBudgetsREST.ts
```

**Endpoints Needed:**
- GET /api/budgets - List all budgets
- GET /api/budgets/:id - Get budget by ID
- GET /api/budgets/project/:id - Get project budget
- POST /api/budgets - Create budget
- PUT /api/budgets/:id - Update budget
- DELETE /api/budgets/:id - Delete budget
- GET /api/budgets/:id/tracking - Get budget tracking
- POST /api/budgets/:id/approve - Approve budget

**Estimated Time:** 10 hours
**Assigned To:** Developer 2
**Priority:** BLOCKING

---

### Issue #3: Missing Time Tracking API
**Severity:** 🔴 CRITICAL
**Location:** Backend
**Impact:** Cannot track time spent on tasks, blocks billing

**Description:**
- Time tracking REST controller doesn't exist
- No timesheet management
- Cannot track billable hours
- No time approval workflow

**Fix Required:**
```bash
# Create controller
backend/controllers/rest/timeTracking.controller.js

# Create route
backend/routes/api/timetracking.js

# Create service
backend/services/projects/timeTracking.service.js

# Create hook
react/src/hooks/useTimeTrackingREST.ts
```

**Endpoints Needed:**
- GET /api/timetracking - List time entries
- POST /api/timetracking - Create time entry
- PUT /api/timetracking/:id - Update time entry
- DELETE /api/timetracking/:id - Delete time entry
- GET /api/timetracking/user/:id - Get user's time
- GET /api/timetracking/project/:id - Get project time
- GET /api/timetracking/timesheet/:userId - Get timesheet
- POST /api/timetracking/submit - Submit timesheet
- POST /api/timetracking/approve - Approve timesheet
- GET /api/timetracking/stats - Time tracking stats

**Estimated Time:** 14 hours
**Assigned To:** Developer 2
**Priority:** BLOCKING

---

## 🟠 HIGH PRIORITY ISSUES

### Issue #4: Missing Milestone Management
**Severity:** 🟠 HIGH
**Location:** Backend
**Impact:** Cannot track project milestones

**Fix Required:**
```bash
# Create controller
backend/controllers/rest/milestone.controller.js

# Create route
backend/routes/api/milestones.js

# Create hook
react/src/hooks/useMilestonesREST.ts
```

**Estimated Time:** 6 hours

---

### Issue #5: No Project Timeline View
**Severity:** 🟠 HIGH
**Location:** Frontend
**Impact:** Cannot visualize project progress

**Fix Required:**
Create Gantt chart or timeline component using library like:
- react-gantt-chart
- @dhtmlx/trial
- timeline-react

**Estimated Time:** 12 hours

---

### Issue #6: No Resource Conflict Detection
**Severity:** 🟠 HIGH
**Location:** Backend
**Impact:** Can double-book resources

**Fix Required:**
Add conflict detection logic:
```javascript
// In resource.service.js
const checkResourceConflict = async (resourceId, startDate, endDate) => {
  const existing = await ResourceAllocation.find({
    resourceId,
    $or: [
      { startDate: { $lte: endDate }, endDate: { $gte: startDate } }
    ]
  });
  return existing.length > 0;
};
```

**Estimated Time:** 4 hours

---

## 🟡 MEDIUM PRIORITY ISSUES

### Issue #7: No Project Templates
**Severity:** 🟡 MEDIUM
**Location:** Frontend & Backend
**Impact:** Must recreate project from scratch each time

**Fix Required:**
- Create project template schema
- Add template CRUD operations
- Add "Create from Template" feature

**Estimated Time:** 8 hours

---

### Issue #8: Limited Project Analytics
**Severity:** 🟡 MEDIUM
**Location:** Frontend
**Impact:** Poor project insights

**Missing Features:**
- Burndown charts
- Velocity tracking
- Sprint completion rate
- Resource utilization charts

**Fix Required:**
Create analytics dashboard with charts using:
- Recharts
- ApexCharts
- Chart.js

**Estimated Time:** 12 hours

---

### Issue #9: No Project Cloning
**Severity:** 🟡 MEDIUM
**Location:** Backend
**Impact:** Cannot duplicate similar projects

**Fix Required:**
Add project cloning endpoint:
```javascript
POST /api/projects/:id/clone
```

**Estimated Time:** 4 hours

---

### Issue #10: No Task Dependencies
**Severity:** 🟡 MEDIUM
**Location:** Backend
**Impact:** Cannot define task dependencies

**Fix Required:**
Add task dependencies schema:
```javascript
dependencies: [{
  taskId: ObjectId,
  type: { type: String, enum: ['finish-to-start', 'start-to-start', 'finish-to-finish'] }
}]
```

**Estimated Time:** 6 hours

---

## 🟢 LOW PRIORITY / TECHNICAL DEBT

### Issue #11: TODO Comments in Code
**Severity:** 🟢 LOW
**Count:** 18 TODO comments in PM module

**Examples:**
```javascript
// TODO: Add resource conflict detection
// TODO: Implement project cloning
// TODO: Add Gantt chart view
```

**Action:** Convert to GitHub issues or complete them

**Estimated Time:** 2 hours

---

### Issue #12: No Project Archival Workflow
**Severity:** 🟢 LOW
**Location:** Frontend
**Impact:** Old projects clutter the UI

**Fix Required:**
- Add archive endpoint
- Add archived projects filter
- Add restore functionality

**Estimated Time:** 4 hours

---

### Issue #13: No Project Team Management
**Severity:** 🟢 LOW
**Location:** Backend
**Impact:** Cannot manage project teams

**Fix Required:**
Add team management:
- Add/remove team members
- Team roles within project
- Team permissions

**Estimated Time:** 6 hours

---

### Issue #14: No Unit Tests for PM Components
**Severity:** 🟢 LOW
**Impact:** No regression testing

**Current Test Coverage:** 0%

**Target Test Coverage:** 80%

**Estimated Time:** 32 hours

---

## 📋 ISSUES SUMMARY

| Severity | Count | Estimated Time | Status |
|----------|-------|----------------|--------|
| 🔴 Critical | 3 | 36 hours | Not Started |
| 🟠 High | 3 | 22 hours | Not Started |
| 🟡 Medium | 4 | 30 hours | Not Started |
| 🟢 Low | 4 | 44 hours | Not Started |
| **Total** | **14** | **132 hours** | |

---

## 🎯 ISSUE RESOLUTION PLAN

### Week 1: Critical Issues
- [ ] Create Resource Management API (Issue #1) - 12 hours
- [ ] Create Budget Management API (Issue #2) - 10 hours
- [ ] Create Time Tracking API (Issue #3) - 14 hours

### Week 2: High Priority Issues
- [ ] Create Milestone Management (Issue #4) - 6 hours
- [ ] Add Project Timeline View (Issue #5) - 12 hours
- [ ] Add Resource Conflict Detection (Issue #6) - 4 hours

### Week 3-4: Medium & Low Priority
- [ ] Add Project Templates (Issue #7) - 8 hours
- [ ] Enhance Project Analytics (Issue #8) - 12 hours
- [ ] Add Project Cloning (Issue #9) - 4 hours
- [ ] Add Task Dependencies (Issue #10) - 6 hours

---

## 📝 ISSUE TRACKING

All issues should be tracked in GitHub with these labels:
- `priority:critical` - Must fix immediately
- `priority:high` - Must fix this week
- `priority:medium` - Fix this sprint
- `priority:low` - Technical debt
- `module:project-management` - PM module issues

---

**Next Action:** Start with Issue #1 (Resource Management API)
**Owner:** Developer 2
**Review Date:** Weekly during standup
