extends Sprite2D

var angular_speed = PI
var speed = 400
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spin_sprite(delta)

func spin_sprite(delta):
	# Spins the visual part of the bullet
	rotation+=angular_speed*delta
	self.rotate( delta*angular_speed)
	self.position = position
	pass
