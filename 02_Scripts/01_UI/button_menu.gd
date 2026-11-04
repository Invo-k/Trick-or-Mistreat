extends TextureButton
class_name Button_Menu
var tween : Tween

var initial_scale : Vector2
@export var animation_scale : Vector2 = Vector2(1.05, 1.05)

func _ready() -> void:
	await get_tree().process_frame
	initial_scale = scale
	pivot_offset = size / 2.0
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_on_mouse_entered)
	focus_exited.connect(_on_mouse_exited)
	mouse_exited.connect(_on_mouse_exited)

func _on_button_down():
	if tween: tween.kill()
	scale = Vector2(initial_scale.x - 0.05, initial_scale.y - 0.05)
	
func _on_button_up():
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", initial_scale, 0.25)

func _on_mouse_exited():
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", initial_scale, 0.25)

func _on_mouse_entered():
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", animation_scale, 0.25)
	grab_focus()


func _gui_input(event): #Esta funcion es para cancelar la repetición de mantener pulsado algo y que se mueva infinitamente
	if event is InputEventKey and event.pressed and event.echo: 
		accept_event()

#func _on_pressed() -> void:
	#AudioController.play_sfx("res://00_Assets/SFX/woodTapHigh_001.ogg", randf_range(0.5, 1.0))
