extends AudioStreamPlayer2D

@export var min_pitch = 0.5
@export var max_pitch = 1.5

func custiom_play(from_position=0.0) -> void:
	
	randomize()
	self.pitch_scale = randf_range(min_pitch, max_pitch)
	self.play(from_position)
