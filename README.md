# Tasks Framework

## About

Tasks & questing framework for [Luanti (Minetest)](https://luanti.org/). Inspired by
[Stendhal's](https://stendhalgame.org/) quest API.

___WARNING:__ This mod is in early development & may not be suitable for production servers._

Similar to [TeTpaAka's Quest Framework](https://forum.luanti.org/viewtopic.php?t=11265), this mod aims to be a library for adding quests & tasks to games. It is meant to be a minimalist library, so does not include any formspec interfaces. Mods must create their own which can be populated using the functions:

- `tasks.get_registered()`: Returns list of all registered task IDs.
- `tasks.get_title(id)`: Returns task title string.
- `tasks.get_description(id)`: Returns task description string.
- `tasks.get_player_log(player, id)`: Returns list of task string descriptors for player's state.


## Dependencies

_none_


## Links

- [![ContentDB](https://content.luanti.org/packages/AntumDeluge/tasks/shields/title/)](https://content.luanti.org/packages/AntumDeluge/tasks/)
- [API reference](https://antumluanti.codeberg.page/mod-tasks/) ([mirror](https://antummt.github.io/mod-tasks/))
- [![Codeberg](https://img.shields.io/static/v1?logo=codeberg&label=Codeberg&message=AntumLuanti/mod-tasks&color=%23375a7f)](https://codeberg.org/AntumLuanti/mod-tasks)
- [![GitHub](https://img.shields.io/static/v1?logo=github&label=GitHub&message=AntumMT/mod-tasks&color=%23375a7f)](https://github.com/AntumMT/mod-tasks)
- [![Forum](https://img.shields.io/static/v1?logo=minetest&label=Forum&message=tasks&color=%23375a7f)](https://forum.luanti.org/viewtopic.php?t=31304)
- [sample task mod](https://codeberg.org/AntumLuanti/mod-sample_task) ([mirror](https://github.com/AntumMT/mod-sample_task))
