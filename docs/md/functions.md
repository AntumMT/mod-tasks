
# Task Registration

## tasks.register

`tasks.register(id, def)`

__Description:__

> Registers a new task/quest.

__Parameters:__

- __id:__ (string) Task identifier.
- __def:__ ([TaskDef]) Task definition table.


## tasks.get_registered

`tasks.get_registered`

__Description:__

> Retrieves list of registered task IDs.

__Returns:__ (table) Registered task IDs.


## tasks.get_definition

`tasks.get_definition(id)`

__Description:__

> Retrieves a task definition.

__Parameters:__

- __id:__ (string) Task identifier.

__Returns:__ [`TaskDef`][TaskDef] or `nil`.


## tasks.get_title

`tasks.get_title(id)`

__Description:__

> Retrieves human readable title.

__Parameters:__

- __id:__ (string) Task identifier.

__Returns:__ Task title `string` or `nil` if `id` not registered.


## tasks.get_description

`tasks.get_description(id)`

__Description:__

> Retrieves task description.

__Parameters:__

- __id:__ (string) Task identifier.

__Returns:__ Task description `string` or `nil` if `id` not registered.


# Player States

## tasks.get_player_tasks

`tasks.get_player_tasks(player)`

__Description:__

> Retrieves all player's tasks.

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.

__Returns:__ (table) Player's task states indexed by ID.


## tasks.set_player_state

`tasks.set_player_state(player, id[, index][, value])`

__Description:__

> Sets task state with ID `id` for `player` to `value`.

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.
- __id:__ (string) Task identifier.
- __index:__ (int) (optional) Task state index to be updated. If `nil` or less than 1 then entire
  state string is updated.
- __value:__ (any) (optional) New value (converted to string) for state index or entire state
  string. If `nil` then index is set to empty string or entire state is unset.


## tasks.get_player_state

`tasks.get_player_state(player, id[, index|list])`

__Description:__

> Retrieves task state string from player meta info.

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.
- __id:__ (string) Task identifier.
- __index:__ (int) (optional) Task state index.
- __list:__ (boolean) (optional) Flag to return list instead of string for entire state.

__Returns:__ (string|table) String value of state index or entire state string if `index` is `nil`
  or less than 1. If `table` is `true` then a list of strings of entire state is returned.


## tasks.player_has

`tasks.player_has(player, id)`

__Description:__

> Checks if player has a task.

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.
- __id:__ (string) Task identifier.

__Returns:__ (boolean) `true` if `id` is found in player tasks.


## tasks.player_is_complete

`tasks.player_is_complete(player, id)`

__Description:__

> Checks if task state is considered complete. Wrapper for [TaskDef:is_complete].

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.
- __id:__ (string) Task identifier.

__Returns:__ (boolean) `true` if task definition considers task completed by player.


## tasks.get_player_log

`tasks.get_player_log(player, id)`

__Description:__

> Retrieves task descriptors for displaying to player. Wrapper for [TaskDef:get_log].

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.
- __id:__ (string) Task identifier.

__Returns:__ (table) List of string descriptors.


[ObjectRef]: https://api.luanti.org/class-reference/#objectref
[TaskDef]: tables.md#taskdef
[TaskDef:get_log]: tables.md#taskdefget_log
[TaskDef:is_complete]: tables.md#taskdefis_complete
