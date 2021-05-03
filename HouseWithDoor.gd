extends Node2D

export (String, FILE, "*.tscn") var target_stage

var is_player_inside = false

func _on_DoorArea_body_entered(body):
	if body.name == "Player":
		is_player_inside = true

func _input(event):
	if is_player_inside:
		if event.is_action_pressed("ui_up"):
			$DoorArea/AnimationPlayer.play("openDoor")

func _on_DoorArea_body_exited(body):
	if body.name == "Player":
		is_player_inside = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if get_tree().change_scene(target_stage) != OK:
		print ("An unexpected error occured when trying to switch scene")
