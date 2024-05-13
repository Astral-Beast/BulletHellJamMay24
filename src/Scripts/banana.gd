extends CharacterBody2D

const SPEED = 2000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Banana go burr
	velocity.y += SPEED * delta * -1 # -1 makes it go up
	rotation += SPEED * cos( delta ) 
	move_and_slide()
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body = collision.get_collider()
		print("collided with: ", body.name)
		body.take_damage()
		kill_banana()
		
func kill_banana():
	queue_free()
