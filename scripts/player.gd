extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var hurt_sound_effect: AudioStreamPlayer2D = $HurtSoundEffect
@onready var death_sound_effect: AudioStreamPlayer2D = $DeathSoundEffect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var max_health = 100
var _current_health: int = max_health  # backing variable

signal health_changed

var coyote_jump := 0.0

var current_health: int:
	get:
		return _current_health
	set(value):
		if value < _current_health:
			hurt_sound_effect.play()
			
		_current_health = clamp(value, 0, max_health)
		health_changed.emit()
		if _current_health <= 0:
			die()

func die() -> void:
	velocity = Vector2.ZERO
	collision_shape.queue_free()
	velocity = Vector2(0, JUMP_VELOCITY)
	death_sound_effect.play()
	await get_tree().create_timer(2).timeout
	get_tree().reload_current_scene()

func apply_knockback(pos: Vector2, strength: int) -> void:
	velocity = self.position - pos * strength

func _physics_process(delta: float) -> void:

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Coyote time
	if is_on_floor():
		coyote_jump = 0.5
	elif coyote_jump > 0.1:
		coyote_jump -= delta

	# Jump
	if Input.is_action_just_pressed("jump") and coyote_jump > 0.1:
		velocity.y = JUMP_VELOCITY
		coyote_jump = 0

	# Move left/right
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
