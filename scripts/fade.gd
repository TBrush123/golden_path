extends ColorRect


func fade_in(duration: float = 1.0):
	modulate.a = 0.0 
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	return tween
	
func fade_out(duration: float = 1.0):
	modulate.a = 1.0
	 
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	return tween
	
