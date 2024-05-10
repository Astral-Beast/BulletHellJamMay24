extends Node2D
var angular_speed = 400
var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func move(delta):
	self.position+=speed*delta
	print(self.position)
