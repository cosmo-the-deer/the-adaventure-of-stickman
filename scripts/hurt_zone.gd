extends Area2D

# How much damage the zone deals per tick
@export var damage_amount := 10

# Time (in seconds) between each damage tick
@export var damage_interval := 0.2

# Tracks if the player is currently inside the damage zone
var player_in_zone := false

# Timer that counts down to the next damage tick
var damage_timer := 0.0

func _physics_process(delta: float) -> void:
	# Only apply damage if the player is inside the zone
	if player_in_zone:
		# Decrease timer by time passed since last frame
		damage_timer -= delta
		
		# If timer reaches 0, deal damage and reset timer
		if damage_timer <= 0.0:
			# Get the first overlapping body in the "Player" group
			var player = get_overlapping_bodies().filter(func(b): return b.is_in_group("Player")).front()
			
			if player:
				player.current_health -= damage_amount

			# Reset timer
			damage_timer = damage_interval

func _on_body_entered(body: Node2D) -> void:
	# If the entering body is a player, flag them as inside the zone
	if body.is_in_group("Player"):
		player_in_zone = true

func _on_body_exited(body: Node2D) -> void:
	# If the exiting body is a player, flag them as outside and reset timer
	if body.is_in_group("Player"):
		player_in_zone = false
		damage_timer = 0.0
