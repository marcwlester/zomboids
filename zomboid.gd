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
var delta = 0
var label = Label.new()
var dest_rect = Rect2(Vector2(0,0), Vector2(1,1))
var id
var brain = null
var font = Font.new()
var state = "roaming"
var chase_cooldown = 10.0 #seconds
var chase_cooldown_timer = 0.0

func set_brain(b):
	brain = b
	
func get_brain():
	return brain

func set_destination(d):
	destination = d
	if destination == null:
		dest_rect = null
	else:
		var r = d
		var s = get_zomb_size() * 2
		r.x -= s / 2
		r.y -= s / 2
		dest_rect = Rect2(r, Vector2(s,s))

	
func get_destination():
	return destination
	
func get_dest_rect():
	return dest_rect
	
func set_state(s):
	state = s
	
func get_state():
	return state
	
	
	
func get_zomb_size():
	return size
	
func get_velocity():
	if destination != null:
		var dir = destination - get_pos()
		var ndir = dir.normalized()
		return ndir * speed
		
	return Vector2(0,0)
	

func _ready():
	#set_process(true)
	#label.set_pos(Vector2(-16,-16))
	#add_child(label)
	pass
	
func init(d):
	delta = d
	var rand_roam = delta
	var rand_chase = delta
	#roam_speed = rand_roam * roam_speed
	#chase_speed = roam_speed + (rand_chase * chase_speed)
	
func enable_chase(d):
	if chase_cooldown_timer <= 0:
		chase_cooldown_timer = chase_cooldown
		state = "chasing"
		set_destination(d)
	
func update_brain():
	if brain != null:
		brain.update(self)
		
func process(delta):
	
	var pos = get_pos()
	
	
	if (state == "roaming"):
		speed = roam_speed
		
		#during roam we can cool down the chase timer
		if (chase_cooldown_timer > 0):
			chase_cooldown_timer -= delta
			
		if (destination == null):
			#pick a random spot around
			#var d = Vector2(pos.x + ((randf() * 20)-10), pos.y + ((randf() * 20)-10))
			var roam_dist = 128
			var half_roam_dist = roam_dist / 2
			var herd_vel = brain.get_component("herding").get_velocity(self)
			var d = Vector2(((randf() * roam_dist) - half_roam_dist), ((randf() * roam_dist) - half_roam_dist))
			d += get_pos()
			d += herd_vel
			set_destination(d)
		
		#var r = Rect2(destination, Vector2(size,size))
		if dest_rect != null:
			if (dest_rect.has_point(pos)):
				set_destination(null)
			
		var chase = brain.get_component("chasing").get_chase(self)
		if (chase != null):
			enable_chase(chase)
			
		
			
	elif (state == "chasing"):
		speed = chase_speed
		
		if dest_rect != null:
			if (dest_rect.has_point(pos)):
				set_destination(null)
				state = "roaming"
			
		#update()
	elif (state == "eating"):
		pass
	elif (state == "rock"):
		state = "rock"
		delta = 0
	else:
		state = "roaming"
	
	var vel = get_velocity()
	
	if (brain != null):
		var b_vel = Vector2(0,0)
		#b_vel += brain.get_component("spacing").get_velocity(self)
		#b_vel += brain.get_component("herding").get_velocity(self)
		b_vel += brain.get_velocity(self)
		vel += b_vel
	
		
	set_pos(pos + (vel * delta))
	var hi = brain.get_component("herding").get_herd_index(self)
	#label.set_text(str(id) + ": " + state + ": " + str(hi) + ":" + str(chase_speed) + ":" + str(roam_speed))
	#update()

	pass


func _draw():
	var hsize = size / 2
	var rect = Rect2(Vector2(-hsize, -hsize), Vector2(size, size))
	draw_rect(rect, color)
	#draw_dest_rect(hsize)
	draw_herd_center()
	#draw_herd_velocity()
	
	
func draw_dest_rect(hsize):
	#print("dest_rect",dest_rect,randf())
	#var p = get_pos() - dest_rect.pos
	#var r = Rect2(p, dest_rect.size)
	if dest_rect != null:
		var rp = dest_rect.pos
		rp -= get_pos()
		var r = Rect2(rp, dest_rect.size)
		draw_rect(r, Color(0,0,1))
		
func draw_herd_center():
	var hi = brain.get_component("herding").get_herd_index(self)
	if hi != null:
		var center = brain.get_component("herding").herds[hi].center
		draw_circle(center - get_pos(), 8, Color(0.6, 0.8, 0.4))
	
func draw_herd_velocity():
	var v = brain.get_component("herding").get_velocity(self)
	draw_line(get_pos(), v * 10, Color(0,1,0))
		
	
	