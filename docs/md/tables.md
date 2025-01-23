
# Task Definition

## TaskDef

__Description:__

Task definition table.

__Fields:__

- __title:__ (string) Human readable name of task.
- __is_complete:__ ([function](#taskdefis_complete)) (optional) Checks if player has completed task.
- __on_complete:__ ([function](#taskdefon_complete)) (optional) Called to execute instructions
  when state is considered complete after call to _[tasks.set_state]_.
- __get_log:__ ([function](#taskdefget_log)) (optional) Retrieves list of task state descriptors.
- __logic:__ ([function](#taskdeflogic)) (optional) Called at every server step. ___Should NOT be
  called manually.___


# Task Definition Functions

## TaskDef:is_complete

`TaskDef:is_complete(player)`

__Description:__

> Checks if player has completed task.

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.

__Returns:__ (bool) `true` if the task is in a state which is considered to have been completed.


## TaskDef:on_complete

`TaskDef:on_compete(player)`

__Description:__

> Called to execute instructions when state is considered complete after call to
  _[tasks.set_state]_.

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.


## TaskDef:get_log

`TaskDef:get_log(player)`

__Description:__

> Retrieves list of task state descriptors.

__Parameters:__

- __player:__ ([ObjectRef]) Player reference.

__Returns:__ List of state descriptors.


## TaskDef:logic

`TaskDef:logic()`

__Description:__

Called at every server step. ___Should NOT be called manually.___


[ObjectRef]: https://api.luanti.org/class-reference/#objectref
[tasks.set_state]: functions.md#tasksset_state
