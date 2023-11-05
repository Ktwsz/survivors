extends CharacterBody2D

var direction : Vector2
var isFlipped : bool = false
@export var isHitOnCooldown : bool = false
@export var isDying : bool = false

@export var speed = 300
@export var damage = 1
@export var health = 10
@export var maxHealth = 10
var experience : int = 0
var experienceMax : int = 100
var expLevel : int = 1

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var root = get_node("/root/Level")
@onready var healthBar = $Sprite2D/HealthBar
@onready var weaponManager = $WeaponManager

func move() -> bool:
	sprite.set_flip_h(isFlipped or direction.x < 0)
	if direction.x != 0: isFlipped = direction.x < 0
	velocity = speed * direction
	animPlayer.play("walk")
	return move_and_slide()
	
func animationClear():
	animPlayer.play("RESET")


func setDirection() -> bool:
	var newDirection = Vector2(0, 0)
	var isInputPressed = false
	if Input.is_action_pressed("walk_left"): 
		newDirection.x -= 1
		isInputPressed = true
	if Input.is_action_pressed("walk_right"): 
		newDirection.x += 1
		isInputPressed = true
	if Input.is_action_pressed("walk_up"): 
		newDirection.y -= 1
		isInputPressed = true
	if Input.is_action_pressed("walk_down"): 
		newDirection.y += 1
		isInputPressed = true
		
	if isInputPressed: direction = newDirection
	return isInputPressed

func _physics_process(delta):
	if isDying or isHitOnCooldown: return
	var isInputPressed = setDirection()
	if not isInputPressed: animationClear()
	else: move()

func hit(dmg) -> void:
	if isDying or isHitOnCooldown: return
	
	health -= dmg
	healthBarUpdate()

	if health > 0:
		animPlayer.play("hit")
	else:
		die()
		
func healthBarUpdate():
	healthBar.value = (100.0 * float(health))/float(maxHealth)
	print((100.0 * health)/maxHealth)

func die() -> void:
	animPlayer.play("die")
	await animPlayer.animation_finished
	SignalStatic.emit_signal("on_player_died")
	queue_free()
	
func add_exp(exp) -> void:#TODO draw exp behind enemies
	experience += exp
	if experience >= experienceMax:
		expLevel += 1
		experience -= experienceMax
		experienceMax += 50
		SignalStatic.emit_signal("levelUp")
	SignalStatic.emit_signal("experience_changed", experience, experienceMax)

func addDefaultWeapon():
	addUpgrade(weaponManager.defaultWeaponId)

func addUpgrade(weaponId):
	weaponManager.addUpgrade(weaponId)
	
func getUpgradesInfo():
	return weaponManager.getUpgradesInfo()
