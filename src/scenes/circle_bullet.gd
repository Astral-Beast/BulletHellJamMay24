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
@export var movement_pause_timer_length:float = 1.5
var state:const_pause_aimed_state = const_pause_aimed_state.CONST
enum const_pause_aimed_state {
	CONST,
	PAUSED,
	AIMED
}

# Called when the node enters the scene tree for the first time.
func _ready():
	match movement_type:
		Enums.Shot_Movement.TIMED_HOMING:
			var timer = Timer.new()
			timer.autostart = true
			timer.wait_time = homing_timer_length
			timer.connect("timeout", _on_homing_timout)
			add_child(timer)
		Enums.Shot_Movement.CONST_PAUSE_AIM:
			var timer = Timer.new()
			timer.autostart = true
			timer.wait_time = movement_pause_timer_length
			timer.one_shot = false
			timer.connect("timeout", _begin_movement_pause)
			add_child(timer)
			self.state = const_pause_aimed_state.CONST


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
		Enums.Shot_Movement.CONST_PAUSE_AIM:
			const_pause_aim_move(delta)

func homing_move(position_to_approach, delta):
	self.velocity = (position_to_approach - self.position).normalized() * homing_speed
	self.position = self.position + velocity * delta 

func timed_homing_move(position_to_approach, delta):
	self.velocity = (position_to_approach - self.position).normalized() * homing_speed
	self.position = self.position + velocity * delta 
	
func _on_homing_timout():
	movement_type = Enums.Shot_Movement.CONSTANT
	pass

func const_pause_aim_move(delta):
	match self.state:
		const_pause_aimed_state.CONST:
			self.position = self.position + velocity * delta
		const_pause_aimed_state.AIMED:
			var player_location = get_tree().get_nodes_in_group("Player")[0].position
			self.velocity = (player_location - self.position).normalized() * homing_speed
			self.position = self.position + velocity * delta 
			self.movement_type = Enums.Shot_Movement.CONSTANT


func _begin_movement_pause():
	# For const pause aim move type
	match self.state:
		const_pause_aimed_state.CONST:
			self.state = const_pause_aimed_state.PAUSED
		const_pause_aimed_state.PAUSED:
			self.state = const_pause_aimed_state.AIMED


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
