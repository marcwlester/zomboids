
var herds = {}
var herd_index = {}

var factor = 10

var threshold = 128

func init():
	clean()

func clean():
	herds = {}
	herd_index = {}
	
func new_herd(z):
	var n = herds.size()
	herds[n] = {
		sum = Vector2(0,0),
		center = Vector2(0,0),
		count = 0
	}
	add_to_herd(n, z)
	return n
	
func add_to_herd(n, z):
	herds[n].sum += z.get_pos()
	herds[n].count += 1
	herds[n].center = herds[n].sum / herds[n].count
	herd_index[z.id] = n

func update(z):
	if (herds.size() == 0):
		new_herd(z)
	else:
		var m = threshold*threshold
		var mid = null
		for i in herds:
			var c = herds[i].center
			var diff = c - z.get_pos()
			if (diff.length_squared() <= (m)):
				m = diff.length_squared()
				mid = i
				
		if mid != null:
			add_to_herd(mid, z)
		else:
			new_herd(z)
	
func get_velocity(z):
	if (herd_index.has(z.id)):
		var i = herd_index[z.id]
		var center = herds[i].center
		return (center - z.get_pos()) / factor
		
	return Vector2(0,0)
	
func get_herd_index(z):
	if herd_index.has(z.id):
		var i = herd_index[z.id]
		return i
		
	return null

