
var chasing = {}

func init():
	clean()

func clean():
	avg_velocity = Vector2(0,0)

func update(z):
	chasing[z.id] = z.get_pos()
	
func get_velocity(z):
	return Vector2(0,0)
	
func get_chase(z):
	for i in points.keys():
		if (i != z.id):
			var diff = points[i] - z.get_pos()
			var size = z.size * 1
			var size2 = size * size
			var len = diff.length_squared()
			var test = size2 - len
				
			if test >= -4096:
				pass
	
