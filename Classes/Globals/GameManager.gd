extends Node

const MAIN_SCENE_PACKED_SCENE : PackedScene = preload("res://Scenes/MainMenu/MainMenu.tscn");
const CHOOSE_LEVEL_PACKED_SCENE : PackedScene = preload("res://Scenes/ChooseLevel/ChooseLevel.tscn")

func exit_game():
    get_tree().quit()

func load_main_scene():
    get_tree().change_scene_to_packed(MAIN_SCENE_PACKED_SCENE)

func load_choose_level_scene():
    get_tree().change_scene_to_packed(CHOOSE_LEVEL_PACKED_SCENE)