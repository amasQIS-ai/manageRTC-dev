/**
 * Holidays REST API Hook
 * Replaces Socket.IO-based holiday operations with REST API calls
 * Real-time updates still use Socket.IO listeners
 */

import { useState, useCallback } from 'react';
import { message } from 'antd';
import { get, post, put, del, ApiResponse } from '../services/api';

export interface Holiday {
  _id: string;
  title: string;
  date: string;
  description?: string;
  status: 'Active' | 'Inactive';
  holidayTypeId: string;
  holidayTypeName?: string;
  repeatsEveryYear: boolean;
  createdBy?: string;
  createdAt?: string;
  updatedAt?: string;
}

/**
 * Holidays REST API Hook
 */
export const useHolidaysREST = () => {
  const [holidays, setHolidays] = useState<Holiday[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  /**
   * Fetch all holidays
   * REST API: GET /api/holidays
   */
  const fetchHolidays = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response: ApiResponse<Holiday[]> = await get('/holidays');

      if (response.success && response.data) {
        setHolidays(response.data);
        return response.data;
      } else {
        throw new Error(response.error?.message || 'Failed to fetch holidays');
      }
    } catch (err: any) {
      const errorMessage = err.response?.data?.error?.message || err.message || 'Failed to fetch holidays';
      setError(errorMessage);
      message.error(errorMessage);
      return [];
    } finally {
      setLoading(false);
    }
  }, []);

  /**
   * Get holiday by ID
   * REST API: GET /api/holidays/:id
   */
  const getHolidayById = useCallback(async (holidayId: string): Promise<Holiday | null> => {
    try {
      const response: ApiResponse<Holiday> = await get(`/holidays/${holidayId}`);

      if (response.success && response.data) {
        return response.data;
      }
      throw new Error(response.error?.message || 'Failed to fetch holiday');
    } catch (err: any) {
      const errorMessage = err.response?.data?.error?.message || err.message || 'Failed to fetch holiday';
      message.error(errorMessage);
      return null;
    }
  }, []);

  /**
   * Get holidays by year
   * REST API: GET /api/holidays/year/:year
   */
  const getHolidaysByYear = useCallback(async (year: number): Promise<Holiday[]> => {
    try {
      const response: ApiResponse<Holiday[]> = await get(`/holidays/year/${year}`);

      if (response.success && response.data) {
        return response.data;
      }
      return [];
    } catch (err: any) {
      const errorMessage = err.response?.data?.error?.message || err.message || 'Failed to fetch holidays';
      message.error(errorMessage);
      return [];
    }
  }, []);

  /**
   * Get upcoming holidays
   * REST API: GET /api/holidays/upcoming
   */
  const getUpcomingHolidays = useCallback(async (limit: number = 10): Promise<Holiday[]> => {
    try {
      const response: ApiResponse<Holiday[]> = await get('/holidays/upcoming', {
        params: { limit }
      });

      if (response.success && response.data) {
        return response.data;
      }
      return [];
    } catch (err: any) {
      const errorMessage = err.response?.data?.error?.message || err.message || 'Failed to fetch upcoming holidays';
      console.error(errorMessage);
      return [];
    }
  }, []);

  /**
   * Create new holiday
   * REST API: POST /api/holidays
   */
  const createHoliday = useCallback(async (holidayData: Partial<Holiday>): Promise<boolean> => {
    try {
      const response: ApiResponse<Holiday> = await post('/holidays', holidayData);

      if (response.success && response.data) {
        message.success('Holiday created successfully!');
        setHolidays(prev => [...prev, response.data!]);
        return true;
      }
      throw new Error(response.error?.message || 'Failed to create holiday');
    } catch (err: any) {
      const errorMessage = err.response?.data?.error?.message || err.message || 'Failed to create holiday';
      message.error(errorMessage);
      return false;
    }
  }, []);

  /**
   * Update holiday
   * REST API: PUT /api/holidays/:id
   */
  const updateHoliday = useCallback(async (holidayId: string, updateData: Partial<Holiday>): Promise<boolean> => {
    try {
      const response: ApiResponse<Holiday> = await put(`/holidays/${holidayId}`, updateData);

      if (response.success && response.data) {
        message.success('Holiday updated successfully!');
        setHolidays(prev =>
          prev.map(holiday =>
            holiday._id === holidayId ? { ...holiday, ...response.data! } : holiday
          )
        );
        return true;
      }
      throw new Error(response.error?.message || 'Failed to update holiday');
    } catch (err: any) {
      const errorMessage = err.response?.data?.error?.message || err.message || 'Failed to update holiday';
      message.error(errorMessage);
      return false;
    }
  }, []);

  /**
   * Delete holiday
   * REST API: DELETE /api/holidays/:id
   */
  const deleteHoliday = useCallback(async (holidayId: string): Promise<boolean> => {
    try {
      const response: ApiResponse = await del(`/holidays/${holidayId}`);

      if (response.success) {
        message.success('Holiday deleted successfully!');
        setHolidays(prev => prev.filter(holiday => holiday._id !== holidayId));
        return true;
      }
      throw new Error(response.error?.message || 'Failed to delete holiday');
    } catch (err: any) {
      const errorMessage = err.response?.data?.error?.message || err.message || 'Failed to delete holiday';
      message.error(errorMessage);
      return false;
    }
  }, []);

  return {
    holidays,
    loading,
    error,
    fetchHolidays,
    getHolidayById,
    getHolidaysByYear,
    getUpcomingHolidays,
    createHoliday,
    updateHoliday,
    deleteHoliday
  };
};

export default useHolidaysREST;
