extends Area2D

@export var scene: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		await get_tree().create_timer(1.2).timeout
		get_tree().change_scene_to_packed(scene)
