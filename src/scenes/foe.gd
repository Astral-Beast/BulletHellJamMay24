extends PathFollow2D 
class_name Foe
signal hit
signal shoot

const circle_shot_scene = preload("res://src/scenes/circle_bullet.tscn")


@export var shot_type: PackedScene
@export var bullet_speed = 200
@export var spawn_dist_from_foe = 20
@export var foe_shot_type: Enums.Shot_Types = Enums.Shot_Types.CIRCLE  # random, spiral, or circle
@export var spiral_spread: float = 3
@export var circle_density: int = 30
@export var shot_movement_type: String = "constant" # constant or aimed
@export var shoot_timer: float = 0.5
@export var health: int = 10
@export var SPEED:float = .1

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
var theta_range = range(-PI*spiral_spread, PI*spiral_spread, 1)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Foe/AnimatedSprite2D.play()
	$Foe/AnimatedSprite2D.animation = "idle"
	$Foe/ShootTimer.wait_time = shoot_timer
	self.progress_ratio = 0 #starts at the begining of the path2d
	
	#shot_type = circle_shot_scene #basic shot 
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().print_tree()

	match self.pathing_type:
		Enums.Pathing.STRAIGHT_LINES:
			move(delta)
		Enums.Pathing.HOVER_ON_POINT:
			hover_move(delta)
				


### BEGIN MOVEMENT FUNC SECTION
# Progress ratio sets the ratio for the objects position on path2d
func move(delta):
	if self.progress_ratio + (delta * SPEED) < 1:
		self.progress_ratio += delta * SPEED
	else:
		self.queue_free()

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
	var shot
	match foe_shot_type:
		Enums.Shot_Types.RANDOM:
			shot = random_shot()
		Enums.Shot_Types.SPIRAL:
			shot = spiral_shot()
		Enums.Shot_Types.CIRCLE:
			circle_shot()

	$Foe/Shots.add_child(shot)

func random_shot():
	var shot = shot_type.instantiate()
	shot.movement_type = shot_movement_type
	
	var theta = randf_range(-PI, PI)
	var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
	shot.position = delta_r
	
	var velocity = shot.position.normalized()
	shot.velocity = velocity * bullet_speed
	return shot
	

func spiral_shot():
	var shot = shot_type.instantiate()
	shot.movement_type = shot_movement_type
	
	var theta = theta_range[counter] / spiral_spread
	
	if counter == len(theta_range) - 1:
		counter = 0
	else:
		counter += 1
	
	var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
	shot.position = delta_r
	
	var velocity = shot.position.normalized()
	shot.velocity = velocity * bullet_speed
	return shot

func circle_shot():
	for i in range(circle_density):
		var shot = shot_type.instantiate()
		shot.movement_type = shot_movement_type
	
		var theta = 2*PI * i / float(circle_density) - PI
	
		if counter == len(theta_range) - 1:
			counter = 0
		else:
			counter += 1
	
		var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
		shot.position = delta_r
		
		var velocity = shot.position.normalized()
		shot.velocity = velocity * bullet_speed
		$Foe/Shots.add_child(shot)


func clear_bullets():
	for n in $Foe/Shots.get_children():
		remove_child(n)
		
		n.queue_free()



func die():
	print("die")
	queue_free()
	pass


func _on_aim_timer_timeout():
	pass # Replace with function body.

# Initialize uses the built in Enum Side to define enter and exit sides


func _on_foe_take_damage() -> void:
	self.health-=1
	if self.health <0:
		die()

