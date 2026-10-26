extends Node

signal change_item_name_description(String)
signal candy_time_animation
signal next_dialogue

##Para saber cual debería ser el focus anterior al borrar una escena.
var last_focus : Node
##Para detectar si al iniciar la escena de la puerta es necesario activar dialogo
var first_dialogue: bool
##Para decirle a la puerta que personaje cargar a continuación
var actual_character_level : int
##Para activar la animación del candy y algunas opciones
var is_candy_time : bool
##Fondo de la puerta
var door_texture : Texture2D = load("res://00_Assets/00_Sprites/00_Backgrounds/TOM_BocetoLocked.png")


##Cambia la transición
func change_scene_dialogue():
	TransitionManager.transition_animator.play("Move_Right")
	await TransitionManager.transition_animator.animation_finished
	get_tree().change_scene_to_file("res://01_Scenes/00_UI/main_menu.tscn")
