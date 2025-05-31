extends ProgressBar

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.health_changed.connect(update)
	update()

func update():
	print("Health changed to: " + str(player.current_health))
	self.value = player.current_health
