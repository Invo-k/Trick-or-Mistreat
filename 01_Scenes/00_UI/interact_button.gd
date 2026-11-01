extends Button

@onready var arrow_animator: AnimationPlayer = %arrow_animator
@onready var arrow_texture: TextureRect = %arrow_texture

func _ready() -> void:
	arrow_texture.hide()

func _on_mouse_entered() -> void:
	arrow_animator.play("arrow")
	arrow_texture.show()


func _on_mouse_exited() -> void:
	arrow_texture.hide()
	arrow_animator.stop()
