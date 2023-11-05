extends CharacterBody2D

var speed : int
var dmg : int
var direction = Vector2(100, -30)

const ROT_SPEED = 10
const GRAVITY = Vector2(0, 100)

@onready var spawner = get_parent()

func setVariables(position, isFlipped, speed, dmg):
	self.position = position
	if isFlipped: direction.x *= -1
	self.direction = direction
	self.speed = speed
	self.dmg = dmg

func _physics_process(delta):
	direction += delta * GRAVITY
	velocity += delta * speed * direction
	rotate(deg_to_rad(ROT_SPEED))
	var didHit = move_and_slide()
	
	if didHit: 
		var collision = get_last_slide_collision()
		collision.get_collider().hit(dmg)
		queue_free()
	
	if (position - spawner.player.position).length() >= 500:
		queue_free()
