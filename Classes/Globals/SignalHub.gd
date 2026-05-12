extends Node

signal on_player_death()
signal on_game_win()

func emit_on_player_death():
    on_player_death.emit()

func emit_on_game_win():
    on_game_win.emit()