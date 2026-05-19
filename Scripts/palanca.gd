extends Area2D

signal toggled(active: bool)

var _activo: bool = false
var _jugadorEncima: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("jugador") and not _jugadorEncima:
		_jugadorEncima = true
		_activo = !_activo
		toggled.emit(_activo)
		_update_sprite()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("jugador"):
		_jugadorEncima = false

func _update_sprite() -> void:
	if _activo:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
