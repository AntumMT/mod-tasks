
log_error, log_warn = dofile(tasks.path .. "/helper_functions.lua")

local registry = {}

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

	if TaskDef.logic ~= nil and type(TaskDef.logic) ~= "function" then
		log_error("`TaskDef.logic` must be a function")
		return
	end
	if TaskDef.logic then
		-- start logic loop
		core.register_globalstep(function(dtime)
			for _, player in pairs(core.get_connected_players()) do
				if tasks.player_has(player, id) then
					TaskDef:logic(dtime, player)
				end
			end
		end)
	end

	registry[id] = TaskDef
end

function tasks.get_definition(id)
	return registry[id]
end

function tasks.get_title(id)
	local task_def = registry[id]
	if task_def == nil then
		log_warn("`tasks.get_title`: unregistered ID \"" .. id .. "\"")
		return
	end
	return task_def.title
end
