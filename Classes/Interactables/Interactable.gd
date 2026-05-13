class_name Interactable
extends Area3D 
signal interacted(by_player)

func interact(player: Node3D) -> void:
	print("[Interactable] Đã tương tác với: ", name)
	interacted.emit(player)
