
var components = {}

func add_component(name, c):
	components[name] = c
	
func get_component(name):
	return components[name]
	
func update(z):
	for name in components.keys():
		components[name].update(z)
		
func clean():
	for name in components.keys():
		components[name].clean()
		
func get_velocity(z):
	var v = Vector2(0,0)
	for name in components.keys():
		v += components[name].get_velocity(z)
		
	return v