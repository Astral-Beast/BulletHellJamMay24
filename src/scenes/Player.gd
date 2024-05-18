extends Area2D
signal hit
signal throw_banana
signal game_over
signal graze

@export var speed = 400
var screen_size
var dead = false
var hit_increment = 0
var hit_state = state.VULNERABLE

enum state {
	IMMUNE, # To bullets
	VULNERABLE # To bullets
}

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
		if Input.is_action_pressed("Slow_Move"):
			velocity= velocity *.5
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
	var overlaps = $Grazer.get_overlapping_areas()
	for i in overlaps:
		if len(overlaps) > 0:
			i
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_area_entered(area:Object):
	if self.hit_state == state.VULNERABLE and !area.is_in_group("Graze"):
		self.hit_state = state.IMMUNE
		$Immunity_timer.start()
		hit_increment += 1
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		$CollisionShape2D.set_deferred("disabled", true)
	pass
#vvv this is the signal that happens when the final heart goes away, from the control script
func _on_control_kill():
	hit_increment = 0
	$AnimatedSprite2D.animation ="die"
	dead = true
	emit_signal("game_over")
		


func _on_immunity_timer_timeout() -> void:
	$Immunity_timer.stop()
	self.hit_state = state.VULNERABLE


func _on_grazer_area_entered(area: Area2D) -> void:
	print("Grazing")
	emit_signal("graze")
	pass # Replace with function body.
