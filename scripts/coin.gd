extends Area2D


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		self.visible = false
		audio_stream_player_2d.play()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
