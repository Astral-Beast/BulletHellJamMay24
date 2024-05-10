extends Node2D

### Signals
signal Bullet_Hit

### Speed Consts
const angular_speed = PI
const speed = .05
var dist
enum {HOMING, BOUNCING}

### Movement Vars
var movement_type : String
var target : Vector2
var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	movement_type = "homing"
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if movement_type == "homing":
		homing_move(Vector2(0.0, 0.0), delta)
	pass

func homing_move(position_to_approach, delta):
	dist = delta*speed
	self.position = self.position.lerp(position_to_approach, dist)
	
