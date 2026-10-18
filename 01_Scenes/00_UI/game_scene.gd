extends Node2D
@onready var item_name_description: RichTextLabel = %ItemNameDescription


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TransitionManager.transition_animator.play_backwards("Move_Left")
	item_name_description.text = ""
	GameValues.change_item_name_description.connect(change_text_description)

func _on_button_pressed() -> void:
	print("PULSÉ EL BOTÓN")
	TransitionManager.transition_animator.play("Move_Left")
	await TransitionManager.transition_animator.animation_finished
	get_tree().change_scene_to_file("res://01_Scenes/00_UI/door_scene.tscn")
	TransitionManager.transition_animator.play_backwards("Move_Right")
	await TransitionManager.transition_animator.animation_finished

func change_text_description(text : String):
	item_name_description.text = "[color=yellow]" + text + "[/color]"
