extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var hurt_sound_effect: AudioStreamPlayer2D = $HurtSoundEffect
@onready var death_sound_effect: AudioStreamPlayer2D = $DeathSoundEffect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var max_health = 100
var _current_health: int = max_health  # backing variable

signal health_changed

var coyote_jump := 0.0
var crl_locked := false

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
	set_locked(true)
	collision_shape.queue_free()
	velocity = Vector2(0, JUMP_VELOCITY)
	death_sound_effect.play()
	await get_tree().create_timer(1.2).timeout
	get_tree().reload_current_scene()

func apply_knockback(pos: Vector2, strength: int) -> void:
	#add hit animation
	var knockback_dir = (self.position - pos).normalized()
	velocity += knockback_dir * strength



# locks / unlocks all interaction
func set_locked(locked: bool):
	crl_locked = locked

func _physics_process(delta: float) -> void:

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not is_on_floor():
		animated_sprite.animation = "jump"
	else:
		var direction := Input.get_axis("move_left", "move_right")
		
		if not crl_locked and direction:
			velocity.x = direction * SPEED
			animated_sprite.animation = "move"
			animated_sprite.flip_h = direction < 0
		elif not crl_locked:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			animated_sprite.animation = "idle"

	
	# Coyote time
	if is_on_floor():
		coyote_jump = 0.5
	elif coyote_jump > 0:
		coyote_jump -= 0.1

	# Jump
	if Input.is_action_just_pressed("jump") and coyote_jump > 0 and not crl_locked:
		velocity.y = JUMP_VELOCITY
		coyote_jump = 0

	# Move left/right
	if not crl_locked:
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
