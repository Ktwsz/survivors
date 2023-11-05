extends Label

const SPEED = Vector2(0, -50)
const LIFETIME = 0.5

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(LIFETIME)
	timer.set_one_shot(false)
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += delta * SPEED
