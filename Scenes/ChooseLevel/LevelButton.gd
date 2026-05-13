extends TextureButton

class_name LevelButton;

@export var _level_label : Label;

var _level_number : int = 0;

func set_up(level_number : int):
	_level_number = level_number
	_level_label.text = "%02d" % (_level_number + 1)

func _on_pressed() -> void:
	GameManager.load_level(_level_number)
