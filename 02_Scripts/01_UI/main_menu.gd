extends Control

const OPTION_MENU = preload("uid://cuc15xx6rysxb")
@export var Scene_Music : String
@onready var start: Button_Menu = %Start
@onready var options: Button_Menu = %Options

func _ready() -> void:
	cargar_opciones_intro()
	AudioManager.play_music(Scene_Music, 1.0)
	GameValues.actual_character_level = 0
	GameValues.is_candy_time = false
	TransitionManager.transition_animator.play("Fade_Out")
	start.grab_focus()
	
func _on_start_pressed() -> void:
	TransitionManager.transition_animator.play("Move_Right")
	await TransitionManager.transition_animator.animation_finished
	get_tree().change_scene_to_file("res://01_Scenes/00_UI/door_scene.tscn")

func _on_options_pressed() -> void:
	var new_option_menu = OPTION_MENU.instantiate()
	call_deferred("add_child", new_option_menu)
	GameValues.last_focus = options

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func cargar_opciones_intro() -> void:
	if ConfigManager.screen_mode == "BORDER":
			centrar_ventana()
		
	if ConfigManager.screen_mode == "WINDOW":
			centrar_ventana()

func centrar_ventana() -> void:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = DisplayServer.window_get_size()
	
	var window_position := (screen_size - window_size) / 2
	
	DisplayServer.window_set_position(window_position)
