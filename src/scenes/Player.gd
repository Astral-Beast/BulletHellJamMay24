extends Area2D
signal hit

@export var speed = 400
var screen_size
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.play()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0 && dead != true:
			
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0 && dead != true:
		$AnimatedSprite2D.animation = "walk"
	elif dead != true:
		$AnimatedSprite2D.animation = "idle"


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_area_entered(area):
	
	dead = true
	hit.emit()
	
	$CollisionShape2D.set_deferred("diabled", true)

#vvv this is the signal that happens when the final heart goes away, from the control script
func _on_control_kill():
	hide()
	print("add death animation here pls")
	
