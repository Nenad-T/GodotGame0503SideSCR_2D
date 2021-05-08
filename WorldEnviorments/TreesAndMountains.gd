extends ParallaxBackground

func _ready():
	$Close/Sprite.position.y = get_viewport().size.y / 2
	$Near/Sprite.position.y = get_viewport().size.y / 2.2
	$ParallaxLayer2/Sprite.position.y = get_viewport().size.y / 2.4
	$ParallaxLayer3/Sprite.position.y = get_viewport().size.y / 2.6
	$ParallaxLayer4/Sprite.position.y = get_viewport().size.y / 2.8
