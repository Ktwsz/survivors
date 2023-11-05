extends CharacterBody2D

var direction : Vector2
var isFlipped : bool = false
@export var isHitOnCooldown : bool = false
@export var isDying : bool = false

@export var speed = 300
@export var damage = 1
@export var health = 10
@export var dropSrc : String
@export var dropVal : int
@export var damageTextScene : PackedScene

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var root = get_node("/root/Level")
@onready var drop = load(dropSrc)


func animationClear():
	animPlayer.play("RESET")

func setDirection() -> void:
	var playerPos = root.getPlayerPos()
	direction = (playerPos - position).normalized()
	
func move() -> bool:
	sprite.set_flip_h(isFlipped or direction.x < 0)
	if direction.x != 0: isFlipped = direction.x < 0
	velocity = speed * direction
	animPlayer.play("walk")
	var isHit = move_and_slide()
	
	if isHit:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			collision.get_collider().hit(damage)

		return true
	return false
	
func hit(dmg) -> void:
	if isDying or isHitOnCooldown: return
	
	damageTextCreate(dmg)
	health -= dmg

	if health > 0:
		animPlayer.play("hit")
		animPlayer.advance(0)
	else:
		die()
		
func damageTextCreate(dmg) -> void:
	var newDamageText = damageTextScene.instantiate()
	newDamageText.text = "-"+str(dmg)
	add_child(newDamageText)
		
func spawnDrop() -> void:
	var newDrop = drop.instantiate()
	newDrop.setValues(dropVal, position)
	root.add_child(newDrop)

func die() -> void:
	animPlayer.play("die")
	animPlayer.advance(0)
	await animPlayer.animation_finished
	spawnDrop()
	queue_free()

func _physics_process(delta):
	if isDying or isHitOnCooldown: return
	setDirection()
	move()
