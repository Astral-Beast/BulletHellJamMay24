extends CharacterBody2D

const SPEED = 2000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Banana go burr
	velocity.y += SPEED * delta * -1 # -1 makes it go up
	rotation += SPEED * cos( delta ) 
	move_and_slide()
	if is_instance_valid(self) and get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		var body = collision.get_collider()
		body.emit_signal("take_damage")
		kill_banana()

func kill_banana():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
