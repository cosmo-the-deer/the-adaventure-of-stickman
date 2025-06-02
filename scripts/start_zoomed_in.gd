extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().zoom = Vector2(8, 8)
	get_parent().zoom_at_time(Vector2(4, 4), 2)
	
