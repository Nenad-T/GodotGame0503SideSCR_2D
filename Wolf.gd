extends KinematicBody2D

export var ACCELERATION = 400
export var MAX_SPEED = 500
export var FRICTION = 200
enum{
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var is_attacking = false
var geting_attacked = false

var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var stats = $Stats
onready var hurtbox = $HurtBox

func _ready():
	randomize()
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta * 2)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				get_new_state()
		
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				get_new_state()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= 4:
				get_new_state()
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				if in_range_of_player(player):
					velocity.x = 0
					is_attacking = true
					sprite.play("attack")
				else:
					is_attacking = false
			else:
				state = IDLE
		
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity.y += 200
	velocity = move_and_slide(velocity)
	if is_attacking == false:
		sprite.flip_h = velocity.x < 0
	if velocity.x != 0 and geting_attacked == false:
		sprite.play("run")
	elif is_attacking == false and geting_attacked == false:
		 sprite.play("idle")

func pick_random_state(state_list):
	#takes a list of posible states for the bat and shuffles them
	#and returns the first one
	state_list.shuffle()
	return state_list.pop_front()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func get_new_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	#to fase towards where its moving
	sprite.flip_h = velocity.x < 0

func _on_Stats_no_health():
	queue_free()

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.8)
#	knockback = -(global_position.direction_to(area.global_position)) * 1200
	var new_position = global_position
	if position.x > area.global_position.x:
		new_position.x += 500
	elif position.x < area.global_position.x:
		new_position.x -= 500
	$Tween.interpolate_property(self, 'position', global_position, new_position, 0.8, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_HitBox_area_entered(area):
#	state = ATTACK
	pass

func in_range_of_player(player):
	if global_position.distance_to(player.global_position) <= 200:
		return true
	return false


func _on_HurtBox_invincibility_started():
	sprite.modulate = Color(1.0, 0.0, 0.0)
	geting_attacked = true
	sprite.play("hurt")


func _on_HurtBox_invincibility_ended():
	sprite.modulate = Color(1.0, 1.0, 1.0)
	geting_attacked = false
