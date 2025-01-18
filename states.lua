
log_error, log_warn = dofile(tasks.path .. "/helper_functions.lua")

--- Converts table to string.
--
--  @local serialize
--  @tparam table
--    Table of strings.
--  @treturn string
--    String representation.
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

--- Converts string to table.
--
--  @local deserialize
--  @tparam string state_string
--    String representation.
--  @treturn table
--    Table of strings.
local function deserialize(state_string)
	local state_table = {}
	for s in string.gmatch(state_string, "([^;]+)") do
		table.insert(state_table, s:trim())
	end
	return state_table
end

--- Retrieves states of tasks that player has started.
--
--  @function tasks.get_player_tasks
--  @tparam PlayerObjectRef player
--    Player reference.
--  @treturn table
--    Table of player's started tasks.
function tasks.get_player_tasks(player)
	return core.deserialize(player:get_meta():get_string("tasks")) or {}
end

--- Retrieves player's current state for specified task.
--
--  @function tasks.get_player_state
--  @tparam PlayerObjectRef player
--    Player reference.
--  @tparam string id
--    Task identifier.
--  @tparam[opt] int index
--    Task state index. If value is `nil` or less than 1 the entire state string is returned.
--  @treturn string
--    State string representation.
function tasks.get_player_state(player, id, index)
	if index == nil then
		index = 0
	end

	local player_tasks = tasks.get_player_tasks(player)
	local state_string = player_tasks[id]
	if index > 0 and state_string ~= nil then
		-- return value of single state index
		return deserialize(state_string)[index]
	end
	-- return value of all indexes
	return state_string
end

--- Sets player's current state for specified task.
--
--  @function tasks.set_player_state
--  @tparam PlayerObjectRef player
--    Player reference.
--  @tparam string id
--    Task identifier.
--  @tparam[opt] int index
--    State index to be updated. If value is `nil` or less than 1 the entire state string is
--    updated.
--  @tparam[opt] string value
--    New state value. If this is omitted `index` is used as the value parameter.
function tasks.set_player_state(player, id, index, value)
	if value == nil then
		value = index
		index = 0
	end
	if value ~= nil then
		value = value:trim()
	end

	local player_tasks = tasks.get_player_tasks(player)
	local state_string = player_tasks[id]
	if index > 0 then
		-- update a single index
		local state_table = deserialize(state_string)
		state_table[index] = value
		state_string = serialize(state_table)
	else
		-- overwrite all task data
		state_string = value
	end
	player_tasks[id] = state_string
	player:get_meta():set_string("tasks", core.serialize(player_tasks))

	-- write to disk
	local all_data = wdata.read("player_tasks") or {}
	all_data[player:get_player_name()] = player_tasks
	wdata.write("player_tasks", all_data)

	local task_def = tasks.get_definition(id)
	if task_def == nil then
		log_warn("`tasks.set_state`: unregistered ID \"" .. id .. "\"")
	else
		task_def:on_complete(player)
	end
end

--- Checks if player has started a specified task.
--
--  @functions tasks.player_has
--  @tparam PlayerObjectRef player
--    Player reference.
--  @tparam int id
--    Task identifier.
--  @treturn boolean
--    `true` if state is not `nil`.
function tasks.player_has(player, id)
	return tasks.get_player_tasks(player)[id] ~= nil
end

--- Checks if player's task is considered to be in a completed state.
--
--  @function tasks.player_is_complete
--  @tparam PlayerObjectRef player
--    Player reference.
--  @tparam int id
--    Task identifier.
--  @treturn boolean
--    `true` if task definition considers task completed by player.
function tasks.player_is_complete(player, id)
	local task_def = tasks.get_definition(id)
	if task_def == nil then
		log_warn("`tasks.player_is_complete`: unregistered ID " .. id)
		return false
	end
	return task_def:is_complete(player)
end
