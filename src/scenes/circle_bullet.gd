extends Node2D

### Signals
signal Bullet_Hit

### Consts
var angular_speed = PI
var speed = .05
var dist


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	homing_move(Vector2(0.0, 0.0), delta)
	pass

func homing_move(position_to_approach, delta):
	dist = delta*speed
	self.position = self.position.lerp(position_to_approach, dist)
	
