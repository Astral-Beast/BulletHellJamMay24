extends Node2D
const banana = preload("res://src/scenes/banana.tscn")
const foe_with_path = preload("res://src/scenes/foe_with_path.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Enemies/Foe.initialize(SIDE_LEFT, SIDE_RIGHT, $Enemies/Foe.Pathing.STRAIGHT_LINES )
	#add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.STRAIGHT_LINES, Enums.Shot_Pattern.CIRCLE)
	#add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.HOVER_ON_POINT, Enums.Shot_Pattern.SPIRAL)
	add_enemy(SIDE_RIGHT,SIDE_LEFT, Enums.Pathing.STRAIGHT_LINES, Enums.Shot_Pattern.AIMED)
	pass
	

func add_enemy(enter_side:Side, exit_side:Side, pathing_type:Enums.Pathing, shot_pattern:Enums.Shot_Pattern):
	var new_foe = foe_with_path.instantiate()
	new_foe.initialize(enter_side, exit_side, pathing_type, shot_pattern)
	add_child(new_foe)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_player_hit():
	#TODO Add sound?
	cull_projectiles()


func cull_projectiles():
	# Gets all on screen bullets and queuefrees them
	for bullet in get_tree().get_nodes_in_group("Enemy_Bullets"):
		bullet.queue_free()

func _on_player_throw_banana():
	#var vect = get_global_mouse_position() - position
	var new_banana = banana.instantiate()
	new_banana.position = Vector2($Player.position.x, $Player.position.y-40)
	#new_banana.connect("banana_hit", _banana_hit)
	add_child(new_banana)
