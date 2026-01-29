/**
 * Designation REST API Routes
 * Designation-related endpoints
 */

import express from 'express';
import { authenticate } from '../../middleware/auth.js';
import { getAllDesignations } from '../../controllers/rest/designation.controller.js';

const router = express.Router();

// All routes require authentication
router.use(authenticate);

/**
 * @route   GET /api/designations
 * @desc    Get all designations with optional filtering
 * @query   departmentId - Filter by department ID
 * @query   status - Filter by status
 */
router.get('/', getAllDesignations);

export default router;
