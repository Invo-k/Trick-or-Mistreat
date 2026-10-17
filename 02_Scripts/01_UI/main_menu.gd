extends Control

const OPTION_MENU = preload("uid://cuc15xx6rysxb")


func _ready() -> void:
	cargar_opciones_intro()




func _on_start_pressed() -> void:
	pass # Replace with function body.

func _on_options_pressed() -> void:
	var new_option_menu = OPTION_MENU.instantiate()
	call_deferred("add_child", new_option_menu)

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
