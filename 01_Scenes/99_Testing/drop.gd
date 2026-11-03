extends StaticBody2D

@onready var color_rect: ColorRect = %ColorRect
var item_hold : Node2D

func _ready() -> void:
	color_rect.modulate = Color("ffffff00")


func _process(delta: float) -> void:
	is_dragging()

func is_dragging():
	if item_hold == null and ConfigManager.is_dragging:
		show()
	else:
		hide()
