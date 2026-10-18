extends Node2D

var draggable : bool
var is_inside: bool
var body_ref : StaticBody2D

var tween : Tween
var offset:  Vector2
var initialPos : Vector2
@onready var item_area: Area2D = %Item_Area
@onready var item_sprite: Sprite2D = %item_sprite
@export var item_id : String
@export var item_texture : AtlasTexture

func _ready() -> void:
	item_sprite.texture = item_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !draggable:
		return

	if Input.is_action_pressed("left_click"):
		global_position = get_global_mouse_position() - offset
	elif Input.is_action_just_released("left_click"):
		ConfigManager.is_dragging = false
		draggable = false
		if tween: tween.kill()
		if is_inside:
			ConfigManager.item_save = item_id
			print("SE AÑADIÓ EL ITEM: ", ConfigManager.item_save)
			# liberar el drop para que pueda entrar otro objeto
			body_ref.item_hold = null
			body_ref.color_rect.modulate = Color("ffffff77")
			queue_free()
		else:
			tween = create_tween()
			tween.tween_property(self,"global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
			await tween.finished
			queue_free()
		


func _on_area_2d_body_entered(body: StaticBody2D) -> void:
	if body.is_in_group("dropable"):
		if body.item_hold == null:
			is_inside = true
			body.color_rect.modulate = Color(0.0, 0.0, 0.0, 0.831)
			body_ref = body
			body.item_hold = self


func _on_area_2d_body_exited(body: StaticBody2D) -> void:
	if body.is_in_group("dropable"):
		if body.item_hold == self:
			is_inside = false
			body.color_rect.modulate = Color("ffffff77")
			body_ref = body
			body.item_hold = null


func _on_area_2d_mouse_entered() -> void:
	if !ConfigManager.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if !ConfigManager.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
