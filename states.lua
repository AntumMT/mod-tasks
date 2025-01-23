
log_error, log_warn = dofile(tasks.path .. "/helper_functions.lua")

local function serialize(state_table)
	local state_string = ""
	for _, s in ipairs(t) do
		if #state_string > 0 then
			state_string = state_string .. ";"
		end
		state_string = state_string .. s
	end
	return state_string
end

local function deserialize(state_string)
	local state_table = {}
	for s in string.gmatch(state_string, "([^;]+)") do
		table.insert(state_table, s:trim())
	end
	return state_table
end

function tasks.get_player_tasks(player)
	return core.deserialize(player:get_meta():get_string("tasks")) or {}
end

function tasks.get_player_state(player, id, index)
	if type(index) ~= "number" then
		index = 0
	end
	local list = index == true

	local player_tasks = tasks.get_player_tasks(player)
	local state_string = player_tasks[id]
	if index > 0 and state_string ~= nil then
		-- return value of single state index
		return deserialize(state_string)[index]
	end
	-- return value of all indexes
	if list then
		return deserialize(state_string)
	end
	return state_string
end

function tasks.set_player_state(player, id, index, value)
	if value == nil then
		value = index
		index = 0
	end
	if value ~= nil then
		value = tostring(value):trim()
	end
	if index > 0 and value == nil then
		-- use empty string to preserve indexes
		value = ""
	end

	local player_tasks = tasks.get_player_tasks(player)
	local state_string = player_tasks[id]
	if index > 0 then
		-- update a single index
		local state_table = deserialize(state_string or "")
		state_table[index] = value
		state_string = serialize(state_table)
	else
		-- overwrite all task data
		state_string = value
	end
	player_tasks[id] = state_string
	player:get_meta():set_string("tasks", core.serialize(player_tasks))

	local task_def = tasks.get_definition(id)
	if task_def == nil then
		log_warn("`tasks.set_state`: unregistered ID \"" .. id .. "\"")
	elseif tasks.player_is_complete(player, id) then
		task_def:on_complete(player)
	end
end

function tasks.player_has(player, id)
	return tasks.get_player_tasks(player)[id] ~= nil
end

function tasks.player_is_complete(player, id)
	local task_def = tasks.get_definition(id)
	if task_def == nil then
		log_warn("`tasks.player_is_complete`: unregistered ID " .. id)
		return false
	end
	return task_def:is_complete(player) or false
end

function tasks.get_player_log(player, id)
	local task_def = tasks.get_definition(id)
	if task_def == nil then
		log_warn("`tasks.get_player_log`: unregistered ID " .. id)
		return false
	end
	return task_def:get_log(player) or {}
end
