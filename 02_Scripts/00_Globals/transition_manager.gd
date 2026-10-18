extends CanvasLayer

class_name Transition_Manager

@onready var transition_animator: AnimationPlayer = %Transition_Animator
@onready var transition_rect: ColorRect = %Transition_rect

func _on_transition_animator_animation_started(anim_name: StringName) -> void:
	transition_rect.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_transition_animator_animation_finished(anim_name: StringName) -> void:
	transition_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
