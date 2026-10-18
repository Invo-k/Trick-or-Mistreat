extends Node

class_name Config_Manager

##Este es el Script de Configuración de Ajustes Global creado por Pedro Reimundez.  
##[br]Este Script se encarga de almacenar Datos en un archivo de guardado de tipo .ini empleando los comandos [ConfigFile]. Adicionalmente, también se encarga de cargar los ajustes al comienzo del juego para que se adapten a la ultima vez que se ejecutó el juego.

#.dat si lo quieres encriptado, .ini si quieres que sea visible y modificable en el archivo. Para ajustes, usar .ini
#region Global Config
##Variable que almacena la ruta de guardado en [String] del archivo de Settings.
const _SAVE_PATH_SETTINGS : String = "user://settings.ini" #nombre de la ruta y archivo que se crea para los ajustes.

##Variable que indica el valor en [float] del bus de audio "Master".
var audio_master : float = 1
##Variable que indica el valor en [float] del bus de audio "Music".
var audio_musica : float = 1
##Variable que indica el valor en [float] del bus de audio "SFX".
var audio_sfx : float = 1

##Variable que indica el valor en [StringName] del estado de la pantalla de juego, siendo "FULLSCREEN", "WINDOW" y "BORDER".
var screen_mode : StringName = "FULLSCREEN"
##Variable que indica el valor en [String] del idioma que se está mostrando en el juego. Solo usar en caso de que añadamos más idiomas.
var languaje : String = "es"

##Archivo de tipo [ConfigFile] que almacenará los datos de todas las variables de este script en la ruta indicada anteriormente.
var config_file = ConfigFile.new()
#endregion

#region Gameplay Variables

var is_dragging : bool
var item_save : String

#endregion

func _ready() -> void:
	if !FileAccess.file_exists(_SAVE_PATH_SETTINGS): #si no existe un archivo en la ruta _SAVE_PATH_SETTINGS, crea estos valores, luego hay que guardarlos:
		#(primero titulo de la categoria, luego titulo individual y luego valor)
		
		config_file.set_value("AUDIO OPTIONS", "Master", audio_master)
		config_file.set_value("AUDIO OPTIONS", "BGM", audio_musica)
		config_file.set_value("AUDIO OPTIONS", "SFX", audio_sfx)
		
		config_file.set_value("GRAPHICS OPTIONS", "Fullscreen", screen_mode)
		
		config_file.set_value("LOCALIZATION OPTIONS","Languaje", languaje)
		
		config_file.save(_SAVE_PATH_SETTINGS) #guardas los valores que acabas de crear

	else: # Si ya existe, se carga el archivo
		config_file.load(_SAVE_PATH_SETTINGS)
	#una vez realice las comprobaciones, aplica la configuración, ya sea la básica o la actualizada.
	check_config()
	load_config()

#region Global Config
## Función que guarda los ajustes. Se llama desde cualquier otra escena y se le pasa sección, key y valor nuevo.
## Tanto la key como la sección tienen que ser de las ya escritas en el documento en el _ready de esta script.
func save_options(section:String,key:String, value)->void:
	if !config_file.has_section(section):
		print("La sección dada no existe en ajustes")
		return
	
	elif !config_file.has_section_key(section,key):
		print("La key no existe en ajustes")
		return
	
	else:
		config_file.set_value(section, key, value)
		config_file.save(_SAVE_PATH_SETTINGS)
	
	
## Función que puede ser llama por otra escena para cargar el valor de una key. Devuelve su valor.
func load_options(section:String,key:String)->Variant:
	if !config_file.has_section(section):
		print("La sección dada no existe en ajustes")
		return
	
	elif !config_file.has_section_key(section,key):
		print("La key no existe en ajustes")
		return
	
	else:
		config_file.load(_SAVE_PATH_SETTINGS) # Actualizamos
		return config_file.get_value(section, key)

##Funcion que se usa al comienzo de cada una de las ejecuciones del juego para indicarle al motor que hace cada uno de los valores que se almacenan en la configuración. [br]Ejemplo: indicar los buses de audio a cada una de las variables de audio o cargar el modo de ventana.
func load_config():
	var db_master = linear_to_db(audio_master)
	var db_music = linear_to_db(audio_musica)
	var db_sfx = linear_to_db(audio_sfx)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_master)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db_music)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),  db_sfx)

	if screen_mode == "FULLSCREEN":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if screen_mode == "BORDER":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
	if screen_mode == "WINDOW":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
	
	TranslationServer.set_locale(languaje)

##En caso de que alguien modifique sin querer la configuración, esto se asegura de que si no detecta un idioma existente, lo cambie a ingles.
func check_config():
	#carga el audio y lo revisa
	audio_master = load_options("AUDIO OPTIONS", "Master")
	audio_musica = load_options("AUDIO OPTIONS", "BGM")
	audio_sfx = load_options("AUDIO OPTIONS", "SFX")
	if audio_master < 0 or audio_master > 1:
		audio_master = 1
		save_options("AUDIO OPTIONS", "Master", audio_master)
		print("AVISO: EL JUEGO NO ESTABA EN UN MASTER VALIDO")
		
	if audio_musica < 0 or audio_musica > 1:
		audio_musica = 1
		save_options("AUDIO OPTIONS", "BGM", audio_musica)
		print("AVISO: EL JUEGO NO ESTABA EN UN MUSIC VALIDO")
		
	if audio_sfx < 0 or audio_sfx > 1:
		audio_sfx = 1
		save_options("AUDIO OPTIONS", "SFX", audio_sfx)
		print("AVISO: EL JUEGO NO ESTABA EN UN SFX VALIDO")
	
	#carga la pantalla
	screen_mode = load_options("GRAPHICS OPTIONS", "Fullscreen")
	
	#carga el idioma y lo revisa
	languaje = load_options("LOCALIZATION OPTIONS","Languaje")
	if languaje != "es": #añadir más aquí si se añaden idiomas
		languaje = "es" #por si acaso alguien lo cambia en el archivo externo sin querer.
		save_options("LOCALIZATION OPTIONS","Languaje", languaje)
		print("AVISO: EL JUEGO NO ESTABA EN UN IDIOMA ADMINISTRADO")

#endregion
