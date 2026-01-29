# HRM Module - Issues & Technical Debt

**Module:** Human Resource Management
**Assigned To:** Developer 1
**Last Updated:** January 29, 2026

---

## 🔴 CRITICAL ISSUES (Must Fix Before Development)

### Issue #1: Missing Payroll Controller
**Severity:** 🔴 CRITICAL
**Location:** Backend
**Impact:** Cannot process payroll, blocks core HRM functionality

**Description:**
- Payroll REST controller doesn't exist
- Payroll calculation engine is incomplete
- No payslip generation API

**Fix Required:**
```bash
# Create controller
backend/controllers/rest/payroll.controller.js

# Create route
backend/routes/api/payrolls.js

# Create hook
react/src/hooks/usePayrollREST.ts
```

**Estimated Time:** 12 hours
**Assigned To:** Developer 1
**Priority:** BLOCKING

---

### Issue #2: Employee Schema Incomplete
**Severity:** 🔴 CRITICAL
**Location:** [backend/models/employee/employee.schema.js](../../../../../backend/models/employee/employee.schema.js)
**Impact:** Data integrity issues, missing fields

**Missing Fields:**
- `employeeCode` - Unique employee identifier
- `workEmail` - Work email address
- `personalEmail` - Personal email address
- `emergencyContact` - Emergency contact information object
- `bankDetails` - Bank details for payroll object

**Fix Required:**
```javascript
// Add to employee.schema.js
emergencyContact: {
  name: String,
  relationship: String,
  phone: String,
  address: String
},
bankDetails: {
  bankName: String,
  accountNumber: String,
  ifscCode: String,
  bankBranch: String
}
```

**Estimated Time:** 3 hours
**Assigned To:** Developer 1
**Priority:** BLOCKING

---

### Issue #3: Attendance Schema Missing
**Severity:** 🔴 CRITICAL
**Location:** Backend
**Impact:** Cannot track employee attendance

**Description:**
- Attendance schema doesn't exist
- No check-in/check-out tracking
- No leave balance calculations

**Fix Required:**
```bash
# Create schema
backend/models/attendance/attendance.schema.js

# Fields needed:
- employeeId: ObjectId
- date: Date
- checkIn: DateTime
- checkOut: DateTime
- workHours: Number
- status: Enum (present, absent, half-day, leave)
- leaveType: String (if on leave)
```

**Estimated Time:** 4 hours
**Assigned To:** Developer 1
**Priority:** HIGH

---

## 🟠 HIGH PRIORITY ISSUES

### Issue #4: Inconsistent Status Values
**Severity:** 🟠 HIGH
**Location:** Multiple files
**Impact:** Sorting/filtering broken, inconsistent UI

**Problem:**
Employee status can be:
- "active", "Active", "ACTIVE"
- "inactive", "Inactive", "INACTIVE"
- "on notice", "On Notice", "ON_NOTICE"
- "resigned", "Resigned"
- "terminated", "Terminated"

**Fix Required:**
Create status enum and use consistently:
```javascript
// backend/utils/constants.js
export const EMPLOYEE_STATUS = {
  ACTIVE: 'Active',
  INACTIVE: 'Inactive',
  ON_NOTICE: 'On Notice',
  RESIGNED: 'Resigned',
  TERMINATED: 'Terminated',
  ON_LEAVE: 'On Leave'
};
```

**Estimated Time:** 6 hours
**Files Affected:** 15 files

---

### Issue #5: No Input Validation on HR Forms
**Severity:** 🟠 HIGH
**Location:** Frontend forms
**Impact:** Invalid data submission, poor UX

**Forms Without Validation:**
- Employee creation form
- Resignation form
- Termination form
- Promotion form

**Fix Required:**
Add form validation using Ant Design Form:
```typescript
const [form] = Form.useForm();

const rules = {
  firstName: [{ required: true, message: 'First name is required' }],
  email: [
    { required: true, message: 'Email is required' },
    { type: 'email', message: 'Invalid email format' }
  ],
  employeeId: [
    { required: true, message: 'Employee ID is required' },
    { pattern: /^[A-Z0-9-]+$/, message: 'Invalid format' }
  ]
};
```

**Estimated Time:** 8 hours
**Files Affected:** 10 forms

---

### Issue #6: Missing Error Boundaries
**Severity:** 🟠 HIGH
**Location:** Frontend
**Impact:** App crashes on errors, poor UX

**Fix Required:**
Create error boundary component:
```typescript
// react/src/components/HRMErrorBoundary.tsx
class HRMErrorBoundary extends React.Component {
  state = { hasError: false, error: null };

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error('HRM Error:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <ErrorFallback error={this.state.error} />;
    }
    return this.props.children;
  }
}
```

**Estimated Time:** 4 hours

---

## 🟡 MEDIUM PRIORITY ISSUES

### Issue #7: Console.log Statements in Production
**Severity:** 🟡 MEDIUM
**Location:** Multiple files
**Impact:** Performance degradation, security risk

**Found:** 87 console.log statements across HRM module

**Examples:**
```javascript
// ❌ BAD - Exposes sensitive data
console.log('Employee data:', employees);

// ✅ GOOD - Use proper logger
logger.info('Employees fetched', { count: employees.length });
```

