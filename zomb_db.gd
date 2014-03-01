
const zomboid_instance = preload("zomboid.gd")

var zombs = {}
var zomb_inc = 0

func create_zomb(delta,pos, brain):
	zomb_inc += 1
	var z = zomboid_instance.new()
	z.init(delta)
	z.id = zomb_inc
	z.set_pos(pos)
	z.set_brain(brain)
	zombs[zomb_inc] = {
		zomb = z,
		active = true
	}

	return z
	
func get_zomb(index):
	return zombs[index]
	
func has_zomb(index):
	return zombs.has(index)
	pass
	
func delete_zomb(index):
	if (has_zomb(index)):
		zombs.erase(index)
	pass
	
func get_keys():
	return zombs.keys()