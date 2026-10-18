extends CanvasLayer

@onready var screen_text: RichTextLabel = $Control/MarginContainer/VBoxContainer/Screen/Screen_Text
@onready var option_screen: OptionButton = $Control/MarginContainer/VBoxContainer/Screen/Option_Screen
@onready var music_text: RichTextLabel = $Control/MarginContainer/VBoxContainer/Music/Music_Text
@onready var music_value: HSlider = $Control/MarginContainer/VBoxContainer/Music/Music_Value
@onready var sfx_text: RichTextLabel = $Control/MarginContainer/VBoxContainer/SFX/SFX_Text
@onready var sfx_value: HSlider = $Control/MarginContainer/VBoxContainer/SFX/SFX_Value
@onready var back: Button = %Back


func cargar_opciones() -> void:
	music_value.value = ConfigManager.audio_musica
	sfx_value.value = ConfigManager.audio_sfx
	
	if ConfigManager.screen_mode == "FULLSCREEN":
			option_screen.select(0)
		
	if ConfigManager.screen_mode == "BORDER":
			option_screen.select(1)
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			centrar_ventana()
		
	if ConfigManager.screen_mode == "WINDOW":
			option_screen.select(2)
			DisplayServer.window_set_size(Vector2i(1280, 720))
			centrar_ventana()


func centrar_ventana() -> void:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = DisplayServer.window_get_size()
	
	var window_position := (screen_size - window_size) / 2
	
	DisplayServer.window_set_position(window_position)

func _on_option_screen_item_selected(index: int) -> void:
	match index:
		0:
			ConfigManager.screen_mode = "Pantalla Completa"
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
		1:
			ConfigManager.screen_mode = "Modo Ventana"
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1280, 720))
			centrar_ventana()
		
		2:
			ConfigManager.screen_mode = "Sin Bordes"
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			centrar_ventana()

func _on_music_value_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(value))
	ConfigManager.audio_musica = value


func _on_sfx_value_value_changed(value: float) -> void:
	ConfigManager.audio_sfx = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(value))



func _on_back_pressed() -> void:
	ConfigManager.save_options("GRAPHICS OPTIONS","Fullscreen", ConfigManager.screen_mode)
	ConfigManager.save_options("AUDIO OPTIONS","BGM", ConfigManager.audio_musica)
	ConfigManager.save_options("AUDIO OPTIONS","SFX", ConfigManager.audio_sfx)
	queue_free()
