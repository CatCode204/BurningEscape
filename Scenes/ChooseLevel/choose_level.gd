extends Control

@export var _level_button_packed_scene : PackedScene;
@export var _button_container : GridContainer;

func _ready() -> void:
	for i in range(GameManager.get_number_levels()):
		var button : LevelButton = _level_button_packed_scene.instantiate();
		button.set_up(i);
		_button_container.add_child(button);

func back_to_main_menu():
	GameManager.load_main_scene()