**Fix Required:**
Replace all console.log with proper logger:
```javascript
import logger from '../../utils/logger.js';

logger.debug('Debug message');
logger.info('Info message');
logger.warn('Warning message');
logger.error('Error message', { error });
```

**Estimated Time:** 4 hours

---

### Issue #8: No Loading States for Forms
**Severity:** 🟡 MEDIUM
**Location:** Frontend forms
**Impact:** Poor UX, users don't know what's happening

**Fix Required:**
Add loading indicators:
```typescript
const [loading, setLoading] = useState(false);

const handleSubmit = async (values) => {
  setLoading(true);
  try {
    await createEmployee(values);
    message.success('Employee created!');
  } catch (error) {
    message.error('Failed to create employee');
  } finally {
    setLoading(false);
  }
};

return (
  <Form onFinish={handleSubmit}>
    {/* Form fields */}
    <Button type="primary" htmlType="submit" loading={loading}>
      Submit
    </Button>
  </Form>
);
```

**Estimated Time:** 6 hours
**Files Affected:** 12 forms

---

### Issue #9: No Pagination on Large Lists
**Severity:** 🟡 MEDIUM
**Location:** Employee lists, reports
**Impact:** Performance issues with large datasets

**Fix Required:**
Implement pagination:
```typescript
const [pagination, setPagination] = useState({
  current: 1,
  pageSize: 20,
  total: 0
});

// Fetch with pagination
const fetchEmployees = async (page = 1, limit = 20) => {
  const response = await get('/employees', {
    params: { page, limit }
  });
  setPagination({
    current: page,
    pageSize: limit,
    total: response.total
  });
};
```

**Estimated Time:** 4 hours

---

### Issue #10: Missing Confirmation Dialogs
**Severity:** 🟡 MEDIUM
**Location:** Delete operations, critical actions
**Impact:** Accidental data loss

**Fix Required:**
Add confirmation modals:
```typescript
const handleDelete = (id) => {
  Modal.confirm({
    title: 'Delete Employee',
    content: 'Are you sure you want to delete this employee? This action cannot be undone.',
    okText: 'Delete',
    okType: 'danger',
    cancelText: 'Cancel',
    onOk: async () => {
      await deleteEmployee(id);
      message.success('Employee deleted');
    }
  });
};
```

**Estimated Time:** 3 hours
**Files Affected:** 8 files

---

## 🟢 LOW PRIORITY / TECHNICAL DEBT

### Issue #11: TODO Comments in Code
**Severity:** 🟢 LOW
**Count:** 24 TODO comments in HRM module

**Examples:**
```javascript
// TODO: Add validation for email format
// TODO: Implement pagination
// TODO: Fix this later - ugly code
```

**Action:** Convert to GitHub issues or complete them

**Estimated Time:** 2 hours

---

### Issue #12: Inconsistent Naming Conventions
**Severity:** 🟢 LOW
**Impact:** Code readability, maintenance

**Examples:**
```javascript
// Mixed conventions:
employeeId vs employee_id
companyId vs CompanyId
isActive vs is_active
```

**Fix Required:** Establish and document naming conventions

**Estimated Time:** 8 hours (entire module)

---

### Issue #13: No Unit Tests for HRM Components
**Severity:** 🟢 LOW
**Impact:** No regression testing

**Current Test Coverage:** 0%

**Target Test Coverage:** 80%

**Estimated Time:** 40 hours

---

## 📋 ISSUES SUMMARY

| Severity | Count | Estimated Time | Status |
|----------|-------|----------------|--------|
| 🔴 Critical | 3 | 19 hours | Not Started |
| 🟠 High | 3 | 18 hours | Not Started |
| 🟡 Medium | 4 | 17 hours | Not Started |
| 🟢 Low | 3 | 50 hours | Not Started |
| **Total** | **13** | **104 hours** | |

---

## 🎯 ISSUE RESOLUTION PLAN

### Week 1: Critical Issues
- [ ] Create Payroll controller (Issue #1) - 12 hours
- [ ] Complete Employee schema (Issue #2) - 3 hours
- [ ] Create Attendance schema (Issue #3) - 4 hours

### Week 2: High Priority Issues
- [ ] Fix status values consistency (Issue #4) - 6 hours
- [ ] Add form validation (Issue #5) - 8 hours
- [ ] Create error boundaries (Issue #6) - 4 hours

### Week 3-4: Medium & Low Priority
- [ ] Replace console.log statements (Issue #7) - 4 hours
- [ ] Add loading states (Issue #8) - 6 hours
- [ ] Implement pagination (Issue #9) - 4 hours
- [ ] Add confirmation dialogs (Issue #10) - 3 hours

---

## 📝 ISSUE TRACKING

All issues should be tracked in GitHub with these labels:
- `priority:critical` - Must fix immediately
- `priority:high` - Must fix this week
- `priority:medium` - Fix this sprint
- `priority:low` - Technical debt
- `module:hrm` - HRM module issues

---

**Next Action:** Start with Issue #1 (Payroll Controller)
**Owner:** Developer 1
**Review Date:** Weekly during standup
