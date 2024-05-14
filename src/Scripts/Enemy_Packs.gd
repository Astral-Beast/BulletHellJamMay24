extends Node2D
const foe_with_path = preload("res://src/scenes/foe_with_path.tscn")

var mob_packs = [[add_first_pack, add_first_pack]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pause(time:float):
	return time

func three_left_homing():
	add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.STRAIGHT_LINES, Enums.Shot_Pattern.RANDOM, Enums.Shot_Movement.TIMED_HOMING)
	add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.HOVER_ON_POINT, Enums.Shot_Pattern.RANDOM, Enums.Shot_Movement.TIMED_HOMING)
	return null

func add_first_pack():

	add_enemy(SIDE_RIGHT,SIDE_LEFT, Enums.Pathing.STRAIGHT_LINES, Enums.Shot_Pattern.RANDOM, Enums.Shot_Movement.TIMED_HOMING)
	return 2.0

func add_enemy(enter_side:Side, exit_side:Side, pathing_type:Enums.Pathing, shot_pattern:Enums.Shot_Pattern, shot_movement):
	var new_foe = foe_with_path.instantiate()
	new_foe.initialize(enter_side, exit_side, pathing_type, shot_pattern, shot_movement)
	get_parent().add_child(new_foe)

