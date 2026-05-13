class_name PickupItem
extends Interactable

@export var item_name: String = "Bình chữa cháy"

func interact(player: Node3D) -> void:
	super.interact(player) # Vẫn gọi hàm gốc để in log ra console (nếu muốn)
	
	# Kiểm tra xem người chơi có túi đồ (có hàm add_to_inventory) không
	if player.has_method("add_to_inventory"):
		player.add_to_inventory(item_name)
		
		# Nhặt xong thì xoá vật thể này khỏi thế giới 3D
		queue_free()
