extends Node2D

var player = null

@onready var music: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if Global.currentPlayer != null:
		player = Global.currentPlayer.instantiate()
		add_child(player)
		player.global_position = $Spawn.global_position
		player.spawn_position = $Spawn.global_position
		player.add_to_group("jugador")
		for enemigo in get_tree().get_nodes_in_group("Enemigos"):
			enemigo._jugador = player
			enemigo._persiguiendo = false
		$Camera2D.reparent(player)

	for palanca in get_tree().get_nodes_in_group("Palancas"):
		palanca.toggled.connect(_on_toggle)

	for boton in get_tree().get_nodes_in_group("Botones"):
		boton.oprimido.connect(_on_momentary_pressed)
		boton.suelto.connect(_on_momentary_released)

	for plataforma in get_tree().get_nodes_in_group("plataformas_estaticas"):
		plataforma.visible = false
		plataforma.get_node("CollisionShape2D").call_deferred("set", "disabled", true)

	for plataforma in get_tree().get_nodes_in_group("plataformas_mobiles"):
		plataforma.set_process(false)

	music.stream.loop = true
	music.play()

func _on_momentary_pressed() -> void:
	for plataforma in get_tree().get_nodes_in_group("plataformas_estaticas"):
		plataforma.visible = true
		plataforma.get_node("CollisionShape2D").call_deferred("set", "disabled", false)

func _on_momentary_released() -> void:
	for plataforma in get_tree().get_nodes_in_group("plataformas_estaticas"):
		plataforma.visible = false
		plataforma.get_node("CollisionShape2D").call_deferred("set", "disabled", true)

func _on_muerte(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body.morir()

func _on_toggle(active: bool) -> void:
	for plataforma in get_tree().get_nodes_in_group("plataformas_mobiles"):
		plataforma.set_process(active)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().call_deferred("reload_current_scene")
