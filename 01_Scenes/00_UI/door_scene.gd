extends Control

@export var Dialogue_Stages : Array[DialogueResource]

func _on_character_pressed() -> void:
	DialogueManager.show_dialogue_balloon(Dialogue_Stages[0], "door")


func _on_shady_hands_pressed() -> void:
	DialogueManager.show_dialogue_balloon(Dialogue_Stages[0], "candy")

func _on_button_pressed() -> void:
	print("PULSÉ EL BOTÓN")
	TransitionManager.transition_animator.play("Move_Right")
	await TransitionManager.transition_animator.animation_finished
	get_tree().change_scene_to_file("res://01_Scenes/00_UI/game_scene.tscn")
