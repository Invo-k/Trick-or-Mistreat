##Este es el Script del Controlador de Audio creado por Pedro Reimundez. [br][br]Se puede emplear tanto para Musica como para cualquier otro tipo de sonido de manera global, siempre que se añadan sus respectivos nodos y Buses de Audio mediante codigo.

extends Node
class_name Audio_Controller

## Variable de tipo [AudioSteamPlayer] que añade directamente al juego un StreamPlayer de la musica cuando este es ejecutado. [br][br]Esta variable se encarga de recibir rutas de audio desde los archivos del proyecto para reproducirlos empleando funciones, optimizando el proceso de reproducción de canciones simplificando su carga a una a la vez en todo momento.[br][br]Tiene el bus en "Music" y hereda del bus "Master".
var music = AudioStreamPlayer.new()
##OPCIONAL. [br][br]Variable de tipo [AudioSteamPlayer]e que añade un StreamPlayer para los SFX de la UI cuando el juego es ejecutado. [br][br]El motivo detrás de esta variable es sencillo, evitar cargar y reproducir multiples efectos de sonido al mismo tiempo cuando se usan menús, reduciendo su carga de procesado a unicamente el momento que sea necesario reproducir dicho efecto sonoro.[br][br]Tiene el bus en "SFX" y hereda del bus "Master".
var ui_sfx = AudioStreamPlayer.new()

##Variable que almacena e indica que ruta de música de tipo [String] debe reproducirse en todo momento por el [Audio_Controller]. [br][br]Puede cambiarse en todo momento sin problema.
var _level_music = null

##OPCIONAL. [br][br] Variable que almacena e indica que ruta de SFX de tipo [String] debe reproducirse en todo momento por el [sfx_controller]. [br][br]Puede cambiarse en todo momento sin problema.
var _level_sfx = null

##Variable que almacena el valor en [float] del volumen con el que se reproduce la música del [Audio_Controller]. [br][br]Este valor luego se restaría al valor del Bus pertinente.
var _volume_music: float = 0.0

##OPCIONAL. [br][br]## Variable que almacena el valor en [float] del volumen con el que se reproduce los SFX del [Audio_Controller].
var _volume_sfx: float = 0.0


##Función Ready del Controlador de Audio que genera 2 [AudioStreamPlayer] desde codigo. [br][br]Además de añadir los buses [bus = "Music"] y [bus = "SFX], es necesario indicar que el [process_mode = Node.PROCESS_MODE_ALWAYS] si el juego va a recibir un boton de pausa, ya que de esta forma se reproducirá aunque el juego esté bloqueado.
func _ready() -> void:
	#genera desde codigo el stream player de la musica
	add_child(music)
	music.bus = "Music"
	music.process_mode = Node.PROCESS_MODE_ALWAYS
	music.name = "Global_Music"
	#genera desde codigo el stream player del sfx
	add_child(ui_sfx)
	ui_sfx.bus = "SFX"
	ui_sfx.process_mode = Node.PROCESS_MODE_ALWAYS
	ui_sfx.name = "UI_SFX"

#region Musica

##Carga y ejecuta la canción que tenga como ruta. Esta función carga la canción almacenada dentro de los (), la selecciona como siguiente canción a reproducir y la activa al mismo tiempo. [br][br]Se usa principalmente en las funciones ready de cada escena. [br][br]La ruta de la canción que debe haber entre parentesis debe ser de tipo [String]
func play_music(ost : String, pitch : float):
	if ost != "":
		var musica = load(ost)
		_select_music(musica, pitch)
		_play_music_level()
	if ost == "":
		printerr("NO HAS PUESTO LA RUTA DE AUDIO O NO ESTÁ RECIBIENDO NINGUNA RUTA")

##Carga y ejecuta el sfx que tenga como ruta.
func play_sfx(sound : String):
	if sound != "":
		var sfx = load(sound)
		_select_sfx(sfx)
		_play_sfx_level()
	if sound == "":
		printerr("NO HAS PUESTO LA RUTA DE AUDIO O NO ESTÁ RECIBIENDO NINGUNA RUTA")


##Esta función se emplea para almacenar una nueva ruta de Audio. Cambia el valor de la variable [level_music] por la nueva ruta de audio. [br][br]Se emplea siempre antes de la función [play_music()]
func _select_music(musica, pitch : float):
	_level_music = musica
	music.pitch_scale = pitch

##Esta función es una operación intermedia que no es necesaria usar en ningún momento, ya que existe otra función que la llama de forma correcta: [play_music_level()]. [br][br]Una vez seleccionada la musica, detiene la anterior y reproduce la nueva canción, siempre y cuando no sea la misma que ya estaba sonando en ese mismo instante. [br]De ser ese el caso, la canción sigue reproduciendose como si no se hubiese efectuado la operación. 
func _play_music(ost: AudioStream, volume = _volume_music):
	if music.stream == ost:
		return
	music.stream = ost
	music.volume_db = volume
	music.play()

## Esta funcion se usa justo después de emplear la función [select_music()]. [br][br]Emplea la función [play_music()] para activar la canción del nivel, pero solo lo hace si se ha seleccionado una canción antes. [br]Si no es el caso, ignora la operación.
func _play_music_level():
	if _level_music != null:
		_play_music(_level_music)

##Al igual que [play_music_level()], detiene la canción del nivel reproduciendo otra funcion llamada [stop_music()].
func stop_music_level():
	if _level_music != null:
		_stop_music(_level_music)

##Esta función es una operación intermedia que no es necesaria usar en ningún momento, ya que existe otra función que la llama de forma correcta: [stop_music_level()]. [br][br]Antes de detener la musica, reduce un poco su volumen durante unos segundos antes de detenrse.
func _stop_music(ost: AudioStream, volume = -4):
	if music.stream == ost:
		music.volume_db = volume
		await get_tree().create_timer(0.2).timeout
		music.stop()

#endregion

#region SFX

##Esta función se emplea para almacenar una nueva ruta de Audio. Cambia el valor de la variable [_level_sfx] por la nueva ruta de audio. [br][br]Se emplea siempre antes de la función [play_sfx()]
func _select_sfx(sfx : String):
	_level_sfx = load(sfx)
	

##Esta función es una operación intermedia que no es necesaria usar en ningún momento, ya que existe otra función que la llama de forma correcta: [play_sfx_level()]. [br][br]Una vez seleccionado el sonido, detiene la anterior y reproduce el nuevo, siempre y cuando no sea el mismo que ya estaba sonando en ese mismo instante.
func _play_sfx(sfx: AudioStream, volume = _volume_sfx):
	ui_sfx.stream = sfx
	ui_sfx.volume_db = volume
	ui_sfx.play()

## Esta funcion se usa justo después de emplear la función [select_sfx()]. [br][br]Emplea la función [play_sfx()] para activar la canción del nivel, pero solo lo hace si se ha seleccionado una canción antes.
func _play_sfx_level():
	if _level_sfx != null:
		_play_sfx(_level_sfx)

#endregion
