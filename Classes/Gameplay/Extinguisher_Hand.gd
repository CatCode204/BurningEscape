class_name ExtinguisherHand
extends Node3D

@onready var foam_particles: GPUParticles3D = $FoamParticles
@onready var spray_audio: AudioStreamPlayer3D = $SprayAudio # Thêm biến quản lý âm thanh

@export var damage_per_second: float = 40.0

func use(delta: float, cam_raycast: RayCast3D) -> void:
	# Bật bọt và chạy âm thanh (nếu chưa chạy)
	if not foam_particles.emitting:
		foam_particles.emitting = true
		if spray_audio and not spray_audio.playing:
			spray_audio.play()
		
	if cam_raycast and cam_raycast.is_colliding():
		var target = cam_raycast.get_collider()
		if target is FireHazard:
			target.take_damage(damage_per_second * delta)

func stop() -> void:
	# Tắt bọt và dừng âm thanh khi nhả chuột
	if foam_particles.emitting:
		foam_particles.emitting = false
		if spray_audio:
			spray_audio.stop()