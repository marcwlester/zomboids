
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

const zomboid_instance = preload("zomboid.gd")
const zomherd_instance = preload("zomherd.gd")
const zomb_db_instance = preload("zomb_db.gd")
const zomb_brain_instance = preload("brain.gd")
const zomb_brain_herging_instance = preload("brain_herding.gd")
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

func _ready():
	# Initalization here
	set_process(true)
	set_process_input(true)
	brain1.add_component("herding", zomb_brain_herging_instance.new())
	brain1.add_component("spacing", zomb_brain_spacing_instance.new())
	brain1.add_component("chasing", zomb_brain_chasing_instance.new())
	#brain1.add_component("speedmatching", zomb_brain_speedmatching_instance.new())
	
	#print(herd1)
	for i in range(20):
		#print(randf())
		#var z = zomboid_instance.new()
		#z.init(randf())
		#z.set_pos(Vector2(convert(randf()*1000, TYPE_INT) % 400, convert(randf()*1000, TYPE_INT) % 400))
		#print(convert(randf()*100, TYPE_INT))
		#add_child(z)
		#herd1.add_zomb(z)
		var zz = zomb_db.create_zomb(randf(), Vector2((convert(randf()*1000, TYPE_INT) % 400)-200, (convert(randf()*1000, TYPE_INT) % 400)-200), brain1)
		add_child(zz)
	
	zomb_db.get_zomb(15).zomb.set_state("rock")
	print(zomb_db.get_zomb(15).zomb.id)
	print(zomb_db.get_zomb(16).zomb.id)
	print(zomb_db.get_zomb(17).zomb.id)
	#print(herd1.get_center(herd1.zombs[0]))
	#herd1.set_destination(Vector2(0,0))
	get_node("camera").set_pos(Vector2(0,0))
	#get_node("camera").set_centered(true)
	get_node("camera").set_offset(Vector2(400,300))
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
			
	#herd1.process(delta)
	#print(delta)
	update()
	#get_node("camera").set_pos(herd1.get_herd_center())
	pass

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.pressed):
			var pos = event.pos - get_node("camera").get_offset()
			var n = Test1.new()
			n.set_pos(pos)
			add_child(n)
			zomb_db.get_zomb(1).zomb.set_destination(pos)
			zomb_db.get_zomb(1).zomb.set_state("chasing")
			#print(pos)
			#print(get_node("camera").get_camera_pos())
			#print(get_node("camera").get_offset())
			#print(get_node("camera").get_camera_screen_center())
			#herd1.set_destination(pos)
			#herd1.set_zombs_state("chasing")
	pass
	
func _draw():
	draw_circle(Vector2(0,0), 1, Color(1,1,1))
	draw_circle(brain1.get_component("herding").center, 16, Color(0, 0, 1))
	draw_circle(zomb_db.get_zomb(15).zomb.get_pos(), 64, Color(1,1,1))
	draw_circle(zomb_db.get_zomb(15).zomb.get_pos(), 32, Color(1,0,1))
	draw_line(zomb_db.get_zomb(1).zomb.get_pos(), brain1.get_component("spacing").get_velocity(zomb_db.get_zomb(1).zomb)*10, Color(0,0,0))
	#print(brain1.get_component("spacing").tests)
	pass
