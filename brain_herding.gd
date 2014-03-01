
var sum = Vector2(0,0)
var center = Vector2(0,0)
var count = 0
var factor = 10

func init():
	clean()

func clean():
	center = Vector2(0,0)
	sum = Vector2(0,0)
	count = 0

func update(z):
	count += 1
	sum += z.get_pos()
	center = sum / count
	
func get_velocity(z):
	return (center - z.get_pos()) / factor
