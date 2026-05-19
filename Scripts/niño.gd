extends CharacterBody2D

const SPEED = 350.0
const JUMP = -500.

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var spawn_position: Vector2
@onready var Salto: AudioStreamPlayer = $SonidoSalto

func _ready() -> void:
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimiento horizontal
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Salto
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP
		Salto.play()

	# Animaciones
	if not is_on_floor():
		$AnimatedSprite2D.play("Saltar")
	elif direction != 0:
		$AnimatedSprite2D.play("Correr")
	else:
		$AnimatedSprite2D.play("default")

	# Flip según dirección
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction < 0

	move_and_slide()
	
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is RigidBody2D:
			var push_dir = col.get_normal() * -1
			col.get_collider().apply_central_impulse(push_dir * 200.0)

func morir() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
