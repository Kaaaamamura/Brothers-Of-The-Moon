extends AnimationPlayer

func _ready():
	play("Intro")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Intro":
		get_tree().change_scene_to_file("res://Escenas/Mundo.tscn")
