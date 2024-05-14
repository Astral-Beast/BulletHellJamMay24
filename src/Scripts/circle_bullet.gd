extends CharacterBody2D

### Signals
signal Bullet_Hit

### Speed Consts
const angular_speed = PI
@export var speed = .05
var dist


### Movement Vars
@export var movement_type : Enums.Shot_Movement = Enums.Shot_Movement.HOMING
@export var target: Vector2 = Vector2(0.0, 0.0)
@export var homing_time:float = 10.0
var homing_over:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	match movement_type:
		Enums.Shot_Movement.HOMING:
			var timer = Timer.new()
			timer.autostart = true
			timer.wait_time = self.homing_time
			timer.connect("timeout", _finish_homing)
			add_child(timer)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta: float) -> void:
	match movement_type:
		Enums.Shot_Movement.HOMING:
			var player=get_tree().get_nodes_in_group("Player")[0]
			print(player.position, self.position)
			velocity = self.position.direction_to(player.position)*speed
			
			move_and_slide()
			#homing_move(target, delta)
		Enums.Shot_Movement.CONSTANT:
			velocity * delta *speed
			move_and_slide()
			

func homing_move(position_to_approach, delta):
	dist = delta*speed
	self.position = self.position.lerp(position_to_approach, dist)

func _finish_homing():
	print("finished homing")
	self.movement_type = Enums.Shot_Movement.CONSTANT

func _on_bullet_disappear_timer_timeout():
	queue_free()

