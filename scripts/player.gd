extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var death_sound_effect: AudioStreamPlayer2D = $DeathSoundEffect

@export var max_health = 100
var _current_health: int = max_health  # backing variable

signal health_changed

var current_health: int:
	get:
		return _current_health
	set(value):
		_current_health = clamp(value, 0, max_health)
		health_changed.emit()
		print("Health set to:", _current_health)

var coyote_jump := 0.0

func die() -> void:
	print("player died — current health: " + str(current_health))
	current_health = 0  # optional, already 0 usually
	death_sound_effect.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
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

func _on_death_sound_effect_finished() -> void:
	get_tree().reload_current_scene()
