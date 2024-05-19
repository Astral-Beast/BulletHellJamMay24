extends PathFollow2D 
class_name Foe
signal hit
signal shoot
signal death_sfx
signal score_increase

const syringe = preload("res://src/scenes/syringe_bullet.tscn")
const diamond = preload("res://src/scenes/small_diamond_bullet.tscn")
const circle_bullet = preload("res://src/scenes/circle_bullet.tscn")
const big_ass_bullet = preload("res://src/scenes/big_ass_bullet.tscn")

@export var shot_type: PackedScene
var shot_enum: Enums.Shot_Types
@export var bullet_speed = 200
@export var spawn_dist_from_foe = 20
@export var foe_shot_pattern: Enums.Shot_Pattern = Enums.Shot_Pattern.CIRCLE  # random, spiral, or circle
@export var foe_shot_pattern2: Enums.Shot_Pattern = Enums.Shot_Pattern.CIRCLE  # random, spiral, or circle
@export var foe_shot_pattern3: Enums.Shot_Pattern = Enums.Shot_Pattern.CIRCLE  # random, spiral, or circle
@export var spiral_spread: float = 3
@export var circle_density: int = 30
@export var inv_fan_density: int = 100
@export var shot_movement_type: Enums.Shot_Movement = Enums.Shot_Movement.CONSTANT # constant or aimed
@export var shoot_timer: float = 0.5
@export var health: int = 10
@export var SPEED:float = 1

## Pathing vars
@export var side_exit:Side
@export var pathing_type:Enums.Pathing = Enums.Pathing.STRAIGHT_LINES
@export var hovered:bool = false
@export var hover_time:float = 3.0 #seconds to wait when hovering
@export var movement_state:Movement = Movement.MOVING
enum Movement {
	MOVING,
	PAUSED
}

var counter: int = 0
var sweep_counter: int = 0
var sweep_counter_g: int = 0
var sweep_left: bool = false
var sweep_left_g: bool = false
var theta_range = range(-PI*spiral_spread, PI*spiral_spread, 1)
var shooting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Foe/AnimatedSprite2D.play()
	$Foe/AnimatedSprite2D.animation = "idle"
	$Foe/ShootTimer.wait_time = shoot_timer
	self.progress_ratio = 0 #starts at the begining of the path2d
	
	match shot_enum:
		Enums.Shot_Types.CIRCLE_BULLET:
			self.shot_type = circle_bullet
		Enums.Shot_Types.DIAMOND:
			self.shot_type = diamond
		Enums.Shot_Types.SYRINGE:
			self.shot_type = syringe
	
	#shot_pattern = circle_shot_scene #basic shot 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match self.pathing_type:
		Enums.Pathing.STRAIGHT_LINES:
			move(delta)
		Enums.Pathing.HOVER_ON_POINT:
			hover_move(delta)
				


### BEGIN MOVEMENT FUNC SECTION
# Progress ratio sets the ratio for the objects position on path2d
func move(delta):
	self.progress_ratio += delta * SPEED

func hover_move(delta):
	if self.progress_ratio + (delta * SPEED) > .5 and not hovered:
		self.progress_ratio = .5
		pause_movement()
	if self.movement_state == Movement.MOVING:
		move(delta)
	pass

func pause_movement():
	var timer = Timer.new()
	timer.wait_time = self.hover_time
	timer.autostart = true
	timer.connect("timeout", _finish_hover)
	add_child(timer)
	self.movement_state = Movement.PAUSED

func _finish_hover():
	self.hovered = true
	self.movement_state = Movement.MOVING
	
### END MOVEMENT FUNC SECTION ###

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_shoot_timer_timeout():

	match foe_shot_pattern:
		Enums.Shot_Pattern.RANDOM:
			random_shot()
		Enums.Shot_Pattern.SPIRAL:
			spiral_shot()
		Enums.Shot_Pattern.CIRCLE:
			circle_shot()
		Enums.Shot_Pattern.AIMED:
			aimed_shot()



func random_shot(this_shot_type = shot_type, this_movement_type = shot_movement_type,
					this_shot_type_enum=shot_enum, num_shots =1):
	for i in num_shots:
		var shot = this_shot_type.instantiate()
		shot.shot_type = this_shot_type_enum
		shot.movement_type = this_movement_type
		
		var theta = randf_range(-PI, PI)
		var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
		
		shot.position = delta_r*get_global_transform().affine_inverse()
		var bullet_global_position = shot.position*get_global_transform().affine_inverse()
		var self_global_position = self.position*get_global_transform().affine_inverse()
		var velocity = (bullet_global_position - self_global_position).normalized()	
		shot.velocity = velocity * bullet_speed
		shot.add_to_group("Enemy_Bullets")
		get_parent().add_child(shot)
		$foe_audio_shot.play()

