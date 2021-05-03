tool
extends Sprite


func _ready():
	pass


func _process(delta):
	#zoom changed e povikuvan sekoj frejm za sega,
	#treba da bide povikan samo koga ke ima promena bo zoomot na igrata
	zoom_changed()

func zoom_changed():
	material.set_shader_param("y_zoom", get_viewport().global_canvas_transform.y.y/4)
	

func _on_WaterReflection_item_rect_changed():
	material.set_shader_param("scale", scale)
