extends Area2D


@onready var random_pitch_audio: AudioStreamPlayer2D = $RandomPitchAudio

var can_be_picked_up := true

func _on_body_entered(body: Node2D) -> void:
	if can_be_picked_up:
		can_be_picked_up = false
		if body.name == "Player":
			self.visible = false
			random_pitch_audio.custiom_play()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
