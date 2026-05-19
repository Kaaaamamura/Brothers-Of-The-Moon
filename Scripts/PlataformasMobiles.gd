extends AnimatableBody2D

@export var speed: float = 80.0

var _target: Vector2
var _punto_a: Vector2
var _punto_b: Vector2
var _prev_position: Vector2

func _ready() -> void:
	_punto_a = $PuntoA.global_position
	_punto_b = $PuntoB.global_position
	_target = _punto_b
	_prev_position = global_position

func _process(delta: float) -> void:
	_prev_position = global_position
	var direction := (_target - global_position)

	if direction.length() <= 2.0:
		_target = _punto_a if _target == _punto_b else _punto_b
		return

	global_position += direction.normalized() * speed * delta

func get_delta_position() -> Vector2:
	return global_position - _prev_position
