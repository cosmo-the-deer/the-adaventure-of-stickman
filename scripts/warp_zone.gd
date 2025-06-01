extends Area2D

@export var scene: PackedScene
var is_player_in_zone = false

@onready var camera = get_tree().get_first_node_in_group("camera")

func _process(_delta: float) -> void:
	if is_player_in_zone and Input.is_action_just_pressed("interact_on"):
		camera.zoom_at_time(Vector2(8, 8), 2)
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(scene)
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_zone = true
		
		


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_zone = false
