extends Node2D

export (int) var wander_range = 64

onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer

func _ready():
	update_target_postion()

func update_target_postion():
	var target_vector = rand_range(-wander_range, wander_range)
	target_position.x = start_position.x + target_vector

func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)


func _on_Timer_timeout():
	update_target_postion()
