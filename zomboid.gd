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

var font = Font.new()


var state = "roaming"

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
	pass
	
func set_dest_rect(rect):
	dest_rect = rect

func _ready():
	set_process(true)
	add_child(label)
	pass
	
func init(d):
	delta = d
	var rand_roam = delta
	var rand_chase = delta
	roam_speed = rand_roam * roam_speed
	chase_speed = rand_chase * chase_speed
	#print(rand_roam)
	#print(rand_chase)
	pass
	
func _process(delta):
	var pos = get_pos()
	if (state == "roaming"):
		speed = roam_speed
		if (destination == null):
			#pick a random spot around
			var d = Vector2(pos.x + (randf() * 20), pos.y + (randf() * 20))
			set_destination(d)
			dest_rect = Rect2(destination, Vector2(get_zomb_size(),get_zomb_size()))
		
		var r = Rect2(destination, Vector2(size,size))
		if (r.has_point(pos)):
			destination = null
	elif (state == "chasing"):
		speed = chase_speed
		
			
		if (destination == null):
			state = "roaming"
		#else:
		#	var r = Rect2(destination, Vector2(size,size))
		#	if (r.has_point(pos)):
		#		destination = null
	elif (state == "eating"):
		pass
	else:
		state = "roaming"
		
	#set_rot(get_rot() + delta)
	#update()
	#print(rule1*10)
	label.set_text(state)	
	#rotate towards the destination
	#print(speed)
	pass


func _draw():
	var hsize = size / 2
	var rect = Rect2(Vector2(-hsize, -hsize), Vector2(size, size))
	#draw_rect(rect, color)
	#draw_debug(hsize)
	#draw_state(hsize)
	#draw_dest_rect()
	
func draw_debug(hsize):
	draw_line(Vector2(-hsize, -hsize), Vector2(hsize, -hsize), Color(0,0,0), 4)
	draw_line(Vector2(0,0), rule1*10, Color(0,1,0), 2)
	draw_line(Vector2(0,0), rule2*10, Color(0,0,1), 2)
	draw_line(Vector2(0,0), get_velocity()*10, Color(0,1,1), 2)
	
func draw_state(hsize):
	#font.set_height(16)
	#draw_string(font, get_pos(), state)
	label.set_text(state)
	
func draw_dest_rect():
	draw_rect(dest_rect, Color(0,0,1))