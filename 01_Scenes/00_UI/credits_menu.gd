extends CanvasLayer

@onready var back: TextureButton = %Back
@onready var shura_button: Button = %Shura_Button
@onready var invo_button: Button = %Invo_Button
@onready var potion_k: Button = %Potion_K
@onready var info_left: RichTextLabel = %INFO_LEFT
@onready var info_right: RichTextLabel = %INFO_RIGHT

@export_category("PORTFOLIOS")
@export var Potion_K_porfolio : String
@export var Invo_porfolio : String
@export var Shura_porfolio : String
@export var Checherex_porfolio : String
@export_category("CREDITS")
@export_multiline() var Potion_K_Credits_Left : String
@export_multiline() var Potion_K_Credits_Right : String
@export_multiline() var Invo_Credits : String
@export_multiline() var Shura_Credits : String
@export_multiline() var Checherex_Credits : String

func _ready() -> void:
	clear_text()
	TransitionManager.transition_animator.play_backwards("menu_open")
	potion_k.grab_focus()
	await TransitionManager.transition_animator.animation_finished

func clear_text():
	info_left.text = ""
	info_right.text = ""

func _on_potion_k_focus_entered() -> void:
	info_left.text = tr(Potion_K_Credits_Left)
	info_right.text = tr(Potion_K_Credits_Right)

func _on_invo_button_focus_entered() -> void:
	info_right.text = tr(Invo_Credits)

func _on_shura_button_focus_entered() -> void:
	info_left.text = tr(Shura_Credits)

func _on_credits_button_focus_exited() -> void:
	clear_text()

#region Enlaces y Presiones de botones
func _on_potion_k_pressed() -> void:
	if Potion_K_porfolio != "":
		OS.shell_open(Potion_K_porfolio)

func _on_shura_button_pressed() -> void:
	if Shura_porfolio != "":
		OS.shell_open(Shura_porfolio)

func _on_invo_button_pressed() -> void:
	if Invo_porfolio != "":
		OS.shell_open(Invo_porfolio)

#endregion

func _on_back_pressed() -> void:
	TransitionManager.transition_animator.play("menu_open")
	await TransitionManager.transition_animator.animation_finished
	queue_free()
	TransitionManager.transition_animator.play_backwards("menu_open")
	GameValues.last_focus.grab_focus()
	GameValues.last_focus = null
