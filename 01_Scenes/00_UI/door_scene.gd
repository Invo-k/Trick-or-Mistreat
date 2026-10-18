extends Control

@onready var background: TextureRect = %Background
@onready var character: TextureButton = %Character
@onready var shady_hands: TextureButton = %Shady_Hands
@onready var item_name_description: RichTextLabel = %ItemNameDescription
@onready var animator: AnimationPlayer = %Animator
@onready var arrow: TextureButton = %Arrow

@export_category("IMAGES")
@export var Characters_Array : Array[Texture2D]
@export var Characters_Array_Border : Array[Texture2D]
@export var Character_Bitmap : Array[BitMap]
@export var Backgrounds_Array : Array[Texture2D]


@export_category("TEXT")
@export var CHARACTER_NAME : Array[String]
@export var Hands_Description : String
@export var Dialogue_Stages : Array[DialogueResource]

@export_category("OST")
@export var Scene_Music : String

func _ready() -> void:
	prepare_scene()
	background.texture = GameValues.door_texture
	if !GameValues.is_candy_time:
		character.disabled = true
		arrow.disabled = true
	
	AudioManager.play_music(Scene_Music, 1.0)
	item_name_description.text = ""
	GameValues.change_item_name_description.connect(change_text_description)
	GameValues.candy_time_animation.connect(activate_candy_time)
	GameValues.next_dialogue.connect(show_new_dialogue)
	if !GameValues.first_dialogue:
		TransitionManager.transition_animator.play_backwards("Move_Left")
		await TransitionManager.transition_animator.animation_finished
		DialogueManager.show_dialogue_balloon(Dialogue_Stages[GameValues.actual_character_level], "start")
		GameValues.first_dialogue = true

func _on_character_pressed() -> void:
	DialogueManager.show_dialogue_balloon(Dialogue_Stages[GameValues.actual_character_level], "negociation")


func _on_shady_hands_pressed() -> void:
	DialogueManager.show_dialogue_balloon(Dialogue_Stages[0], "candy")

func _on_button_pressed() -> void:
	print("PULSÉ EL BOTÓN")
	TransitionManager.transition_animator.play("Move_Right")
	await TransitionManager.transition_animator.animation_finished
	get_tree().change_scene_to_file("res://01_Scenes/00_UI/game_scene.tscn")

func prepare_scene() -> void:
	background.texture = Backgrounds_Array[GameValues.actual_character_level]
	character.texture_normal = Characters_Array[GameValues.actual_character_level]
	character.texture_hover = Characters_Array_Border[GameValues.actual_character_level]
	character.texture_click_mask = Character_Bitmap[GameValues.actual_character_level]
	if GameValues.is_candy_time:
		shady_hands.show()
	else:
		shady_hands.hide()

func change_text_description(text : String):
	item_name_description.text = "[color=yellow]" + text + "[/color]"
	
func activate_candy_time():
	if !GameValues.is_candy_time:
		animator.play("Candy_t")
		GameValues.is_candy_time = true
		character.disabled = false
		arrow.disabled = false
		GameValues.door_texture = background.texture
	
	elif GameValues.is_candy_time:
		animator.play_backwards("Candy_t")
		GameValues.is_candy_time = false
		character.disabled = true
		arrow.disabled = true

func _on_character_mouse_entered() -> void:
	if GameValues.is_candy_time:
		GameValues.change_item_name_description.emit(CHARACTER_NAME[GameValues.actual_character_level])


func _on_shady_hands_mouse_entered() -> void:
	if GameValues.is_candy_time:
		GameValues.change_item_name_description.emit(Hands_Description)


func _on_character_hands_mouse_exited() -> void:
	GameValues.change_item_name_description.emit("")

func show_new_dialogue():
	await DialogueManager.dialogue_ended
	GameValues.actual_character_level += 1
	DialogueManager.show_dialogue_balloon(Dialogue_Stages[GameValues.actual_character_level], "start")
