extends StaticBody2D

@onready var color_rect: ColorRect = %ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.modulate = Color("ffffff77")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_dragging()

func is_dragging():
	if ConfigManager.is_dragging:
		color_rect.show()
	else:
		color_rect.hide()
