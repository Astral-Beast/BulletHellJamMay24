extends Area2D
signal hit
signal shoot

@export var shot_type: PackedScene
@export var bullet_speed = 200
@export var spawn_dist_from_foe = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.animation = "idle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_shoot_timer_timeout():
	var shot = shot_type.instantiate()
	shot.movement_type = "constant"
	
	var theta = randf_range(-PI, PI)
	var delta_r = Vector2(sin(theta), cos(theta)) * spawn_dist_from_foe
	
	shot.position = delta_r
	
	var velocity = shot.position.normalized()
	shot.velocity = velocity * bullet_speed
	
	$Shots.add_child(shot)


func _on_player_hit():
	for n in $Shots.get_children():
		remove_child(n)
		
		n.queue_free()
