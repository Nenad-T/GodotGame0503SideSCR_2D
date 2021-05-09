extends KinematicBody2D

enum{
	IDLE,
	MOVE,
	DASH,
	ATTACK
}

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var playerStats = PlayerStats
onready var hurtbox = $HurtBox
onready var attackSound = $AttackSound

export (String, FILE, "*.tscn") var game_over_screen
export var Speed = 800
export var Jumpforce = -3000
export var Gravity = 100

var velocity = Vector2.ZERO
var isAbleToMove = true
var state = IDLE


func _ready():
	print(playerStats.health)
	playerStats.connect("no_health", self, "no_health")
	$HitboxPivot/HitBox/CollisionShape2D.disabled = true
	hurtbox.monitorable = true
	hurtbox.monitoring = true

func _physics_process(delta):
	velocity.y += Gravity
	move()
	get_user_input()
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state()
		DASH:
			dash_state()
		ATTACK:
			attack_state()

func move():
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.3)

func move_state():
	move()
	animationPlayer.play("Move")

func attack_state():
	isAbleToMove = false
	animationPlayer.play("Attack")
	attackSound.play()

func dash_state():
	isAbleToMove = false
	if sprite.flip_h:
		sprite.offset.x = -600
	else:
		sprite.offset.x = 600
	animationPlayer.play("Dash")

func jump_state():
	if is_on_floor():
		velocity.y = Jumpforce

func idle_state():
	animationPlayer.play("Idle")

func _on_HurtBox_area_entered(area):
	playerStats.health -= area.damage
	hurtbox.start_invincibility(0.8)
	print(playerStats.health)

func get_user_input():
	if isAbleToMove:
		if Input.is_action_pressed("ui_right"):
			state = MOVE
			sprite.flip_h = false
			$HitboxPivot/HitBox.rotation_degrees = 180
			velocity.x = Speed
		elif Input.is_action_just_released("ui_right"):
			state = IDLE
		if Input.is_action_pressed("ui_left"):
			state = MOVE
			sprite.flip_h = true
			$HitboxPivot/HitBox.rotation_degrees = 0
			velocity.x = -Speed
		elif Input.is_action_just_released("ui_left"):
			state = IDLE
		if Input.is_action_pressed("ui_select"):
			state = DASH
		if Input.is_action_just_pressed("attack"):
			state = ATTACK

func _on_AnimationPlayer_animation_finished(anim_name):
	state = IDLE
	if(anim_name == "Attack"):
		isAbleToMove = true
		velocity = velocity * 0.8
	if(anim_name == "Dash"):
		sprite.offset.x = 0
		if sprite.flip_h:
			global_position.x -= 200
		else:
			global_position.x += 200
		$Camera2D.position.x = 0
		isAbleToMove = true


func _on_HurtBox_invincibility_started():
	sprite.modulate = Color(1.0, 0.0, 0.0)


func _on_HurtBox_invincibility_ended():
	sprite.modulate = Color(1.0, 1.0, 1.0)

func no_health():
	playerStats.health = playerStats.max_health
	if get_tree().change_scene(game_over_screen) != OK:
		print ("An unexpected error occured when trying to switch scene")

func show_inventory():
	get_tree().paused = !get_tree().paused
	$Inventory/InventoryContainer.visible = !$Inventory/InventoryContainer.visible
