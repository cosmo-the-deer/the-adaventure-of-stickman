extends Area2D

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		player.current_health = 0
