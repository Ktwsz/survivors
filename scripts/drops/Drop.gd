extends Area2D

var expValue : int

const SPEED = 500

var player

func setValues(exp, position) -> void:
	self.expValue = exp
	self.position = position

func _on_player_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	player = body

func _ready():
	self.body_entered.connect(_on_player_entered)
	
func _process(delta):
	if player == null : return
	
	var direction = player.position-position
	if direction.length() < 10: 
		player.add_exp(expValue)
		queue_free()
	position += direction.normalized() * SPEED * delta
