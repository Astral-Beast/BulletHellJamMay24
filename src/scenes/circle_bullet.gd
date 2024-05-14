extends Node2D

### Signals
signal Bullet_Hit

### Speed Consts
const angular_speed = PI
@export var speed = .05
@export var homing_speed = 5.0
var dist
enum {HOMING, BOUNCING}

### Movement Vars
@export var movement_type : Enums.Shot_Movement = Enums.Shot_Movement.HOMING
@export var velocity : Vector2
@export var target: Vector2 = Vector2(0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match movement_type:
		Enums.Shot_Movement.HOMING:
			var player_location = get_tree().get_nodes_in_group("Player")[0].position
			print(player_location)
			
			homing_move(player_location, delta)
		Enums.Shot_Movement.CONSTANT:
			self.position = self.position + velocity * delta

func homing_move(position_to_approach, delta):
	var vector = (position_to_approach - self.position).normalized()
	dist = delta*homing_speed
	self.position = self.position + vector * homing_speed


func _on_bullet_disappear_timer_timeout():
	queue_free()

