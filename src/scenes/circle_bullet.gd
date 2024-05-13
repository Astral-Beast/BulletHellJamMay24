extends Node2D

### Signals
signal Bullet_Hit

### Speed Consts
const angular_speed = PI
@export var speed = .05
var dist
enum {HOMING, BOUNCING}

### Movement Vars
@export var movement_type : String = "homing"
@export var velocity : Vector2
@export var target: Vector2 = Vector2(0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if movement_type == "homing":
		homing_move(target, delta)
	elif movement_type == "constant":
		self.position = self.position + velocity * delta

func homing_move(position_to_approach, delta):
	dist = delta*speed
	self.position = self.position.lerp(position_to_approach, dist)


func _on_bullet_disappear_timer_timeout():
	queue_free()

