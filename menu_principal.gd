extends Control

@onready var buttons = [
	$Botones/Comenzar,
	$Botones/Opciones,
	$Botones/Salir
]

@onready var cursor = $Cursor

var index = 0
var can_input = true


func _ready():

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Cursor encima de todo
	cursor.z_index = 100

	can_input = false

	await get_tree().process_frame

	update_cursor()

	can_input = true


func _process(delta):

	# Cursor sigue al mouse
	cursor.global_position = get_global_mouse_position().round() + Vector2(8, 8)

	# Hover visual botones
	for i in range(buttons.size()):

		if i == index:
			buttons[i].scale = Vector2(1.05, 1.05)
		else:
			buttons[i].scale = Vector2(1, 1)


func _input(event):

	if !can_input:
		return


	if event.is_action_pressed("ui_down"):

		index = (index + 1) % buttons.size()

		update_cursor()

	elif event.is_action_pressed("ui_up"):

		index = (index - 1 + buttons.size()) % buttons.size()

		update_cursor()

	elif event.is_action_pressed("ui_accept"):

		select_option()


func update_cursor():

	var btn = buttons[index]

	# Posicionar cursor al lado izquierdo del botón
	cursor.global_position = btn.global_position + Vector2(-60, btn.size.y / 2 - 10)


func select_option():

	match index:

		0:
			_on_comenzar_pressed()

		1:
			_on_opciones_pressed()

		2:
			_on_salir_pressed()


func _on_comenzar_mouse_entered() -> void:

	index = 0

	update_cursor()


func _on_opciones_mouse_entered() -> void:

	index = 1

	update_cursor()


func _on_salir_mouse_entered() -> void:

	index = 2

	update_cursor()


func _on_comenzar_pressed() -> void:

	can_input = false

	get_tree().change_scene_to_file("res://Escenas/selector.tscn")



func _on_opciones_pressed() -> void:

	print("Abrir opciones")


func _on_salir_pressed() -> void:

	can_input = false

	$AnimationPlayer.play("exit_game")

	get_tree().quit()
