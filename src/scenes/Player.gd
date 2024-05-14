extends Area2D
signal hit
signal throw_banana

@export var speed = 400
var screen_size
var dead = false
var hit_increment = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dead:
		var velocity = Vector2.ZERO
		
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("Throw_banana"):
			emit_signal("throw_banana")
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.play()
		
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		
		if velocity.x != 0 && hit_increment != 3:
				
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y != 0 && hit_increment != 3:
			$AnimatedSprite2D.animation = "walk"
		elif hit_increment != 3:
			$AnimatedSprite2D.animation = "idle"

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_area_entered(area):
	
	hit_increment += 1
	hit.emit()
	$CollisionShape2D.set_deferred("diabled", true)

#vvv this is the signal that happens when the final heart goes away, from the control script
func _on_control_kill():
	
	hit_increment = 0
	
	$AnimatedSprite2D.animation ="die"
	dead = true
	
	print("add death animation here pls")
	
