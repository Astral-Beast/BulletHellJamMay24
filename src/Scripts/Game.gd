extends Node2D
const banana = preload("res://src/scenes/banana.tscn")
const foe_with_path = preload("res://src/scenes/foe_with_path.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Enemies/Foe.initialize(SIDE_LEFT, SIDE_RIGHT, $Enemies/Foe.Pathing.STRAIGHT_LINES )
	add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.STRAIGHT_LINES, Enums.Shot_Types.CIRCLE)
	add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.HOVER_ON_POINT, Enums.Shot_Types.SPIRAL)
	

func add_enemy(enter_side:Side, exit_side:Side, pathing_type:Enums.Pathing, shot_type:Enums.Shot_Types):
	var new_foe = foe_with_path.instantiate()
	new_foe.initialize(enter_side, exit_side, pathing_type, shot_type)
	add_child(new_foe)

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
