#
#  roaming -> chasing -> eating
#
#
#

extends Node2D

var color = Color(1.0, 0, 0)
var size = 32
var destination = null
var speed = 40
var chase_speed = 40
var roam_speed = 20
var rule1 = Vector2(0,0)
var rule2 = Vector2(0,0)
var delta = 0
var label = Label.new()
var dest_rect = Rect2(Vector2(0,0), Vector2(1,1))
var id
var brain = null
var font = Font.new()
var state = "roaming"

func set_brain(b):
	brain = b
	
func get_brain():
	return brain

func set_destination(d):
	destination = d
	pass
	
func get_destination():
	return destination
	
func set_state(s):
	state = s
	
func set_rule1(r):
	rule1 = r
	
func set_rule2(r):
	rule2 = r
	
func get_zomb_size():
	return size
	
func get_velocity():
	if destination != null:
		var dir = destination - get_pos()
		var ndir = dir.normalized()
		return ndir * speed
		
	return Vector2(0,0)
	
func set_dest_rect(rect):
	dest_rect = rect

func _ready():
	#set_process(true)
	label.set_pos(Vector2(-16,-16))
	add_child(label)
	
func init(d):
	delta = d
	var rand_roam = delta
	var rand_chase = delta
	roam_speed = rand_roam * roam_speed
	chase_speed = rand_chase * chase_speed
	
func update_brain():
	if brain != null:
		brain.update(self)
		
func process(delta):
	
	var pos = get_pos()
	var vel = get_velocity()
	if (state == "roaming"):
		speed = roam_speed
		if (destination == null):
			#pick a random spot around
			#var d = Vector2(pos.x + ((randf() * 20)-10), pos.y + ((randf() * 20)-10))
			var d = Vector2(((randf() * 20)-10), ((randf() * 20)-10))
			set_destination(d)
			dest_rect = Rect2(destination, Vector2(get_zomb_size(),get_zomb_size()))
		
		var r = Rect2(destination, Vector2(size,size))
		if (r.has_point(pos)):
			destination = null
			dest_rect = Rect2(Vector2(0,0), Vector2(1,1))
			
		if (brain != null):
			var b_vel = Vector2(0,0)
			b_vel += brain.get_component("spacing").get_velocity(self)
			vel += b_vel
	elif (state == "chasing"):
		speed = chase_speed
		var r = Rect2(destination, Vector2(size,size))
			
		if (brain != null):
			var b_vel = Vector2(0,0)
			b_vel += brain.get_component("spacing").get_velocity(self)
			vel += b_vel
		if (r.has_point(pos)):
			destination = null
			
		if (destination == null):
			state = "roaming"
			
		update()
	elif (state == "eating"):
		pass
	elif (state == "rock"):
		state = "rock"
		delta = 0
	else:
		state = "roaming"
	
	
	
		
	set_pos(pos + (vel * delta))
		
	label.set_text(str(id) + ": " + state)
	#update()

	pass


func _draw():
	var hsize = size / 2
	var rect = Rect2(Vector2(-hsize, -hsize), Vector2(size, size))
	draw_rect(rect, color)
	#draw_debug(hsize)
	#draw_dest_rect(hsize)
	
func draw_debug(hsize):
	draw_line(Vector2(-hsize, -hsize), Vector2(hsize, -hsize), Color(0,0,0), 4)
	draw_line(Vector2(0,0), rule1*10, Color(0,1,0), 2)
	draw_line(Vector2(0,0), rule2*10, Color(0,0,1), 2)
	draw_line(Vector2(0,0), get_velocity()*10, Color(0,1,1), 2)
	
func draw_dest_rect(hsize):
	#print("dest_rect",dest_rect,randf())
	#var p = get_pos() - dest_rect.pos
	#var r = Rect2(p, dest_rect.size)
	var r = dest_rect
	r.pos.x -= hsize
	r.pos.y -= hsize
	draw_rect(r, Color(0,0,1))
	if destination != null:
		#print(destination)
		draw_rect(Rect2(destination, Vector2(size,size)), Color(0,1,0))
	