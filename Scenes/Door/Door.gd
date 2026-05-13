extends AnimatableBody3D

enum DoorType { Slide, Rotate }

@export var _door_type : DoorType;

@export_group("Door Settings")
@export var _movement_direction : Vector3;
@export var _rotation_axis : Vector3 = Vector3(0, 1 ,0);
@export var _rotation_amount : float = 90.0;
@export var _door_size : Vector3

@export_group("Close Settings")
@export var close_time : float = 2.0;

@export_group("Tween Settings")
@export var _speed : float = 0.5;
@export var _transition : Tween.TransitionType;
@export var _easing : Tween.EaseType;

var _is_opening : bool = false;

var _init_pos : Vector3
var _init_rotation : Vector3

func _ready() -> void:
	_init_pos = position
	_init_rotation = rotation

func open_door() -> void:
	var tween : Tween = get_tree().create_tween()
	match _door_type:
		DoorType.Slide:
			tween.tween_property(self, "position", _init_pos + _door_size * _movement_direction, _speed).set_trans(_transition).set_ease(_easing)
		DoorType.Rotate:
			tween.tween_property(self, "rotation", _init_rotation + deg_to_rad(_rotation_amount) * _rotation_axis, _speed).set_trans(_transition).set_ease(_easing)
	tween.tween_interval(close_time)
	tween.tween_callback()

func close_door() -> void:
	var tween : Tween = get_tree().create_tween()
	match _door_type:
		DoorType.Slide:
			tween.tween_property(self, "position", _init_pos, _speed).set_trans(_transition).set_ease(_easing)
		DoorType.Rotate:
			tween.tween_property(self, "rotation", _init_rotation, _speed).set_trans(_transition).set_ease(_easing)

func _on_door_interact_area_body_entered(body: Node3D) -> void:
	if _is_opening:
		close_door()
	else:
		open_door()