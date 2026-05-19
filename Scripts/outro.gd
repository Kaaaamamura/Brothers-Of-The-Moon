extends AnimationPlayer


func _ready():
	play("Outro")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Outro":
		get_tree().change_scene_to_file("res://Escenas/Menu Principal.tscn")
