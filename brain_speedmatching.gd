
var avg_velocity = Vector2(0,0)
var factor = 8

func init():
	clean()

func clean():
	avg_velocity = Vector2(0,0)

func update(z):
	avg_velocity += z.get_velocity()
	
func get_velocity(z):
	return (avg_velocity) / factor
	