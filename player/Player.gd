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
var is_attacking = false
var state = IDLE


func _ready():
	print(playerStats.health)
	playerStats.connect("no_health", self, "no_health")
	$HitboxPivot/HitBox/CollisionShape2D.disabled = true

func _physics_process(delta):
	velocity.y += Gravity
	move()
	get_user_input()
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state(delta)
		DASH:
			dash_state()
		ATTACK:
			attack_state()

func move():
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.3)

func move_state(delta):
	move()
	animationPlayer.play("Move")

func attack_state():
	is_attacking = true
	animationPlayer.play("Attack")
	attackSound.play()

func dash_state():
	pass

func jump_state():
	if is_on_floor():
		velocity.y = Jumpforce

func idle_state():
	animationPlayer.play("Idle")

func _on_HurtBox_area_entered(area):
	playerStats.health -= area.damage
	hurtbox.start_invincibility(0.8)

func get_user_input():
	if !is_attacking:
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
		if Input.is_action_just_pressed("ui_select"):
			if is_on_floor():
				velocity.y = Jumpforce
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
#		if Input.is_action_just_pressed("ShowInventory"):
#			show_inventory()

func _on_AnimationPlayer_animation_finished(anim_name):
	state = IDLE
	if(anim_name == "Attack"):
		is_attacking = false
		velocity = velocity * 0.8


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
