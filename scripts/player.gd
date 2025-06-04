extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var hurt_sound_effect: AudioStreamPlayer2D = $HurtSoundEffect
@onready var death_sound_effect: AudioStreamPlayer2D = $DeathSoundEffect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound_effect: AudioStreamPlayer2D = $JumpSoundEffect

@export var max_health = 100
var _current_health: int = max_health  # backing variable

signal health_changed

var coyote_jump := 0.0
var crl_locked := false
var move_locked := false
var iframe := 1.0

var immunity_time := 0.4 # seconds of immunity after being hit
var immunity_timer := 0.0

var flash_toggle := false
var flash_interval := 0.1 # seconds between flashes
var flash_timer := 0.0

var current_health: int:
	get:
		return _current_health
	set(value):
		if value < _current_health and immunity_timer <= 0.0:
			hurt_sound_effect.play()
			immunity_timer = immunity_time
			flash_timer = flash_interval
			flash_toggle = true
			animated_sprite.modulate = Color(1,1,1,0.2) # Start with flash color immediately
			# Start with normal modulate
			animated_sprite.modulate = Color(1,1,1,1)
			
			_current_health = clamp(value, 0, max_health)
			health_changed.emit()
			if _current_health <= 0:
				die()
		elif value >= _current_health:
			_current_health = clamp(value, 0, max_health)
			health_changed.emit()

func die() -> void:
	velocity = Vector2.ZERO
	crl_locked = true	
	collision_shape.queue_free()
	velocity = Vector2(0, JUMP_VELOCITY)
	death_sound_effect.play()
	var tree = get_tree()
	if tree:
		await tree.create_timer(1.2).timeout
		tree.reload_current_scene()

func apply_knockback(pos: Vector2, strength: int) -> void:
	#add hit animation
	var knockback_dir = (self.position - pos).normalized()
	velocity += knockback_dir * strength

func _physics_process(delta: float) -> void:
	if move_locked:
		velocity = Vector2(0, 0)
		animated_sprite.play("idle")
	
	
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
		jump_sound_effect.custiom_play()
		velocity.y = JUMP_VELOCITY
		coyote_jump = 0

	# Move left/right
	if not crl_locked:
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Immunity timer logic with improved white flash
	if immunity_timer > 0.0:
		immunity_timer -= delta
		flash_timer -= delta
		if flash_timer <= 0.0:
			flash_toggle = not flash_toggle
			if flash_toggle:
				animated_sprite.modulate = Color(1,1,1,1) # normal
			else:
				animated_sprite.modulate = Color(1,1,1,0.2) # transparent white flash
			flash_timer = flash_interval
		if immunity_timer <= 0.0:
			immunity_timer = 0.0
			animated_sprite.modulate = Color(1,1,1,1) # Restore sprite color

	move_and_slide()
