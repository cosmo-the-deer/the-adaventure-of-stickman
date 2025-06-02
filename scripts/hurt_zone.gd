extends Area2D

# How much damage the zone deals per tick
@export var damage_amount := 10

# Tracks if the player is currently inside the damage zone
var player_in_zone := false

func _physics_process(delta: float) -> void:
	# Only apply damage if the player is inside the zone
	if player_in_zone:
		# Get the first overlapping body in the "Player" group
		var player = get_overlapping_bodies().filter(func(b): return b.is_in_group("Player")).front()
		
		if player:
			player.current_health -= damage_amount
			# Optionally: player.apply_knockback(self.position, 100)

func _on_body_entered(body: Node2D) -> void:
	# If the entering body is a player, flag them as inside the zone
	if body.is_in_group("Player"):
		player_in_zone = true

func _on_body_exited(body: Node2D) -> void:
	# If the exiting body is a player, flag them as outside
	if body.is_in_group("Player"):
		player_in_zone = false
