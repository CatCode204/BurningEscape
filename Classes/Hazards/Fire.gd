class_name FireHazard
extends Area3D

@export var max_health: float = 100.0
var current_health: float

@onready var fire_particles: GPUParticles3D = $FireParticles
@onready var fire_light: OmniLight3D = $FireLight

var initial_scale: Vector3
var initial_light_energy: float

func _ready() -> void:
	current_health = max_health
	
	# Đảm bảo layer va chạm là 2 để Raycast dập lửa có thể nhận diện được
	collision_layer = 2 
	collision_mask = 0
	
	if fire_particles:
		initial_scale = fire_particles.scale
	if fire_light:
		initial_light_energy = fire_light.light_energy

# Hàm này sẽ được súng chữa cháy gọi liên tục khi xịt trúng
func take_damage(amount: float) -> void:
	current_health -= amount
	
	if current_health <= 0:
		extinguish()
	else:
		_update_visuals()

func _update_visuals() -> void:
	var health_percent = current_health / max_health
	
	# Ngọn lửa nhỏ dần theo % máu
	if fire_particles:
		fire_particles.scale = initial_scale * health_percent
		
	# Ánh sáng tối dần
	if fire_light:
		fire_light.light_energy = initial_light_energy * health_percent

func extinguish() -> void:
	print("Đám cháy đã bị dập tắt hoàn toàn!")
	# Khi tắt lửa, ta có thể xoá nó đi
	queue_free()