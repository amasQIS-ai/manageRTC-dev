# HRM Module - Implementation Plan

**Module:** Human Resource Management
**Assigned To:** Developer 1
**Duration:** 6 weeks
**Last Updated:** January 29, 2026

---

## 📅 OVERALL TIMELINE

| Week | Focus | Deliverables | Time Est. |
|------|-------|--------------|-----------|
| **Week 1** | Foundation & Critical Fixes | Payroll API, Schema fixes | 40 hrs |
| **Week 2** | Employee Management | Employee pages migration | 40 hrs |
| **Week 3** | HR Workflows | Resignation, Termination, Designation | 40 hrs |
| **Week 4** | Attendance & Leave | Attendance/Leave pages | 40 hrs |
| **Week 5** | Payroll & Reports | Payroll pages, Reports | 40 hrs |
| **Week 6** | Testing & Documentation | Tests, Docs, Bug fixes | 40 hrs |

**Total Estimated Time:** 240 hours (6 weeks)

---

## 🎯 WEEK 1: FOUNDATION & CRITICAL FIXES

### Day 1-2: Critical Issues

#### Morning (Day 1)
- [x] **Security fixes** (completed)
  - [x] Install Joi dependency
  - [x] Move Clerk key to .env
  - [x] Add security warnings

#### Afternoon (Day 1)
- [ ] **Create Payroll REST Controller**
  ```
  Files to create:
  - backend/controllers/rest/payroll.controller.js
  - backend/routes/api/payrolls.js
  - react/src/hooks/usePayrollREST.ts

  Endpoints needed:
  - POST /api/payrolls/generate - Generate payroll for period
  - GET /api/payrolls - List all payrolls
  - GET /api/payrolls/:id - Get payroll by ID
  - GET /api/payrolls/employee/:id - Get employee payroll history
  - PUT /api/payrolls/:id - Update payroll
  - DELETE /api/payrolls/:id - Delete payroll
  - POST /api/payrolls/:id/approve - Approve payroll
  - POST /api/payslips/generate - Generate payslip
  - GET /api/payslips/:payrollId/:employeeId - Get payslip
  - GET /api/payrolls/stats - Payroll statistics
  ```

**Estimated Time:** 12 hours

### Day 3-4: Schema Fixes

#### Complete Employee Schema
```javascript
// backend/models/employee/employee.schema.js
// Add missing fields:
- employeeCode: { type: String, unique: true, required: true }
- workEmail: { type: String, lowercase: true, trim: true }
- personalEmail: { type: String, lowercase: true, trim: true }
- emergencyContact: {
    name: String,
    relationship: String,
    phone: String,
    address: String
  }
- bankDetails: {
    bankName: String,
    accountNumber: String,
    ifscCode: String,
    bankBranch: String
  }
```

#### Create Attendance Schema
```javascript
// backend/models/attendance/attendance.schema.js
const attendanceSchema = new Schema({
  employeeId: { type: ObjectId, required: true, ref: 'Employee' },
  date: { type: Date, required: true },
  checkIn: { type: Date },
  checkOut: { type: Date },
  workHours: { type: Number, default: 0 },
  status: {
    type: String,
    enum: ['present', 'absent', 'half-day', 'leave', 'holiday'],
    default: 'present'
  },
  leaveType: { type: String },
  notes: { type: String },
  companyId: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});
```

**Estimated Time:** 7 hours

### Day 5: Testing & Setup
- [ ] Set up Jest for HRM tests
- [ ] Create test fixtures
- [ ] Write first batch of unit tests

**Estimated Time:** 8 hours

---

## 🎯 WEEK 2: EMPLOYEE MANAGEMENT

### Day 6-7: employeesList.tsx
**File:** [react/src/feature-module/hrm/employees/employeesList.tsx](../../../../../react/src/feature-module/hrm/employees/employeesList.tsx)
**Socket Calls:** 19 emit, 10 on
**Priority:** HIGH

