extends TextureButton

@export var item_drop : PackedScene = preload("uid://b4quw2vnagf60")
@export var item_type : Item_Data
@export var bag_id: String
@export var Dialogue_Description : DialogueResource
@export var Start_Dialogue : String


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
	new_item.item_texture = item_type.item_sprite
	new_item.item_id = item_type.item_name
	get_parent().call_deferred("add_child", new_item)



func _on_mouse_entered() -> void:
	GameValues.change_item_name_description.emit(bag_id)
	


func _on_mouse_exited() -> void:
	GameValues.change_item_name_description.emit("")


func _on_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		DialogueManager.show_dialogue_balloon(Dialogue_Description,Start_Dialogue)
