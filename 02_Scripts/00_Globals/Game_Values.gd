extends Node

signal change_item_name_description(String)
signal candy_time_animation
signal next_dialogue

var first_dialogue: bool
var actual_character_level : int
var is_candy_time : bool
var door_texture : Texture2D = load("res://00_Assets/00_Sprites/00_Backgrounds/TOM_BocetoLocked.png")

func change_scene_dialogue():
	TransitionManager.transition_animator.play("Move_Right")
	await TransitionManager.transition_animator.animation_finished
	get_tree().change_scene_to_file("res://01_Scenes/00_UI/main_menu.tscn")
