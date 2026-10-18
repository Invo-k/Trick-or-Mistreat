extends TextureButton

@export var item_drop : PackedScene = preload("uid://b4quw2vnagf60")

func _on_button_down() -> void:
	if ConfigManager.is_dragging:
		return
	add_item_to_mouse()

func add_item_to_mouse() -> void:
	var center := global_position + size / 2.0
	var new_item = item_drop.instantiate()
	new_item.initialPos = center
	new_item.offset = get_global_mouse_position() - center
	new_item.draggable = true
	ConfigManager.is_dragging = true
	get_parent().call_deferred("add_child", new_item)
