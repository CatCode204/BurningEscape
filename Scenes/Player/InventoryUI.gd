extends Control

@onready var item_list_label: Label = $MarginContainer/VBoxContainer/ItemListLabel

func _ready() -> void:
	# Lắng nghe sự kiện từ SignalHub
	SignalHub.inventory_updated.connect(_on_inventory_updated)
	_update_ui([]) # Gọi lần đầu để dọn dẹp Text lúc mới vào game

func _on_inventory_updated(items: Array) -> void:
	_update_ui(items)

func _update_ui(items: Array) -> void:
	var list_text = ""
	if items.is_empty():
		list_text = "(Trống)"
	else:
		for item in items:
			list_text += "- " + item + "\n"
			
	item_list_label.text = list_text