**Migration Steps:**
1. Import `useEmployeesREST` hook
2. Replace `socket.emit` with REST API calls
3. Remove `socket.on` listeners (keep for real-time updates)
4. Test all CRUD operations
5. Add error handling
6. Add loading states

**Before:**
```typescript
socket.emit('get_employees', { companyId });
socket.on('employees_data', (data) => { setEmployees(data); });
```

**After:**
```typescript
const { fetchEmployees, employees, loading } = useEmployeesREST();
useEffect(() => { fetchEmployees(); }, []);
```

**Estimated Time:** 4 hours

### Day 8-9: employeesGrid.tsx
**File:** [react/src/feature-module/hrm/employees/employeesGrid.tsx](../../../../../react/src/feature-module/hrm/employees/employeesGrid.tsx)
**Socket Calls:** 13 emit, 7 on
**Priority:** HIGH

**Migration Steps:**
1. Import `useEmployeesREST` hook
2. Replace grid data fetching with REST
3. Implement pagination
4. Add sorting
5. Add filters

**Estimated Time:** 3 hours

### Day 10: employeedetails.tsx
**File:** [react/src/feature-module/hrm/employees/employeedetails.tsx](../../../../../react/src/feature-module/hrm/employees/employeedetails.tsx)
**Socket Calls:** 28 emit, 17 on
**Priority:** HIGH

**Migration Steps:**
1. Import `useEmployeesREST` hook
2. Replace all socket calls
3. Add employee history tab
4. Add documents tab
5. Add performance tab

**Estimated Time:** 6 hours

### Day 11-12: createemployee.tsx & updateemployee.tsx
**Files:**
- [react/src/feature-module/hrm/employees/createemployee.tsx](../../../../../react/src/feature-module/hrm/employees/createemployee.tsx)
- [react/src/feature-module/hrm/employees/updateemployee.tsx](../../../../../react/src/feature-module/hrm/employees/updateemployee.tsx)

**Migration Steps:**
1. Replace form submission with REST
2. Add form validation
3. Add file upload for documents
4. Add duplicate checking

**Estimated Time:** 6 hours

### Day 13: Testing Employee Module
- [ ] Test all employee CRUD operations
- [ ] Test search and filters
- [ ] Test pagination
- [ ] Fix bugs

**Estimated Time:** 8 hours

---

## 🎯 WEEK 3: HR WORKFLOWS

### Day 14-15: resignation.tsx
**File:** [react/src/feature-module/hrm/resignation/resignation.tsx](../../../../../react/src/feature-module/hrm/resignation/resignation.tsx)
**Socket Calls:** 18 emit, 9 on
**Priority:** HIGH

**REST Hook:** `useResignationsREST` ✅ Created

**Migration Steps:**
1. Import `useResignationsREST` hook
2. Replace resignation CRUD with REST
3. Implement approve/reject workflow
4. Add employee status updates
5. Add notice period tracking

**Estimated Time:** 4 hours

### Day 16: termination.tsx
**File:** [react/src/feature-module/hrm/termination/termination.tsx](../../../../../react/src/feature-module/hrm/termination/termination.tsx)
**Socket Calls:** 18 emit, 9 on
**Priority:** HIGH

**REST Hook:** `useTerminationsREST` ✅ Created

**Migration Steps:**
1. Import `useTerminationsREST` hook
2. Replace termination CRUD with REST
3. Implement process/cancel workflow
4. Add employee status updates
5. Add exit interview tracking

**Estimated Time:** 4 hours

### Day 17-18: designations.tsx
**File:** [react/src/feature-module/hrm/designation/designations.tsx](../../../../../react/src/feature-module/hrm/designation/designations.tsx)
**Socket Calls:** 12 emit, 7 on
**Priority:** MEDIUM

**REST Hook:** `useDesignationsREST` ✅ Created

**Migration Steps:**
1. Import `useDesignationsREST` hook
2. Replace designation CRUD with REST
3. Add employee count display
4. Add department filtering

