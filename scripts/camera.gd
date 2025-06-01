extends Camera2D

var target_zoom = Vector2()

func zoom_at_time(target_zoom: Vector2, duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", target_zoom, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
