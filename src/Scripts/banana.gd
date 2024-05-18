extends CharacterBody2D

const SPEED = 2000.0
const horizontal_speed = 500
const banana_side: left_or_right = left_or_right.CENTER
enum left_or_right {
	LEFT,
	RIGHT,
	CENTER
}
# Get the gravity from the project settings to be synced with RigidBody nodes.


func _physics_process(delta):
	# Banana go burr
	velocity.y += SPEED * delta * -1 # -1 makes it go up
	match banana_side:
		left_or_right.LEFT:
			velocity.x = delta * horizontal_speed*-1
		left_or_right.RIGHT:
			velocity.x = delta *horizontal_speed
			
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
