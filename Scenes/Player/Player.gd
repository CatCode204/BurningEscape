extends CharacterBody3D

const ACTION_MOVE_FOWARD : String = "move_foward";
const ACTION_MOVE_BACKWAD : String = "move_backward";
const ACTION_MOVE_LEFT : String = "move_left";
const ACTION_MOVE_RIGHT : String = "move_right";
const ACTION_MOVE_JUMP : String = "move_jump";
const ACTION_MOVE_SPRINT : String = "move_sprint";
const ACTION_INTERACT : String = "interact"; # Nút tương tác mới (VD: phím E)
const ACTION_EQUIP_1 : String = "equip_1"
const ACTION_USE : String = "use_item"

@export_group("Movement")
@export var _walk_speed : float = 5.0;
@export var _sprint_speed : float = 8.0;
@export var _jump_velocity : float = 4.8;
@export var _sensitivity = 0.004

@export_group("Bob")
@export var _bob_freq : float = 2.4;
@export var _bob_amp : float = 0.08;

@export_group("FOV")
@export var _base_fov = 75.0;
@export var _fov_change = 1.5;

@export_group("Nodes")
@export var _head : Node3D;
@export var _eye : Camera3D;
@export var _blurPostProcessNode : ColorRect;
@export var _interact_raycast : RayCast3D; # Raycast để tương tác
@export var _extinguisher_model : MeshInstance3D
@export var _foam_particles : GPUParticles3D
@export var _sub_view_port : SubViewport;
@export var _model_view_camera : ModelViewCamera;

var _current_speed : float = 0.0;
var _t_bob : float = 0.0;

const GRAVITY : float = 9.8;

func _ready() -> void:
	_sub_view_port.size = DisplayServer.window_get_size()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_model_view_camera.sway(- event.relative)
		_head.rotate_y(- event.relative.x * _sensitivity);
		_eye.rotate_x(-event.relative.y * _sensitivity);
		_eye.rotation.x = clamp(_eye.rotation.x, deg_to_rad(-40), deg_to_rad(60));

func _process(_delta: float) -> void:
	_handle_interaction()
	_handle_equipment()
	_handle_use_item(_delta)

func _handle_interaction() -> void:
	if Input.is_action_just_pressed(ACTION_INTERACT):
		if _interact_raycast and _interact_raycast.is_colliding():
			var target = _interact_raycast.get_collider()
			if target is Interactable:
				target.interact(self)

func _handle_movement(delta : float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Handle Jump.
	if Input.is_action_just_pressed(ACTION_MOVE_JUMP) and is_on_floor():
		velocity.y = _jump_velocity
	
	# Handle Sprint.
	if Input.is_action_pressed(ACTION_MOVE_SPRINT):
		_current_speed = _sprint_speed
	else:
		_current_speed = _walk_speed

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector(ACTION_MOVE_LEFT, ACTION_MOVE_RIGHT, ACTION_MOVE_FOWARD, ACTION_MOVE_BACKWAD)
	var direction = (_head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * _current_speed
			velocity.z = direction.z * _current_speed
		else:
			velocity.x = lerp(velocity.x, direction.x * _current_speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * _current_speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * _current_speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * _current_speed, delta * 3.0)
	
	# Head bob
	_t_bob += delta * velocity.length() * float(is_on_floor())
	_eye.transform.origin = _headbob(_t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, _sprint_speed * 2)
	var target_fov =_base_fov + _fov_change * velocity_clamped
	_eye.fov = lerp(_eye.fov, target_fov, delta * 8.0)

func _handle_equipment() -> void:
	# Bấm phím 1 để rút bình ra
	if Input.is_action_just_pressed(ACTION_EQUIP_1):
		# Chỉ rút được nếu trong túi có Bình chữa cháy
		if "Bình chữa cháy" in inventory:
			equip_item("Bình chữa cháy")
			if _extinguisher_model:
				_extinguisher_model.visible = true # Hiện bình lên

func _handle_use_item(delta: float) -> void: # Nhớ thêm tham số delta
	# Chỉ xịt được nếu đang cầm bình chữa cháy
	if equipped_item == "Bình chữa cháy":
		if Input.is_action_pressed(ACTION_USE): # Khi ĐANG GIỮ chuột trái
			if _foam_particles and not _foam_particles.emitting:
				_foam_particles.emitting = true
			
			# ---- LOGIC DẬP LỬA ----
			if _interact_raycast and _interact_raycast.is_colliding():
				var target = _interact_raycast.get_collider()
				
				# Kiểm tra xem vật bị tia trúng có phải là Đám cháy (FireHazard) không
				if target is FireHazard:
					# Lửa có 100 máu. Trừ 40 máu/giây -> Mất khoảng 2.5 giây xịt liên tục để dập tắt.
					target.take_damage(40.0 * delta)
					
		else: # Khi NHẢ chuột trái
			if _foam_particles and _foam_particles.emitting:
				_foam_particles.emitting = false

func _physics_process(delta : float):
	_handle_movement(delta)
	move_and_slide()

func _set_blur(blur_value : float):
	var mat : ShaderMaterial = _blurPostProcessNode.material as ShaderMaterial;
	mat.set_shader_parameter("blur_amount", blur_value)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * _bob_freq) * _bob_amp
	pos.x = cos(time * _bob_freq / 2) * _bob_amp
	return pos


var inventory: Array[String] = []
var equipped_item: String = ""

func add_to_inventory(item_name: String) -> void:
	inventory.append(item_name)
	print("Đã lượm được: ", item_name)
	
	SignalHub.inventory_updated.emit(inventory)

func equip_item(item_name: String) -> void:
	if item_name in inventory:
		equipped_item = item_name
		SignalHub.item_equipped.emit(item_name)
		print("Đang cầm: ", item_name)
