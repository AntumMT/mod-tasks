
tasks = {}
tasks.name = core.get_current_modname()
tasks.path = core.get_modpath(tasks.name)

dofile(tasks.path .. "/states.lua")
dofile(tasks.path .. "/registry.lua")
