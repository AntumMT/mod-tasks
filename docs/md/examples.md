
# State Values

## Setting & Getting State

State values are stored in player meta as a single string with indexes delimited by semicolons (;).

__Example:__ Setting & getting player task state.

```lua
local player = core.get_player_by_name(name)
local task_id = "my_task"

-- set entire state string
tasks.set_player_state(player, task_id, "value1;value2")

-- print entire state string
print(tasks.get_player_state(player, task_id)) -- result: "value1;value2"

-- set third index of state string
tasks.set_player_state(player, task_id, 3, "value3")

-- print entire state string
print(tasks.get_player_state(player, task_id)) -- result: "value1;value2;value3"

-- print third index of state string
print(tasks.get_player_state(player, task_id, 3)) -- result: "value3"
```


# Task Registration

## Task Definition

See [task definition table](tables.md#taskdef).

__Example:__ Creating a task definition.

```lua
local task_def = {
	title = "My Task",
	description = "Walk 200 nodes",
	meta = {
		req_steps = 200
	},

	is_complete = function(self, player)
		-- task is "complete" if player walked the number of nodes designated in `TaskDef.meta.req_steps`
		return (tonumber(tasks.get_player_state(player, self.id, 1)) or 0) >= self.meta.req_steps
	end,

	on_complete = function(self, player)
		-- play a sound to notify player task complete
		core.sound_play({name="mymod_mysound"}, {to_player=player:get_player_name())
	end,

	get_log = function(self, player)
		local desc = {}

		if self:is_complete(player) then
			table.insert(desc, "I have completed the task.")
		else
			table.insert(desc, "I have not yet walked far enough.")
		end
		-- index 1 represents number of steps player has taken since task began
		local steps = tonumber(tasks.get_player_state(player, self.id, 1)) or 0
		table.insert(desc, "I have taken " .. steps .. " out of " .. self.meta.req_steps .. " steps.")

		return desc
	end
}
```


## Registering Definition

To register a task definition simply use the [tasks.register] function.

__Example:__

```lua
tasks.register("step_200_nodes", task_def)
```


## Implementing Logic

The [TaskDef:logic] function can be used to execute instructions at each server step. If it is
defined at time of registration it will be registered for execution with [core.register_globalstep].
It is executed for each player that has the task and is not considered completed.

__Example:__

```lua
task_def.logic = function(self, dtime, player)
	local pos = player:getpos()
	pos = {x=math.floor(pos.x), y=math.floor(pos.x)}
	-- index 2 represents player's position at previous call
	local old_pos = core.deserialize(tasks.get_player_state(player, self.id, 2)) or pos
	local steps_taken = math.abs(pos.x - old_pos.x) + math.abs(pos.y - old_pos.y)
	-- FIXME: compensate for teleporting
	if steps_taken > 0 then
		-- index 1 represents number of steps player has taken since task began
		local total_steps = (tonumber(tasks.get_player_state(player, self.id, 1)) or 0) + steps_taken
		if total_steps > self.meta.req_steps then
			total_steps = self.meta.req_steps
		end
		-- set new position first as setting steps count may trigger `TaskDef:on_complete`
		tasks.set_player_state(player, self.id, 2, core.serialize(pos))
		tasks.set_player_state(player, self.id, 1, total_steps)
	end
end
```


[core.register_globalstep]: https://api.luanti.org/core-namespace-reference/#global-callback-registration-functions
[tasks.register]: functions.md#tasksregister
[TaskDef:logic]: tables.md#taskdeflogic
