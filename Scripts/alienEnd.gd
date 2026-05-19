extends CharacterBody2D

@export var VelPatrullar: float = 60.0
@export var VelPerseguir: float = 120.0
@export var distancia_deteccion: float = 200.0
@export var distancia_patrulla: float = 100.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direccion: float = 1.0
var _persiguiendo: bool = false
var _jugador: Node2D = null
var _origen_x: float


func _ready() -> void:
	_origen_x = global_position.x
	$AreaDeteccion.body_entered.connect(_on_jugador_tocado)

func _physics_process(delta: float) -> void:
	# Gravedad
	velocity.y += gravity * delta

	# Detectar jugador por distancia
	if _jugador != null:
		var dist = global_position.distance_to(_jugador.global_position)
		if dist < distancia_deteccion:
			_persiguiendo = true
		else:
			_persiguiendo = false

	if _persiguiendo and _jugador != null:
		_perseguir()
	else:
		_patrullar()
		
	sprite.flip_h = _direccion > 0

	move_and_slide()

	# Invertir dirección al chocar con pared
	if is_on_wall():
		_direccion *= -1.0

func _patrullar() -> void:
	velocity.x = VelPatrullar * _direccion
	var dist: float = global_position.x - _origen_x
	if dist > distancia_patrulla:
		_direccion = -1.0
	elif dist < -distancia_patrulla:
		_direccion = 1.0

func _perseguir() -> void:
	var diff: float = _jugador.global_position.x - global_position.x
	_direccion = sign(diff)
	velocity.x = VelPerseguir * _direccion
	
func _on_jugador_tocado(body: Node) -> void:
	if body.is_in_group("jugador"):
		get_tree().change_scene_to_file("res://Escenas/outro.tscn")
