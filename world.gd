
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

const zomboid_instance = preload("zomboid.gd")
const zomherd_instance = preload("zomherd.gd")

var herd1 = zomherd_instance.new()

func _ready():
	# Initalization here
	set_process(true)
	set_process_input(true)
	#print(herd1)
	for i in range(10):
		#print(randf())
		var z = zomboid_instance.new()
		z.init(randf())
		z.set_pos(Vector2(convert(randf()*1000, TYPE_INT) % 400, convert(randf()*1000, TYPE_INT) % 400))
		#print(convert(randf()*100, TYPE_INT))
		add_child(z)
		herd1.add_zomb(z)
		
	#print(herd1.get_center(herd1.zombs[0]))
	#herd1.set_destination(Vector2(0,0))
	get_node("camera").set_pos(Vector2(0,0))
	pass

func _process(delta):
	herd1.process(delta)
	update()
	#get_node("camera").set_pos(herd1.get_herd_center())

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.pressed):
			var pos = Vector2(event.x, event.y) + get_node("camera").get_camera_pos()
			#print(pos)
			#print(get_node("camera").get_camera_pos())
			#print(get_node("camera").get_offset())
			#print(get_node("camera").get_camera_screen_center())
			herd1.set_destination(pos)
			herd1.set_zombs_state("chasing")
	pass
	
func _draw():
	for z in herd1.zombs:
		_draw_zomb(z)
		#_draw_dest_rect(z)
		
	_draw_dest_rect_herd(herd1)
	pass
	
	
func _draw_zomb(z):
	var hsize = z.size / 2
	var rect = Rect2(Vector2(z.get_pos().x-hsize, z.get_pos().y-hsize), Vector2(z.size, z.size))
	draw_rect(rect, z.color)
	
func _draw_dest_rect(z):
	draw_rect(z.dest_rect, Color(0,0,1))
	
func _draw_dest_rect_herd(herd):
	draw_rect(herd.dest_rect, Color(0,0,1))