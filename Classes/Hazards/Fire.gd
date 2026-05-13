class_name FireHazard
extends Area3D

@export var max_health: float = 100.0
var current_health: float

@onready var fire_particles: GPUParticles3D = $FireParticles
@onready var fire_light: OmniLight3D = $FireLight
@onready var fire_audio: AudioStreamPlayer3D = $FireAudio # Thêm node Audio

var initial_scale: Vector3
var initial_light_energy: float
var initial_volume_db: float

func _ready() -> void:
	current_health = max_health
	collision_layer = 2 
	collision_mask = 0
	
	if fire_particles:
		initial_scale = fire_particles.scale
	if fire_light:
		initial_light_energy = fire_light.light_energy
	if fire_audio:
		initial_volume_db = fire_audio.volume_db

func take_damage(amount: float) -> void:
	current_health -= amount
	
	if current_health <= 0:
		extinguish()
	else:
		_update_visuals()

func _update_visuals() -> void:
	var health_percent = current_health / max_health
	
	if fire_particles:
		fire_particles.scale = initial_scale * health_percent
		
	if fire_light:
		fire_light.light_energy = initial_light_energy * health_percent
		
	# Giảm âm lượng dần dần khi lửa nhỏ đi (Giảm tối đa 20 decibel)
	if fire_audio:
		fire_audio.volume_db = initial_volume_db - (1.0 - health_percent) * 20.0

func extinguish() -> void:
	print("Đám cháy đã bị dập tắt!")
	if fire_audio:
		fire_audio.stop() # Tắt âm thanh
	queue_free()