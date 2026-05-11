extends CharacterBody3D

# ALl player script goes here
@export var _move_speed : float = 5.0;
@export var _sprint_speed : float = 8.0;
@export var _accelerate_speed : float = 0.2;
@export var _deccelerate_speed : float = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
