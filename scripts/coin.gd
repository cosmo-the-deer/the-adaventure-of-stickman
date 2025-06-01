extends Area2D


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var can_be_picked_up := true

func _on_body_entered(body: Node2D) -> void:
	if can_be_picked_up:
		can_be_picked_up = false
		if body.name == "Player":
			self.visible = false
			audio_stream_player_2d.play()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
