extends Node2D

var draggable : bool
var is_inside: bool
var body_ref : StaticBody2D

var tween : Tween
var offset:  Vector2
var initialPos : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !draggable:
		return
	
	if Input.is_action_just_pressed("left_click"):
		initialPos = global_position
		offset = get_global_mouse_position() - global_position
		ConfigManager.is_dragging = true

	if Input.is_action_pressed("left_click"):
		global_position = get_global_mouse_position() - offset
	elif Input.is_action_just_released("left_click"):
		ConfigManager.is_dragging = false
		if tween: tween.kill()
		tween = create_tween()
		if is_inside:
			tween.tween_property(self,"position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
		else:
			tween.tween_property(self,"global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
			await tween.finished
			queue_free()
		


func _on_area_2d_body_entered(body: StaticBody2D) -> void:
	if body.is_in_group("dropable"):
		is_inside = true
		body.color_rect.modulate = Color(0.0, 0.0, 0.0, 0.831)
		body_ref = body


func _on_area_2d_body_exited(body: StaticBody2D) -> void:
	if body.is_in_group("dropable"):
		is_inside = false
		body.color_rect.modulate = Color("ffffff77")
		body_ref = body


func _on_area_2d_mouse_entered() -> void:
	if !ConfigManager.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if !ConfigManager.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