**Estimated Time:** 3 hours

### Day 19: promotion.tsx
**File:** [react/src/feature-module/hrm/promotion/promotion.tsx](../../../../../react/src/feature-module/hrm/promotion/promotion.tsx)
**Socket Calls:** 12 emit, 12 on
**Priority:** MEDIUM

**REST Hook:** `usePromotionsREST` ✅ Created

**Migration Steps:**
1. Import `usePromotionsREST` hook
2. Replace promotion CRUD with REST
3. Implement apply/cancel workflow
4. Add employee updates
5. Add approval workflow

**Estimated Time:** 4 hours

### Day 20: holidays.tsx
**File:** [react/src/feature-module/hrm/holidays/holidays.tsx](../../../../../react/src/feature-module/hrm/holidays/holidays.tsx)
**Socket Calls:** 16 emit, 9 on
**Priority:** MEDIUM

**REST Hook:** `useHolidaysREST` ✅ Created

**Migration Steps:**
1. Import `useHolidaysREST` hook
2. Replace holiday CRUD with REST
3. Add year filtering
4. Add upcoming holidays view
5. Add repeat yearly feature

**Estimated Time:** 3 hours

---

## 🎯 WEEK 4: ATTENDANCE & LEAVE

### Day 21-22: attendance.tsx
**File:** [react/src/feature-module/hrm/attendance/attendance.tsx](../../../../../react/src/feature-module/hrm/attendance/attendance.tsx)
**Socket Calls:** 14 emit, 8 on
**Priority:** MEDIUM

**Migration Steps:**
1. Import `useAttendanceREST` hook
2. Replace attendance CRUD with REST
3. Add check-in/check-out UI
4. Add monthly view
5. Add attendance reports

**Estimated Time:** 3 hours

### Day 23-25: leave.tsx & Related
**Files:**
- [react/src/feature-module/hrm/leave/leave.tsx](../../../../../react/src/feature-module/hrm/leave/leave.tsx)
- [react/src/feature-module/hrm/leave/leaveRequests.tsx](../../../../../react/src/feature-module/hrm/leave/leaveRequests.tsx)
- [react/src/feature-module/hrm/leave/leaveBalance.tsx](../../../../../react/src/feature-module/hrm/leave/leaveBalance.tsx)
- [react/src/feature-module/hrm/leave/leaveTypes.tsx](../../../../../react/src/feature-module/hrm/leave/leaveTypes.tsx)

**Socket Calls:** 44 emit, 25 on
**Priority:** MEDIUM

**Migration Steps:**
1. Import `useLeaveREST` hook
2. Replace leave CRUD with REST
3. Implement approval workflow
4. Add leave balance calculation
5. Add leave types management
6. Add leave calendar view

**Estimated Time:** 12 hours

### Day 26-27: Leave Settings & Configuration
- [ ] Configure leave rules
- [ ] Set up leave accrual
- [ ] Configure carry-forward rules
- [ ] Test leave workflows

**Estimated Time:** 8 hours

---

## 🎯 WEEK 5: PAYROLL & REPORTS

### Day 28-30: payroll.tsx
**File:** [react/src/feature-module/hrm/payroll/payroll.tsx](../../../../../react/src/feature-module/hrm/payroll/payroll.tsx)
**Socket Calls:** 22 emit, 14 on
**Priority:** HIGH

**Migration Steps:**
1. Import `usePayrollREST` hook (needs to be created)
2. Replace payroll CRUD with REST
3. Implement payroll generation
4. Add salary calculation
5. Add tax calculations
6. Add deduction management

**Estimated Time:** 6 hours

### Day 31-32: payslips.tsx
**File:** [react/src/feature-module/hrm/payroll/payslips.tsx](../../../../../react/src/feature-module/hrm/payroll/payslips.tsx)
**Socket Calls:** 14 emit, 8 on
**Priority:** MEDIUM

