extends CharacterBody2D 
signal hit
signal shoot

@export var shot_type: PackedScene
@export var bullet_speed = 200
@export var spawn_dist_from_foe = 20
@export var foe_shot_type: String = "random" # random, spiral, or circle
@export var spiral_spread: float = 3
@export var circle_density: int = 30
@export var shot_movement_type: String = "constant" # constant or aimed
@export var shoot_timer: float = 0.5
@export var health: int = 10

var counter: int = 0
var theta_range = range(-PI*spiral_spread, PI*spiral_spread, 1)


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.animation = "idle"
	$ShootTimer.wait_time = shoot_timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_shoot_timer_timeout():
	var shot
	
	if foe_shot_type == "random":
		shot = random_shot()
	elif foe_shot_type == "spiral":
		shot = spiral_shot()
	elif foe_shot_type == "circle":
		circle_shot()
		pass
	
	$Shots.add_child(shot)

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
		$Shots.add_child(shot)


func clear_bullets():
	for n in $Shots.get_children():
		remove_child(n)
		
		n.queue_free()
		
func take_damage():
	
	self.health-=1
	print("health")
	if self.health <0:
		die()
	pass

func die():
	print("die")
	queue_free()
	pass


func _on_area_entered(area):
	print("area_entered")
	take_damage()
	pass # Replace with function body.


func _on_aim_timer_timeout():
	pass # Replace with function body.
