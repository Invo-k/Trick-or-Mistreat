extends CanvasLayer

@onready var option_screen: OptionButton = %Option_Screen
@onready var music_value: HSlider = %Music_Value
@onready var sfx_value: HSlider = %SFX_Value
@onready var back: Button = %Back

@onready var screen_text: RichTextLabel = %Screen_Text
@onready var music_text: RichTextLabel = %Music_Text
@onready var sfx_text: RichTextLabel = %SFX_Text
@onready var languaje_text: RichTextLabel = %Languaje_Text

@export_category("OPTIONS_TEXTS")
@export var wave_effect : String = "[wave amp=25 freq=5]"
@export var shake_effect : String = "[color=yellow][shake rate=18 level=13]"
@export var Screen_Text : String = "Ajustes de Pantalla"
@export var Music_Text : String = "Música"
@export var SFX_Text : String = "Efectos de Sonido"
@export var Languaje_Text : String = "Idioma"


func _ready() -> void:
	cargar_opciones()
	TransitionManager.transition_animator.play_backwards("menu_open")
	option_screen.grab_focus()
	await TransitionManager.transition_animator.animation_finished

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


func _on_languaje_value_item_selected(index: int) -> void:
	match index:
		0:
			ConfigManager.languaje = "es"
		
		1:
			ConfigManager.languaje = "en"


func _on_back_pressed() -> void:
	ConfigManager.save_options("GRAPHICS OPTIONS","Fullscreen", ConfigManager.screen_mode)
	ConfigManager.save_options("AUDIO OPTIONS","BGM", ConfigManager.audio_musica)
	ConfigManager.save_options("AUDIO OPTIONS","SFX", ConfigManager.audio_sfx)
	TransitionManager.transition_animator.play("menu_open")
	await TransitionManager.transition_animator.animation_finished
	queue_free()
	TransitionManager.transition_animator.play_backwards("menu_open")
	GameValues.last_focus.grab_focus()
	GameValues.last_focus = null



func _on_option_focus_entered() -> void:
	screen_text.text = shake_effect + Screen_Text + "[/shake]"

func _on_option_focus_exited() -> void:
	#screen_text.text = wave_effect + Screen_Text + "[/wave]"
	screen_text.text = Screen_Text

func _on_music_value_focus_entered() -> void:
	music_text.text = shake_effect + Music_Text + "[/shake]"

func _on_music_value_focus_exited() -> void:
	#music_text.text = wave_effect + Music_Text + "[/wave]"
	music_text.text = Music_Text

func _on_sfx_value_focus_entered() -> void:
	sfx_text.text = shake_effect + SFX_Text + "[/shake]"

func _on_sfx_value_focus_exited() -> void:
	#sfx_text.text = wave_effect + SFX_Text + "[/wave]"
	sfx_text.text = SFX_Text

func _on_languaje_value_focus_entered() -> void:
	languaje_text.text = shake_effect + Languaje_Text + "[/shake]"

func _on_languaje_value_focus_exited() -> void:
	#languaje_text.text = wave_effect + Languaje_Text + "[/wave]"
	languaje_text.text = Languaje_Text
