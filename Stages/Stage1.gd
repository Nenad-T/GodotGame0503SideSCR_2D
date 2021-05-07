extends Node2D

# za da napravam da ima colision shape pod igracot samo i samo vo delot sto se gleda
#global position na Area2D da bide isto so global position na camerata a dolzinata na
#collisionshape2d da bide colisionshape2d scale.x isto so visiblerect.x
#no toa bi bilo problem koga nema da gi gleda kamerata drugite raboti ke pagaat
#eventualno ako ne se gledaat da nemaat collision
func _ready():
	$AudioStreamPlayer.play()
#func _input(event):
#	if Input.is_action_pressed("ui_down"):
#		$TreesAndMountains/debug_overlay.show()
