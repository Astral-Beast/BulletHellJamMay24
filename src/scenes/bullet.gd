extends Node2D

var angular_speed = PI
var speed = 400
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation+=angular_speed*delta
	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta
	position = position
	$Sprite2D.transform = $Sprite2D.transform.get_rotation()*PI
	self.position = position
	print(self.position)


