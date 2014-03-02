
var points = {}
var tests = {}
var base_factor = 1

func init():
	clean()

func clean():
	points = {}

func update(z):
	points[z.id] = z.get_pos()
	if !tests.has(z.id):
		tests[z.id] = {}
	
func get_velocity(z):
	var factor = base_factor
	var c = Vector2(0,0)
	for i in points.keys():
		if (i != z.id):
			var diff = points[i] - z.get_pos()
			var size = z.size * 1
			var size2 = size * size
			var len = diff.length_squared()
			var test = size2 - len
			tests[z.id][i] = test
			if (z.id == 1):
				print(i,":", z.id, "-", test)
				
			#if diff.length_squared() < (size2):
			if test >= 0:
				c = c - diff
				var theta = deg2rad(90)
				var x = c.x
				var y = c.y
				var ct = cos(theta)
				var st = sin(theta)
				#c.x = x * ct - y * st
				#c.y = x * st - y * ct 
			
#			if test < 
			#print(i,": ",test)
			#if test > 1000:
			#	c = c - diff
			
			#if test > -(4096):
				#c = c - diff
				#var theta = deg2rad(180)
				#var x = c.x
				#var y = c.y
				#var ct = cos(theta)
				#var st = sin(theta)
				#c.x = x * ct - y * st
				#c.y = x * st - y * ct 
			
			#factor = 100
			#if (test < 1500):
			#	var theta = deg2rad(180)
			#	var x = c.x
			#	var y = c.y
			#	var ct = cos(theta)
			#	var st = sin(theta)
			#	c.x = x * ct - y * st
			#	c.y = x * st - y * ct
			#	factor = 1
			#elif (test < 1600):
			#	var theta = deg2rad(6)
			#	var x = c.x
			#	var y = c.y
			#	var ct = cos(theta)
			#	var st = sin(theta)
			#	factor = 10
			#elif (test < 2000):
			#	var theta = degtorad(3)
			#	var x = c.x
			#	var y = c.y
			#	var ct = cos(theta)
			#	var st = sin(theta)
			#	factor = 50
			
	return c / factor
	