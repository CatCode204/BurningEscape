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

# Đổi thành _is_open để quản lý trạng thái chính xác
var _is_open : bool = false; 
var _init_pos : Vector3
var _init_quat : Quaternion # Lưu dưới dạng Quaternion để xoay chuẩn xác

func _ready() -> void:
	_init_pos = position
	# Lưu trạng thái xoay ban đầu dưới dạng Quaternion 
	_init_quat = quaternion 

# Hàm nhận tín hiệu tương tác từ Player (Phím E)
func _on_door_interacted(_player: Node3D) -> void:
	if _is_open:
		close_door()
	else:
		open_door()

func open_door() -> void:
	if _is_open: return
	_is_open = true # Phải cập nhật trạng thái [cite: 37]
	
	var tween : Tween = get_tree().create_tween()
	match _door_type:
		DoorType.Slide:
			var target_pos = _init_pos + _door_size * _movement_direction
			tween.tween_property(self, "position", target_pos, _speed).set_trans(_transition).set_ease(_easing)
		DoorType.Rotate:
			# Tính toán Quaternion mục tiêu (Xoay thêm một góc từ vị trí gốc)
			var rotation_euler = Vector3(
				deg_to_rad(_rotation_amount) * _rotation_axis.x,
				deg_to_rad(_rotation_amount) * _rotation_axis.y,
				deg_to_rad(_rotation_amount) * _rotation_axis.z
			)
			var target_quat = _init_quat * Quaternion.from_euler(rotation_euler)
			# Tween thuộc tính "quaternion" thay vì "rotation" để tránh lỗi xoay vòng 
			tween.tween_property(self, "quaternion", target_quat, _speed).set_trans(_transition).set_ease(_easing)

func close_door() -> void:
	if not _is_open: return
	_is_open = false
	
	var tween : Tween = get_tree().create_tween()
	match _door_type:
		DoorType.Slide:
			tween.tween_property(self, "position", _init_pos, _speed).set_trans(_transition).set_ease(_easing)
		DoorType.Rotate:
			# Quay về Quaternion gốc ban đầu, Quaternion sẽ tự chọn đường ngắn nhất để quay lại
			tween.tween_property(self, "quaternion", _init_quat, _speed).set_trans(_transition).set_ease(_easing)