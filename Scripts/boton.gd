class_name Boton extends Area2D

signal oprimido
signal suelto

var _cuerpos_encima: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("jugador") or body.is_in_group("Cajas"):
		if _cuerpos_encima == 0:
			oprimido.emit()
		_cuerpos_encima += 1

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("jugador") or body.is_in_group("Cajas"):
		_cuerpos_encima -= 1
		if _cuerpos_encima == 0:
			suelto.emit()
