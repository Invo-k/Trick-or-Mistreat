extends CanvasLayer

@onready var continue_button: Button = %Continue
@onready var options_button: Button = %Options
@onready var back_menu_button: Button = %BackMenu

func _ready() -> void:
	continue_button.grab_focus()

func _on_continue_pressed() -> void:
	GameValues.last_focus.grab_focus()


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_back_menu_pressed() -> void:
	pass # Replace with function body.


func _on_continue_focus_entered() -> void:
	pass # Replace with function body.
