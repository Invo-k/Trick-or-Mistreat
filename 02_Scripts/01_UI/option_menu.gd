extends CanvasLayer

@onready var option_screen: OptionButton = %Option_Screen
@onready var music_value: HSlider = %Music_Value
@onready var sfx_value: HSlider = %SFX_Value
@onready var back: TextureButton = %Back

@onready var screen_text: RichTextLabel = %Screen_Text
@onready var music_text: RichTextLabel = %Music_Text
@onready var sfx_text: RichTextLabel = %SFX_Text
@onready var languaje_text: RichTextLabel = %Languaje_Text
@onready var languaje_value: CarouselOptionButton = %Languaje_Value
@onready var animator_options: AnimationPlayer = %animator_options

@export_category("OPTIONS_TEXTS")
@export var wave_effect : String = "[wave amp=25 freq=5]"
@export var shake_effect : String = "[color=yellow][shake rate=18 level=13]"
@export var Screen_Text : String = "Ajustes de Pantalla"
@export var Music_Text : String = "Música"
@export var SFX_Text : String = "Efectos de Sonido"
@export var Languaje_Text : String = "Idioma"

var menu_changes : bool = false

func _ready() -> void:
	cargar_opciones()
	animator_options.play("cubano_mode")
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
	
	if ConfigManager.languaje == "es":
		languaje_value.select(0)
	
	if ConfigManager.languaje == "en":
		languaje_value.select(1)

func centrar_ventana() -> void:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = DisplayServer.window_get_size()
	
	var window_position := (screen_size - window_size) / 2
	
	DisplayServer.window_set_position(window_position)

func _on_option_screen_item_selected(index: int) -> void:
	match index:
		0:
			ConfigManager.screen_mode = "FULLSCREEN"
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		#1:
			#ConfigManager.screen_mode = "Sin Bordes"
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
			#DisplayServer.window_set_size(Vector2i(1920, 1080))
			#centrar_ventana()
	
		1:
			ConfigManager.screen_mode = "1280x720"
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1280, 720))
			centrar_ventana()
	
		2:
			ConfigManager.screen_mode = "960x540"
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(960.0, 540.0))
			centrar_ventana()
		
	menu_changes = true

func _on_music_value_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(value))
	ConfigManager.audio_musica = value
	menu_changes = true


func _on_sfx_value_value_changed(value: float) -> void:
	ConfigManager.audio_sfx = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(value))
	menu_changes = true


func _on_languaje_value_item_selected(index: int) -> void:
	match index:
		0:
			ConfigManager.languaje = "es"
		
		1:
			ConfigManager.languaje = "en"
	
	TranslationServer.set_locale(ConfigManager.languaje)
	languaje_text.text = shake_effect + tr(Languaje_Text) + "[/shake]"
	print("SE HA CAMBIADO EL IDIOMA A: " + ConfigManager.languaje)
	
	menu_changes = true


func _on_back_pressed() -> void:
	save_menu_data()
	TransitionManager.transition_animator.play("menu_open")
	await TransitionManager.transition_animator.animation_finished
	queue_free()
	TransitionManager.transition_animator.play_backwards("menu_open")
	GameValues.last_focus.grab_focus()
	GameValues.last_focus = null

func save_menu_data():
	if menu_changes == true:
		ConfigManager.save_options("AUDIO", "BGM", ConfigManager.audio_musica)
		ConfigManager.save_options("AUDIO", "SFX", ConfigManager.audio_sfx)
		ConfigManager.save_options("GRAPHICS", "Fullscreen", ConfigManager.screen_mode)
		ConfigManager.save_options("LOCALIZATION","Languaje", ConfigManager.languaje)
		print("AJUSTES GUARDADOS.")

func _on_option_focus_entered() -> void:
	screen_text.text = shake_effect + tr(Screen_Text) + "[/shake]"

func _on_option_focus_exited() -> void:
	#screen_text.text = wave_effect + Screen_Text + "[/wave]"
	screen_text.text = Screen_Text

func _on_music_value_focus_entered() -> void:
	music_text.text = shake_effect + tr(Music_Text) + "[/shake]"

func _on_music_value_focus_exited() -> void:
	#music_text.text = wave_effect + Music_Text + "[/wave]"
	music_text.text = Music_Text

func _on_sfx_value_focus_entered() -> void:
	sfx_text.text = shake_effect + tr(SFX_Text) + "[/shake]"

func _on_sfx_value_focus_exited() -> void:
	#sfx_text.text = wave_effect + SFX_Text + "[/wave]"
	sfx_text.text = SFX_Text

func _on_languaje_value_focus_entered() -> void:
	languaje_text.text = shake_effect + tr(Languaje_Text) + "[/shake]"

func _on_languaje_value_focus_exited() -> void:
	#languaje_text.text = wave_effect + Languaje_Text + "[/wave]"
	languaje_text.text = Languaje_Text
