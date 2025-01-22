
tasks = {}
tasks.name = core.get_current_modname()
tasks.path = core.get_modpath(tasks.name)

dofile(tasks.path .. "/states.lua")
dofile(tasks.path .. "/registry.lua")
dofile(tasks.path .. "/test.lua")

-- DEBUG:
core.register_on_joinplayer(function(player, last_login)
	local pmeta = player:get_meta()
	local player_tasks = core.deserialize(pmeta:get_string("tasks"))
	if player_tasks == nil then
		core.log("player " .. player:get_player_name() .. " doesn't have tasks")
	else
		core.log("player " .. player:get_player_name() .. " already has tasks")
	end

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
