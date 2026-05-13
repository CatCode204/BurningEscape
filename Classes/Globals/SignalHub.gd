extends Node

signal on_player_death()
signal on_game_win()

signal on_level_exit()
signal on_level_restart()

func emit_on_level_exit():
    on_level_exit.emit()

func emit_on_level_restart():
    on_level_restart.emit()

func emit_on_player_death():
    on_player_death.emit()

func emit_on_game_win():
    on_game_win.emit()