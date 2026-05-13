extends Node

signal on_player_death()
signal on_game_win()
signal inventory_updated(items: Array)
signal item_equipped(item_name: String)

func emit_on_player_death():
	on_player_death.emit()

func emit_on_game_win():
	on_game_win.emit()
