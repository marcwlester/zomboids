
extends Node2D


const zomboid_instance = preload("zomboid.gd")
const zomherd_instance = preload("zomherd.gd")
const zomb_db_instance = preload("zomb_db.gd")
const zomb_brain_instance = preload("brain.gd")
const zomb_brain_herding_instance = preload("brain_herding.gd")
const zomb_brain_fragment_herding_instance = preload("brain_fragment_herding.gd")
const zomb_brain_spacing_instance = preload("brain_spacing.gd")
const zomb_brain_speedmatching_instance = preload("brain_speedmatching.gd")
const zomb_brain_chasing_instance = preload("brain_chasing.gd")

class Test1:
	extends Node2D
	
	func _draw():
		draw_circle(Vector2(0,0), 8, Color(0.5,0.5,0.5))
		pass


var zomb_db = zomb_db_instance.new()
var herd1 = zomherd_instance.new()

var brain1 = zomb_brain_instance.new()

var mouse_dragging = false

func _ready():
	# Initalization here
	set_process(true)
	set_process_input(true)
	#brain1.add_component("herding", zomb_brain_herding_instance.new())
	brain1.add_component("herding", zomb_brain_fragment_herding_instance.new())
	#brain1.add_component("spacing", zomb_brain_spacing_instance.new())
	brain1.add_component("chasing", zomb_brain_chasing_instance.new())
	#brain1.add_component("speedmatching", zomb_brain_speedmatching_instance.new())
	var sx = 2000
	var hsx = sx / 2
	for i in range(100):
		var zz = zomb_db.create_zomb(randf(), Vector2(randf()*sx-hsx, randf()*sx-hsx), brain1)
		add_child(zz)
	
	zomb_db.get_zomb(15).zomb.set_state("rock")
	
	get_node("camera").set_pos(Vector2(0,0))
	#get_node("camera").set_offset(Vector2(400,300))
	
	pass

func _process(d):
	var delta = d * 1
	brain1.clean()
	
	#update all the brains
	for index in zomb_db.get_keys():
		var z = zomb_db.get_zomb(index)
		if (z.active):
			z["zomb"].update_brain()
			
	#process based on brain state
	for index in zomb_db.get_keys():
		var z = zomb_db.get_zomb(index)
		if (z.active):
			z["zomb"].process(delta)
			
	#update()
	
	pass

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.pressed and event.button_index == 4): #the mouse wheel is scrolled up
			camera_zoom(-0.1)
		if (event.pressed and event.button_index == 5): #the mouse wheel is scrolled down
			camera_zoom(0.1)
		if (event.button_index == 1): #the left mouse button is clicked
			mouse_dragging = event.pressed #if the button is down, pressed is true
			#print(mouse_dragging)
		if (event.button_index == 2 and event.pressed):
			var pos = event.pos - get_node("camera").get_offset()
			var n = Test1.new()
			n.set_pos(pos)
			add_child(n)
			zomb_db.get_zomb(1).zomb.set_destination(pos)
			zomb_db.get_zomb(1).zomb.set_state("chasing")
	if (event.type == InputEvent.MOUSE_MOTION): #mouse move event
		if (mouse_dragging):
			print("here")
			camera_move(-event.relative_x, -event.relative_y)
	pass
	
func camera_move(x, y):
	var camera = get_node("camera")
	var pos = camera.get_offset()
	#var pos = camera.get_pos()
	var zoom = camera.get_zoom()
	pos.x -= (x * zoom.x)
	pos.y -= (y * zoom.y)
	camera.set_offset(pos)
	#camera.set_pos(pos)
	
func camera_zoom(amt):
	var camera = get_node("camera")
	var zoom = camera.get_zoom()
	zoom.x += amt
	zoom.y += amt
	camera.set_zoom(zoom)
	
func _draw():
	draw_circle(Vector2(0,0), 1, Color(1,1,1))
	draw_circle(zomb_db.get_zomb(15).zomb.get_pos(), 64, Color(1,1,1))
	draw_circle(zomb_db.get_zomb(15).zomb.get_pos(), 32, Color(1,0,1))
	pass