func spiral_shot(this_shot_type = shot_type, this_movement_type = shot_movement_type, 
					this_shot_type_enum=shot_enum, reverse_dir=false):
	var direction: float
	
	if reverse_dir:
		direction = -1.
	else:
		direction = 1.
	
	var shot = this_shot_type.instantiate()
	shot.movement_type = this_movement_type
	shot.shot_type = this_shot_type_enum
	var theta = direction * theta_range[counter] / spiral_spread
	
	if counter == len(theta_range) - 1:
		counter = 0
	else:
		counter += 1
	
	var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
	shot.position = delta_r*get_global_transform().affine_inverse()
	
	var bullet_global_position = shot.position*get_global_transform().affine_inverse()
	var self_global_position = self.position*get_global_transform().affine_inverse()
	var velocity = (bullet_global_position - self_global_position).normalized()
	shot.velocity = velocity * bullet_speed
	shot.add_to_group("Enemy_Bullets")
	get_parent().add_child(shot)
	$foe_audio_shot.play()

func circle_shot(this_shot_type = shot_type, this_movement_type = shot_movement_type,
					this_shot_type_enum=shot_enum, std: float=0):
	for i in range(circle_density):
		var shot = this_shot_type.instantiate()
		shot.movement_type = this_movement_type
		shot.shot_type = this_shot_type_enum
		var theta = 2*PI * i / float(circle_density) - PI + randfn(0.0, std)
	
		if counter == len(theta_range) - 1:
			counter = 0
		else:
			counter += 1
	
		var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
		shot.position = delta_r*get_global_transform().affine_inverse()
		var bullet_global_position = shot.position*get_global_transform().affine_inverse()
		var self_global_position = self.position*get_global_transform().affine_inverse()
		var velocity = (bullet_global_position - self_global_position).normalized()
		shot.velocity = velocity * bullet_speed
		shot.add_to_group("Enemy_Bullets")
		get_parent().add_child(shot)
		$foe_audio_shot.play()

func aimed_shot(this_shot_type = shot_type, this_movement_type = shot_movement_type,
					this_shot_type_enum=shot_enum):
	var shot = this_shot_type.instantiate()
	shot.movement_type = shot_movement_type
	shot.shot_type = this_shot_type_enum
	var theta = randf_range(-PI, PI)
	var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	shot.position = delta_r*get_global_transform().affine_inverse()
	var player_global_position = get_tree ().get_nodes_in_group("Player")[0].position
	var shot_global_position = shot.position
	var velocity = (player_global_position - shot_global_position).normalized()	
	shot.velocity = velocity * bullet_speed
	shot.add_to_group("Enemy_Bullets")
	get_parent().add_child(shot)
	$foe_audio_shot.play()

func sweep_shot(this_shot_type = shot_type, this_movement_type = shot_movement_type,
					this_shot_type_enum=shot_enum, max_theta = PI/4, density: float = 10, std: float = .1):
	var sweep_range = range(-max_theta*density, max_theta*density, 1)
	
	var shot = this_shot_type.instantiate()
	shot.movement_type = this_movement_type
	shot.shot_type = this_shot_type_enum
	var theta = sweep_range[sweep_counter] / density + randfn(0, std)
	
	if (sweep_counter == len(sweep_range) - 1) and (sweep_left != true):
		sweep_counter -= 1
		sweep_left = true
	elif sweep_left and (sweep_counter != len(sweep_range) - 1) and (sweep_counter != 0):
		sweep_counter -= 1
	elif sweep_left and sweep_counter == 0:
		sweep_counter += 1
		sweep_left = false
	else:
		sweep_counter += 1
	
	var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
	shot.position = delta_r*get_global_transform().affine_inverse()
	
	var bullet_global_position = shot.position*get_global_transform().affine_inverse()
	var self_global_position = self.position*get_global_transform().affine_inverse()
	var velocity = (bullet_global_position - self_global_position).normalized()
	shot.velocity = velocity * bullet_speed
	shot.add_to_group("Enemy_Bullets")
	get_parent().add_child(shot)

func fan_shot():
	pass

func inverted_fan_shot(this_shot_type = shot_type, this_movement_type = shot_movement_type,
					this_shot_type_enum=shot_enum, density=self.inv_fan_density, limit=PI/4):
	for i in range(density):
		var shot = this_shot_type.instantiate()
		shot.movement_type = this_movement_type
		shot.shot_type = this_shot_type_enum
		var theta = limit + 2*(PI - limit) * i / float(density)
	
		if counter == len(theta_range) - 1:
			counter = 0
		else:
			counter += 1
	
		var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
		shot.position = delta_r*get_global_transform().affine_inverse()
		var bullet_global_position = shot.position*get_global_transform().affine_inverse()
		var self_global_position = self.position*get_global_transform().affine_inverse()
		var velocity = (bullet_global_position - self_global_position).normalized()
		shot.velocity = velocity * bullet_speed
		shot.add_to_group("Enemy_Bullets")
		get_parent().add_child(shot)

