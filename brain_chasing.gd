
var chasing = {}

func init():
	clean()

func clean():
	chasing = {}

func update(z):
	if (z.get_state() == "chasing"):
		chasing[z.id] = {
			pos = z.get_pos(),
			destination = z.get_destination()
		}
	
func get_velocity(z):
	return Vector2(0,0)
	
func get_chase(z):
	var closest = -4096
	var chase = null
	for i in chasing.keys():
		if (i != z.id):
			var diff = chasing[i].pos - z.get_pos()
			var size = z.size * 1
			var size2 = size * size
			var len = diff.length_squared()
			var test = size2 - len
				
			if test >= closest:
				closest = test
				chase = chasing[i].destination
				pass
				
	return chase
	
