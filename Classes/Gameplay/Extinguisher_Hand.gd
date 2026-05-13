class_name ExtinguisherHand
extends Node3D

@onready var foam_particles: GPUParticles3D = $FoamParticles

@export var damage_per_second: float = 40.0

# Hàm use giờ đây nhận thêm tia ngắm (cam_raycast) từ Player truyền vào
func use(delta: float, cam_raycast: RayCast3D) -> void:
	# Bật hiệu ứng phun bọt
	if not foam_particles.emitting:
		foam_particles.emitting = true
		
	# Dùng tia ngắm của Camera để dập lửa (đảm bảo luôn bắn trúng tâm màn hình)
	if cam_raycast and cam_raycast.is_colliding():
		var target = cam_raycast.get_collider()
		if target is FireHazard:
			target.take_damage(damage_per_second * delta)

func stop() -> void:
	# Tắt hiệu ứng bọt khi nhả chuột
	if foam_particles.emitting:
		foam_particles.emitting = false