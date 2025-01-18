
tasks = {}
tasks.name = core.get_current_modname()
tasks.path = core.get_modpath(tasks.name)

dofile(tasks.path .. "/states.lua")
dofile(tasks.path .. "/registry.lua")
dofile(tasks.path .. "/test.lua")

core.register_on_joinplayer(function(player, last_login)
	-- populate player's tasks from storage
	local all_data = wdata.read("player_tasks") or {}
	local player_tasks = all_data[player:get_player_name()]
	if player_tasks ~= nil then
		player:get_meta():set_string("tasks", core.serialize(player_tasks))
	end

	-- DEBUG:
	core.log("tasks for player " .. player:get_player_name() .. ": " .. tostring(player:get_meta():get_string("tasks")))
	tasks.set_player_state(player, "foo", "started")
	tasks.set_player_state(player, "bar", "done")
	tasks.set_player_state(player, "baz", "null")
	core.log("tasks for player " .. player:get_player_name() .. ": " .. tostring(player:get_meta():get_string("tasks")))
	local pname = player:get_player_name()
	for _, id in ipairs({"foo", "bar", "baz", "foo2"}) do
		core.log(pname .. " has " .. id .. ": " .. tostring(tasks.player_has(player, id)))
		core.log("  state: " .. tostring(tasks.get_player_state(player, id)) .. ", done: " .. tostring(tasks.player_is_complete(player, id)))
	end
end)
