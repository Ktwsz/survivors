extends CharacterBody2D

var speed
var dmg
var direction

@onready var spawner = get_parent()

func setVariables(position, angle, speed, dmg):
	self.position = position
	self.rotation += angle
	self.direction = Vector2(cos(angle), sin(angle))
	self.speed = speed
	self.dmg = dmg

func _physics_process(delta):
	velocity = speed * direction
	var didHit = move_and_slide()
	
	if didHit: 
		var collision = get_last_slide_collision()
		collision.get_collider().hit(dmg)
		queue_free()
	
	if (position - spawner.player.position).length() >= 500:
		queue_free()