func galactic_shot(this_shot_type = shot_type, this_movement_type = shot_movement_type, 
					this_shot_type_enum=shot_enum, arms: int = 3, reverse_dir=false, 
					spiral_spread: float = 10):
	var direction: float
	var theta_range = range(-PI*spiral_spread, PI*spiral_spread, 1)
	
	if reverse_dir:
		direction = -1.
	else:
		direction = 1.
	
	for arm_idx in range(arms):
		var shot = this_shot_type.instantiate()
		shot.movement_type = this_movement_type
		shot.shot_type = this_shot_type_enum
		var theta = direction * theta_range[counter] / spiral_spread + 2*PI * float(arm_idx) / float(arms)
		print(theta_range[counter] / spiral_spread)
	
		if counter == len(theta_range) - 1:
			counter = 0
		else:
			counter += 1
			shot.movement_type = this_movement_type
			shot.shot_type = this_shot_type_enum
		var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
		shot.position = delta_r*get_global_transform().affine_inverse()
	
		var bullet_global_position = shot.position*get_global_transform().affine_inverse()
		var self_global_position = self.position*get_global_transform().affine_inverse()
		var velocity = (bullet_global_position - self_global_position).normalized()
		shot.velocity = velocity * bullet_speed
		shot.add_to_group("Enemy_Bullets")
		get_parent().add_child(shot)
		$foe_audio_shot.play()

func galactic_sweep_shot(this_shot_type = shot_type, this_movement_type = shot_movement_type, 
					this_shot_type_enum=shot_enum, arms: int = 3, spiral_spread: float = 10, 
					max_theta = PI/4, density: float = 10):
	var sweep_range_g = range(-max_theta*density, max_theta*density, 1)
	var theta_range_g = range(-PI*spiral_spread, PI*spiral_spread, 1)
	
	for arm_idx in range(arms):
		var shot = this_shot_type.instantiate()
		shot.movement_type = this_movement_type
		shot.shot_type = this_shot_type_enum
		var theta = sweep_range_g[sweep_counter_g] / spiral_spread + 2*PI * float(arm_idx) / float(arms)
	
		if (sweep_counter_g == len(sweep_range_g) - 1) and (sweep_left_g != true):
			sweep_counter_g -= 1
			sweep_left_g = true
		elif sweep_left_g and (sweep_counter_g != len(sweep_range_g) - 1) and (sweep_counter_g != 0):
			sweep_counter_g -= 1
		elif sweep_left_g and sweep_counter_g == 0:
			sweep_counter_g += 1
			sweep_left_g = false
		else:
			sweep_counter_g += 1
	
		if counter == len(theta_range) - 1:
			counter = 0
		else:
			counter += 1
			shot.movement_type = this_movement_type
			shot.shot_type = this_shot_type_enum
		var delta_r = Vector2(sin(theta), cos(theta)) * 20.
	
		shot.position = delta_r*get_global_transform().affine_inverse()
	
		var bullet_global_position = shot.position*get_global_transform().affine_inverse()
		var self_global_position = self.position*get_global_transform().affine_inverse()
		var velocity = (bullet_global_position - self_global_position).normalized()
		shot.velocity = velocity * 200.
		shot.add_to_group("Enemy_Bullets")
		get_parent().add_child(shot)
		$foe_audio_shot.play()

func die():
	death_sfx.emit()
	await get_tree().create_timer(1.22).timeout
	SignalManager.emit_signal("score_increase")
	self.queue_free()
	pass

func _on_foe_take_damage() -> void:
	self.health-=10
	if self.health <0:
		$Foe/ShootTimer.wait_time = 9999
		$Foe/CollisionShape2D.queue_free()
		$Foe/AnimatedSprite2D.queue_free()
		die()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_shoot_timer_2_timeout():

	match foe_shot_pattern2:
		Enums.Shot_Pattern.RANDOM:
			random_shot()
		Enums.Shot_Pattern.SPIRAL:
			spiral_shot()
		Enums.Shot_Pattern.CIRCLE:
			circle_shot()
		Enums.Shot_Pattern.AIMED:
			aimed_shot()
		Enums.Shot_Pattern.NONE:
			pass

func _on_shoot_timer_3_timeout():

	match foe_shot_pattern3:
		Enums.Shot_Pattern.RANDOM:
			random_shot()
		Enums.Shot_Pattern.SPIRAL:
			spiral_shot()
		Enums.Shot_Pattern.CIRCLE:
			circle_shot()
		Enums.Shot_Pattern.AIMED:
			aimed_shot()
		Enums.Shot_Pattern.NONE:
			pass

