extends Node
<<<<<<< HEAD

const MAIN_SCENE_PACKED_SCENE : PackedScene = preload("res://Scenes/MainMenu/MainMenu.tscn");
const CHOOSE_LEVEL_PACKED_SCENE : PackedScene = preload("res://Scenes/ChooseLevel/ChooseLevel.tscn")

const LEVEL_PACKED_SCENES : Array[PackedScene] = [
    preload("res://Scenes/Levels/Level1.tscn"),
    preload("res://Scenes/Levels/Level2.tscn")
]

func get_number_levels():
    return LEVEL_PACKED_SCENES.size()

func load_level(level : int):
    get_tree().change_scene_to_packed(LEVEL_PACKED_SCENES[level])

func exit_game():
    get_tree().quit()

func load_main_scene():
    get_tree().change_scene_to_packed(MAIN_SCENE_PACKED_SCENE)

func load_choose_level_scene():
    get_tree().change_scene_to_packed(CHOOSE_LEVEL_PACKED_SCENE)
=======
>>>>>>> inventory
