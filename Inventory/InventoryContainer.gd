extends Control

func _input(event):
	if event.is_action_pressed("ShowInventory"):
		get_tree().paused = !get_tree().paused
		visible = !visible