**Migration Steps:**
1. Import `usePayrollREST` hook
2. Replace payslip operations with REST
3. Add PDF generation
4. Add email payslip feature
5. Add payslip history

**Estimated Time:** 4 hours

### Day 33-35: HR Dashboard & Analytics
**Files:**
- [react/src/feature-module/hrm/hrDashboard/hrDashboard.tsx](../../../../../react/src/feature-module/hrm/hrDashboard/hrDashboard.tsx)
- [react/src/feature-module/hrm/hrDashboard/hrAnalytics.tsx](../../../../../react/src/feature-module/hrm/hrDashboard/hrAnalytics.tsx)
- [react/src/feature-module/hrm/hrDashboard/hrReports.tsx](../../../../../react/src/feature-module/hrm/hrDashboard/hrReports.tsx)

**Socket Calls:** 54 emit, 36 on
**Priority:** MEDIUM

**Migration Steps:**
1. Create dashboard REST APIs
2. Migrate dashboard widgets
3. Add analytics charts
4. Add HR reports
5. Add export functionality

**Estimated Time:** 12 hours

---

## 🎯 WEEK 6: TESTING & DOCUMENTATION

### Day 36-38: Unit Testing
- [ ] Write tests for employee operations
- [ ] Write tests for resignation workflow
- [ ] Write tests for termination workflow
- [ ] Write tests for attendance
- [ ] Write tests for leave management

**Target Coverage:** 80%

**Estimated Time:** 24 hours

### Day 39: Integration Testing
- [ ] Test complete employee lifecycle
- [ ] Test resignation workflow end-to-end
- [ ] Test termination workflow end-to-end
- [ ] Test payroll generation
- [ ] Test leave approval workflow

**Estimated Time:** 8 hours

### Day 40: Documentation & Handoff
- [ ] Update API documentation
- [ ] Create user guide
- [ ] Create developer documentation
- [ ] Record demo video
- [ ] Handoff to QA

**Estimated Time:** 8 hours

---

## 📊 PROGRESS TRACKING

### Week 1 Goals
- [ ] Payroll API complete
- [ ] Employee schema complete
- [ ] Attendance schema complete
- [ ] Test infrastructure set up

### Week 2 Goals
- [ ] Employee pages migrated (100%)
- [ ] All employee CRUD working
- [ ] Search and filters working
- [ ] Pagination implemented

### Week 3 Goals
- [ ] Resignation workflow complete
- [ ] Termination workflow complete
- [ ] Designations migrated
- [ ] Promotions migrated

### Week 4 Goals
- [ ] Attendance tracking complete
- [ ] Leave management complete
- [ ] Leave approval workflow
- [ ] Leave balance calculation

### Week 5 Goals
- [ ] Payroll generation working
- [ ] Payslip generation working
- [ ] Dashboard complete
- [ ] Reports generated

### Week 6 Goals
- [ ] 80% test coverage
- [ ] All integration tests passing
- [ ] Documentation complete
- [ ] Ready for QA

---

## 🚨 RISK MITIGATION

### Risk 1: Payroll Calculation Complexity
**Mitigation:** Use existing salary calculator service, add unit tests

### Risk 2: Employee Lifecycle State Management
**Mitigation:** Create state machine for employee status transitions

### Risk 3: Large Dataset Performance
**Mitigation:** Implement pagination, lazy loading, caching

### Risk 4: Integration with Existing Socket.IO
**Mitigation:** Keep Socket.IO for real-time broadcasts, use REST for CRUD

---

## 📞 ESCALATION

| Issue | Escalation | Timeline |
|-------|-----------|----------|
| Blocked on API design | Tech Lead | 4 hours |
| Database schema issue | DBA + Tech Lead | 1 day |
| Payment calculation issue | Finance + Tech Lead | 1 day |
| Critical bug | All hands | Immediate |

---

**Owner:** Developer 1
**Daily Standup:** 10:00 AM
**Weekly Review:** Friday 4:00 PM
**Completion Target:** 6 weeks
