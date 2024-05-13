extends Node2D
const banana = preload("res://src/scenes/banana.tscn")
const foe_with_path = preload("res://src/scenes/foe_with_path.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Enemies/Foe.initialize(SIDE_LEFT, SIDE_RIGHT, $Enemies/Foe.Pathing.STRAIGHT_LINES )
	var new_foe = foe_with_path.instantiate()
	new_foe.initialize(SIDE_LEFT,SIDE_RIGHT, new_foe.Pathing.STRAIGHT_LINES)
	add_child(new_foe)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func monkey_dies():
	pass # Replace with function body.


func _on_player_hit():
	monkey_dies()


func _on_player_throw_banana():
	#var vect = get_global_mouse_position() - position
	var new_banana = banana.instantiate()
	new_banana.position = Vector2($Player.position.x, $Player.position.y-40)
	#new_banana.connect("banana_hit", _banana_hit)
	add_child(new_banana)
