extends Control

func restart_game():
	SignalHub.emit_on_level_restart()

func exit_level():
	SignalHub.emit_on_level_exit()