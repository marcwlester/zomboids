
var points = {}
var factor = 1

func init():
	clean()

func clean():
	points = {}

func update(z):
	points[z.id] = z.get_pos()
	
func get_velocity(z):
	var c = Vector2(0,0)
	for i in points.keys():
		if (i != z.id):
			var diff = points[i] - z.get_pos()
			var size = z.size * 1.2
			if diff.length_squared() < (size*size):
				c = c - diff
	return c / factor