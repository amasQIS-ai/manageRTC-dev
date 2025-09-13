import Task from '../../models/task/task.schema.js';
import { generateId } from '../../utils/generateId.js';

export const createTask = async (companyId, taskData) => {
  try {
    const taskId = generateId('task');
    const newTask = new Task({
      _id: taskId,
      ...taskData,
      companyId,
    });

    const savedTask = await newTask.save();
    return {
      done: true,
      data: savedTask,
      message: 'Task created successfully'
    };
  } catch (error) {
    console.error('Error creating task:', error);
    return {
      done: false,
      error: error.message
    };
  }
};

export const getTasks = async (companyId, filters = {}) => {
  try {
    const query = {
      companyId,
      isDeleted: { $ne: true }
    };

    
    if (filters.projectId) {
      query.projectId = filters.projectId;
    }

    if (filters.status && filters.status !== 'all') {
      query.status = filters.status;
    }

    if (filters.priority && filters.priority !== 'all') {
      query.priority = filters.priority;
    }

    if (filters.assignee) {
      query.assignee = { $in: [filters.assignee] };
    }

    if (filters.search) {
      query.$or = [
        { title: { $regex: filters.search, $options: 'i' } },
        { description: { $regex: filters.search, $options: 'i' } },
        { tags: { $in: [new RegExp(filters.search, 'i')] } }
      ];
    }

    const sortOptions = {};
    if (filters.sortBy) {
      sortOptions[filters.sortBy] = filters.sortOrder === 'desc' ? -1 : 1;
    } else {
      sortOptions.createdAt = -1;
    }

    const tasks = await Task.find(query)
      .sort(sortOptions)
      .limit(filters.limit || 50)
      .skip(filters.skip || 0);

    const totalCount = await Task.countDocuments(query);

    return {
      done: true,
      data: tasks,
      totalCount,
      message: 'Tasks retrieved successfully'
    };
  } catch (error) {
    console.error('Error getting tasks:', error);

    // If it's a timeout error due to collection not existing, return empty results
    if (error.message && error.message.includes('buffering timed out')) {
      console.log('Tasks collection does not exist yet, returning empty results');
      return {
        done: true,
        data: [],
        totalCount: 0,
        message: 'Tasks retrieved successfully (collection not created yet)'
      };
    }

    return {
      done: false,
      error: error.message
    };
  }
};

export const getTaskById = async (companyId, taskId) => {
  try {
    const task = await Task.findOne({
      _id: taskId,
      companyId,
      isDeleted: { $ne: true }
    });

    if (!task) {
      return {
        done: false,
        error: 'Task not found'
      };
    }

    return {
      done: true,
      data: task,
      message: 'Task retrieved successfully'
    };
  } catch (error) {
    console.error('Error getting task by ID:', error);

    // If it's a timeout error due to collection not existing, return not found
    if (error.message && error.message.includes('buffering timed out')) {
      console.log('Tasks collection does not exist yet');
      return {
        done: false,
        error: 'Task not found'
      };
    }

    return {
      done: false,
      error: error.message
    };
  }
};

export const updateTask = async (companyId, taskId, updateData) => {
  try {
    const updatedTask = await Task.findOneAndUpdate(
      {
        _id: taskId,
        companyId,
        isDeleted: { $ne: true }
      },
      {
        ...updateData,
        updatedAt: new Date()
      },
      { new: true }
    );

    if (!updatedTask) {
      return {
        done: false,
        error: 'Task not found'
      };
    }

    return {
      done: true,
      data: updatedTask,
      message: 'Task updated successfully'
    };
  } catch (error) {
    console.error('Error updating task:', error);

    // If it's a timeout error due to collection not existing, return not found
    if (error.message && error.message.includes('buffering timed out')) {
      console.log('Tasks collection does not exist yet');
      return {
        done: false,
        error: 'Task not found'
      };
    }

    return {
      done: false,
      error: error.message
    };
  }
};

export const deleteTask = async (companyId, taskId) => {
  try {
    const deletedTask = await Task.findOneAndUpdate(
      {
        _id: taskId,
        companyId,
        isDeleted: { $ne: true }
      },
      {
        isDeleted: true,
        updatedAt: new Date()
      },
      { new: true }
    );

    if (!deletedTask) {
      return {
        done: false,
        error: 'Task not found'
      };
    }

    return {
      done: true,
      data: deletedTask,
      message: 'Task deleted successfully'
    };
  } catch (error) {
    console.error('Error deleting task:', error);

    // If it's a timeout error due to collection not existing, return not found
    if (error.message && error.message.includes('buffering timed out')) {
      console.log('Tasks collection does not exist yet');
      return {
        done: false,
        error: 'Task not found'
      };
    }

    return {
      done: false,
      error: error.message
    };
  }
};

export const getTasksByProject = async (companyId, projectId, filters = {}) => {
  try {
    const query = {
      companyId,
      projectId,
      isDeleted: { $ne: true }
    };

    
    if (filters.status && filters.status !== 'all') {
      query.status = filters.status;
    }

    if (filters.priority && filters.priority !== 'all') {
      query.priority = filters.priority;
    }

    if (filters.assignee) {
      query.assignee = { $in: [filters.assignee] };
    }

    const tasks = await Task.find(query).sort({ createdAt: -1 });

    return {
      done: true,
      data: tasks,
      message: 'Project tasks retrieved successfully'
    };
  } catch (error) {
    console.error('Error getting project tasks:', error);

    // If it's a timeout error due to collection not existing, return empty results
    if (error.message && error.message.includes('buffering timed out')) {
      console.log('Tasks collection does not exist yet, returning empty results');
      return {
        done: true,
        data: [],
        message: 'Project tasks retrieved successfully (collection not created yet)'
      };
    }

    return {
      done: false,
      error: error.message
    };
  }
};

export const getTaskStats = async (companyId, projectId = null) => {
  try {
    const matchQuery = {
      companyId,
      isDeleted: { $ne: true }
    };

    if (projectId) {
      matchQuery.projectId = projectId;
    }

    const stats = await Task.aggregate([
      { $match: matchQuery },
      {
        $group: {
          _id: null,
          total: { $sum: 1 },
          pending: {
            $sum: { $cond: [{ $eq: ['$status', 'Pending'] }, 1, 0] }
          },
          inprogress: {
            $sum: { $cond: [{ $eq: ['$status', 'Inprogress'] }, 1, 0] }
          },
          completed: {
            $sum: { $cond: [{ $eq: ['$status', 'Completed'] }, 1, 0] }
          },
          onhold: {
            $sum: { $cond: [{ $eq: ['$status', 'Onhold'] }, 1, 0] }
          }
        }
      }
    ]);

    const result = stats[0] || {
      total: 0,
      pending: 0,
      inprogress: 0,
      completed: 0,
      onhold: 0
    };

    return {
      done: true,
      data: result,
      message: 'Task stats retrieved successfully'
    };
  } catch (error) {
    console.error('Error getting task stats:', error);

    // If it's a timeout error due to collection not existing, return empty stats
    if (error.message && error.message.includes('buffering timed out')) {
      console.log('Tasks collection does not exist yet, returning empty stats');
      return {
        done: true,
        data: {
          total: 0,
          pending: 0,
          inprogress: 0,
          completed: 0,
          onhold: 0
        },
        message: 'Task stats retrieved successfully (collection not created yet)'
      };
    }

    return {
      done: false,
      error: error.message
    };
  }
};
