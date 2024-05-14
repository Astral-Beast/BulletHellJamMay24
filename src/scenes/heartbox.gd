extends Control
signal kill
signal remove_projectile

@onready var heart1 = $heart1
@onready var heart2 = $heart2
@onready var heart3 = $heart3

var heart1_visible = true
var heart2_visible = true
var heart3_visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	heart1.show()
	heart2.show()
	heart3.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill_projectile(projectile):
	remove_projectile.emit()

func _on_player_hit():
	
	if heart3_visible == true && heart2_visible == true && heart1_visible == true:
		heart3_visible = false
		heart3.hide()
	elif heart2_visible == true && heart3_visible == false && heart1_visible == true:
		heart2_visible = false
		heart2.hide()
	elif heart1_visible == true && heart2_visible == false && heart3_visible == false:
		heart1_visible = false
		heart1.hide()
		kill.emit()
	
