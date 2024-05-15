extends Node2D
const foe_with_path = preload("res://src/scenes/foe_with_path.tscn")
const boss = preload("res://src/scenes/boss.tscn")

var mob_packs = [
				
				[add_circle_bastards,add_circle_bastards,add_circle_bastards,add_circle_bastards,add_circle_bastards,],
				[boss_fight]]
#[left_homing_1, left_homing_2, left_homing_1, left_homing_2]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

### MOB pack returns
### If you return a float with a mob pack, further mob spawns will be delayed
### by that amount of time in seconds
### If you return null, the spawner will immediately work on spawning the next 
### sequential mob.
###
### I can't get it to work, but one_sec_pause() should let you stop spawns for 
### one second without needing to make a mob pack return turn a specific amount of time

#func one_sec_pause() -> float:
	#var x = 1.0 ### IDK WTF is going on with godot, but if you just return 1.0, it will see the return as null
	#return x

func left_homing_1():
	add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.STRAIGHT_LINES, 
				Enums.Shot_Pattern.RANDOM, Enums.Shot_Movement.TIMED_HOMING, Enums.Shot_Types.CIRCLE_BULLET)
	return 1.0

func left_homing_2():
	add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.HOVER_ON_POINT, Enums.Shot_Pattern.RANDOM, 
				Enums.Shot_Movement.TIMED_HOMING, Enums.Shot_Types.CIRCLE_BULLET)
	return 1.0

func add_first_pack():
	add_enemy(SIDE_RIGHT,SIDE_LEFT, Enums.Pathing.STRAIGHT_LINES, Enums.Shot_Pattern.RANDOM, 
		Enums.Shot_Movement.TIMED_HOMING, Enums.Shot_Types.SYRINGE)
	return 2.0

func add_enemy(enter_side:Side, exit_side:Side, pathing_type:Enums.Pathing, shot_pattern:Enums.Shot_Pattern, shot_movement, shot_type):
	var new_foe = foe_with_path.instantiate()
	new_foe.initialize(enter_side, exit_side, pathing_type, shot_pattern, shot_movement, shot_type)
	new_foe.add_to_group("Enemies")
	get_parent().add_child(new_foe)

func add_circle_bastards():
	add_enemy(SIDE_RIGHT,SIDE_LEFT, Enums.Pathing.STRAIGHT_LINES, Enums.Shot_Pattern.CIRCLE, 
				Enums.Shot_Movement.TIMED_HOMING,Enums.Shot_Types.DIAMOND)
	add_enemy(SIDE_LEFT,SIDE_RIGHT, Enums.Pathing.STRAIGHT_LINES, Enums.Shot_Pattern.CIRCLE, 
				Enums.Shot_Movement.TIMED_HOMING, Enums.Shot_Types.DIAMOND)
	return 1.0

func boss_fight():
	var new_foe = boss.instantiate()
	var new_path = Path2D.new()
	var new_curve = Curve2D.new()
	new_curve.add_point(Vector2(0,0),Vector2(0,0),Vector2(0,0))
	new_curve.add_point(Vector2(get_viewport_rect().size.x/2, 200), Vector2(0,0), Vector2(0,0))
	new_path.curve = new_curve
	new_foe.add_to_group("Enemies")
	new_path.add_child(new_foe)
	get_parent().add_child(new_path)
	
