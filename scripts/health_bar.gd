extends TextureProgressBar

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.health_changed.connect(update)
	update()

func update():
	print("current health: " + str(player.current_health))
	print("max health: " + str(player.max_health))
	self.value = player.current_health
	self.max_value = player.max_health
	print("updated health bar")
