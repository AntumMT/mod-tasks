
tasks = {}
tasks.name = core.get_current_modname()
tasks.path = core.get_modpath(tasks.name)

dofile(tasks.path .. "/states.lua")
dofile(tasks.path .. "/registry.lua")

core.register_on_joinplayer(function(player, last_login)
	-- populate player's tasks from storage
	local all_data = wdata.read("player_tasks") or {}
	local player_tasks = all_data[player:get_player_name()]
	if player_tasks ~= nil then
		player:get_meta():set_string("tasks", core.serialize(player_tasks))
	end
end)
