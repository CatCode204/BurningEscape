extends Camera3D

class_name ModelViewCamera;

@export var _rigid : Node3D;

@export_category("Settings")
@export var _to_center_lerp_amount : float = 5;
@export var _sway_multiplier : float = 0.005;

func _process(delta: float) -> void:
	_rigid.position = lerp(_rigid, Vector3.ZERO, _to_center_lerp_amount * delta);

func sway(sway_vec : Vector2):
	_rigid.position.x -= sway_vec.x * _sway_multiplier;
	_rigid.position.y += sway_vec.y * _sway_multiplier;