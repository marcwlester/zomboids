#extends Node2D

var zombs = []
var destination = null#Vector2(0,0)
var dest_rect_size = 0
var dest_rect = Rect2(Vector2(0,0), Vector2(1,1))
var dest_pop = 0

func _init():
	zombs = []

func add_zomb(zomb):
	zombs.push_back(zomb)
	
func set_destination(v):
	destination = v
	dest_pop = 0
	dest_rect = Rect2(Vector2(0,0), Vector2(1,1))
	for z in zombs:
		dest_rect = Rect2(destination, Vector2(z.get_zomb_size()*(1+dest_pop),z.get_zomb_size()*(1+dest_pop)))
		z.set_dest_rect(dest_rect)
		z.set_destination(destination)
		
		
		
func set_zombs_state(s):
	for z in zombs:
		z.set_state(s)
	
func get_center(zomb):
	var center = Vector2(0,0)
	for z in zombs:
		if (z != zomb):
			center += z.get_pos()
	center /= (zombs.size() - 1)
	
	return center
	
func get_herd_center():
	var center = Vector2(0,0)
	for z in zombs:
		center += z.get_pos()
	center /= (zombs.size())
	
	return center
	
# move towards center of mass
func rule1(zomb):
	var center = get_center(zomb)
	return (center - zomb.get_pos()) / 100
	
#keep your distance
func rule2(zomb):
	var c = Vector2(0,0)
	
	for z in zombs:
		if (z != zomb):
			var diff = z.get_pos() - zomb.get_pos()
			if diff.length_squared() < (z.size*z.size):
				c = c - diff
				
	return c
	
#returns match velocity of others
#returns fastest velocity of herd
func rule3(zomb):
	var pv = Vector2(0,0)
	var fastest = Vector2(0,0)
	
	for z in zombs:
		if (z != zomb):
			pv = pv + z.get_velocity()
			if z.get_velocity() > fastest:
				fastest = z.get_velocity()
			
	pv /= (zombs.size() - 1)
	
	return (pv - zomb.get_velocity()) / 8
	#return fastest
	
func process(delta):
	for z in zombs:
		var v1 = rule1(z)
		var v2 = rule2(z)
		var v3 = rule3(z)
		var pos = z.get_pos()
		var change = (z.get_velocity() + v1 + v2 + v3) * delta
		z.set_pos(pos + change)
		if (destination != null and z.get_destination() == destination):
			var vec = Vector2(z.get_zomb_size()*(1+dest_pop),z.get_zomb_size()*(1+dest_pop))
			var hvec = vec / 2
			dest_rect = Rect2(destination - hvec, vec)
			z.set_dest_rect(dest_rect)
			if (dest_rect.has_point(z.get_pos())):
				dest_pop += 1
				z.set_destination(null)
				#print(dest_pop)
		if (dest_pop == zombs.size()):
			destination = null
			dest_pop = 0
			dest_rect = Rect2(Vector2(0,0), Vector2(1,1))
				
		z.set_rule1(v1)
		z.set_rule2(v2)