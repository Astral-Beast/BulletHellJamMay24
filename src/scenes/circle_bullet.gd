extends Node2D

### Signals
signal Bullet_Hit

### Speed Consts
const angular_speed = PI
@export var speed = .05
@export var homing_speed = 150.0
var dist


### Movement Vars
@export var movement_type : Enums.Shot_Movement = Enums.Shot_Movement.HOMING
@export var velocity : Vector2
@export var target: Vector2 = Vector2(0.0, 0.0)
@export var homing_done:bool = false
@export var homing_timer_length:float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	match movement_type:
		Enums.Shot_Movement.TIMED_HOMING:
			var timer = Timer.new()
			timer.autostart = true
			timer.wait_time = homing_timer_length
			timer.connect("timeout", _on_homing_timout)
			add_child(timer)
			
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match movement_type:
		Enums.Shot_Movement.HOMING:
			var player_location = get_tree().get_nodes_in_group("Player")[0].position
			homing_move(player_location, delta)
		Enums.Shot_Movement.TIMED_HOMING:
			var player_location = get_tree().get_nodes_in_group("Player")[0].position
			timed_homing_move(player_location, delta)
		Enums.Shot_Movement.CONSTANT:
			self.position = self.position + velocity * delta

func homing_move(position_to_approach, delta):
	self.velocity = (position_to_approach - self.position).normalized() * homing_speed
	dist = delta*homing_speed
	self.position = self.position + velocity * delta 

func timed_homing_move(position_to_approach, delta):
	self.velocity = (position_to_approach - self.position).normalized() * homing_speed
	dist = delta*homing_speed
	self.position = self.position + velocity * delta 
func _on_homing_timout():
	movement_type = Enums.Shot_Movement.CONSTANT
	pass
func _on_bullet_disappear_timer_timeout():
	queue_free()

