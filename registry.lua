
log_error, log_warn = dofile(tasks.path .. "/helper_functions.lua")

local registry = {}

--- Registers a task.
--
--  @function tasks.register
--  @tparam string id
--    Task identifier.
--  @tparam table TaskDef
--    Task definition table. See @{TaskDef}.
function tasks.register(id, TaskDef)
	if not id then
		log_error("invalid task ID")
		return
	end
	if registry[id] ~= nil then
		log_error("task with ID \"" .. id .. "\" already registered")
		return
	end

	if TaskDef.title == nil then
		log_error("`TaskDef.title` not defined")
		return
	end
	if type(TaskDef.title) ~= "string" then
		log_error("`TaskDef.title` must be a string")
	end

	if TaskDef.logic == nil then
		log_error("`TaskDef.logic` function not defined")
		return
	end
	if type(TaskDef.logic) ~= "function" then
		log_error("`TaskDef.logic` must be a function")
		return
	end

	TaskDef.is_complete = TaskDef.is_complete or function(self, player)
		return tasks.get_player_state(player, id, 1) == "done"
	end
	if type(TaskDef.is_complete) ~= "function" then
		log_error("`TaskDef.is_complete` must be a function")
		return
	end

	TaskDef.on_complete = TaskDef.on_complete or function(self, player)
		-- optionally overridden in registration
	end
	if type(TaskDef.on_complete) ~= "function" then
		log_error("`TaskDef.on_complete` must be a function")
		return
	end

	TaskDef.get_log = TaskDef.get_log or function(self, player)
		return nil
	end
	if type(TaskDef.get_log) ~= "function" then
		log_error("`TaskDef.get_log` must be a function")
		return
	end

	registry[id] = TaskDef

	core.register_on_mods_loaded(function()
		TaskDef:logic()
	end)
end

--- Retrieves a task definition.
--
--  @tparam string id
--    Task identifier.
--  @return
--    @{TaskDef} table or `nil` if `id` not registered.
function tasks.get_definition(id)
	return registry[id]
end

--- Retrieves human readable title.
--
--  @function tasks.get_title
--  @tparam string id
--    Task identifier.
--  @return
--    Task title `string` or `nil` if `id` not registered.
function tasks.get_title(id)
	local task_def = registry[id]
	if task_def == nil then
		log_warn("`tasks.get_title`: unregistered ID \"" .. id .. "\"")
		return
	end
	return task_def.title
end


--- Task definition.
--
--  @table TaskDef
--  @field title
--    Text to be used as header for displaying to player.
--  @field logic
--    Function with task logic instructions for completing (may be removed). See @{TaskDef:logic}.
--  @field is_complete
--    _(optional)_ Function to check if player has completed task. See @{TaskDef:is_complete}.
--  @field on_complete
--    _(optional)_ Function to execute instructions when state is considered complete after call to
--    @{tasks.set_state}. See @{TaskDef:on_complete}.
--  @field get_log
--    _(optional)_ Function to retrieve task steps descriptions for displaying to player. See
--    @{TaskDef:get_log}.

--- Function with task logic instructions for completing (may be removed).
--
--  @function TaskDef:logic

--- Function to check if player has completed task.
--
--  The default is to check if the value of the first task index is "done".
--
--  @function TaskDef:is_complete
--  @param player
--    Player object reference.
--  @treturn boolean
--    `true` if the task is in a state which is considered to have been completed.

--- Function to execute instructions when state is considered complete after call to
--  @{tasks.set_state}.
--
--  @function TaskDef:on_complete
--  @tparam PlayerObjectRef player
--    Player reference.

--- Function to retrieve task steps descriptions for displaying to player.
--
--  @function TaskDef:get_log
--  @tparam PlayerObjectRef player
--    Player reference.
--  @treturn table
--    Task progress as list of descriptions.
