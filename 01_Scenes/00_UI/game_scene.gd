extends Node2D
@onready var item_name_description: RichTextLabel = %ItemNameDescription
@onready var shady_hands: TextureButton = %Shady_Hands
var tween : Tween

func _ready() -> void:
	TransitionManager.transition_animator.play_backwards("Move")
	item_name_description.text = ""
	GameValues.change_item_name_description.connect(change_text_description)
	shady_hands.pivot_offset = shady_hands.size / 2.0
	print(shady_hands.pivot_offset)
	GameValues.scale_hands.connect(soltar_objeto)
	

func _on_button_pressed() -> void:
	print("PULSÉ EL BOTÓN")
	TransitionManager.transition_animator.play("Move")
	await TransitionManager.transition_animator.animation_finished
	get_tree().change_scene_to_file("res://01_Scenes/00_UI/door_scene.tscn")
	TransitionManager.transition_animator.play_backwards("Move")
	await TransitionManager.transition_animator.animation_finished

func change_text_description(text : String):
	item_name_description.text = "[color=yellow]" + text + "[/color]"

func _on_shady_hands_mouse_entered() -> void:
	print("entré")
	if ConfigManager.is_dragging:
		print("entré x2")
		if tween: tween.kill()
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(shady_hands, "scale", Vector2(1.07, 1.07), 0.25)
		print(shady_hands.scale)


func _on_shady_hands_mouse_exited() -> void:
	if shady_hands.scale != Vector2(1,1):
		if tween: tween.kill()
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(shady_hands, "scale", Vector2(1, 1), 0.25)


func soltar_objeto() -> void:
	if shady_hands.scale != Vector2(1,1):
		if tween: tween.kill()
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(shady_hands, "scale", Vector2(1, 1), 0.25)
		print(shady_hands.scale)
