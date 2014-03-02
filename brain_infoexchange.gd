var states = {}

func clean():
	pass
	
func update(z):
	states[z.id] = {
		pos = z.get_pos(),
		state = z.get_state()
	}
	pass
	
func get_velocity(z):
	return Vector2(0,0)
	
func get_exchange(z):
	pass

