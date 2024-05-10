extends Sprite2D

var speed =400
var angular_speed = PI

signal bullet_hit;
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation+=angular_speed*delta
	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta
	position = position
	$Sprite2D.position = position
	self.position = position
	print(self.po)
	pass
