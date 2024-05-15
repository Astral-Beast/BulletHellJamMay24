extends Node2D
class_name Foe_With_Path

#Packed scenes
const foe = preload("res://src/scenes/foe.tscn")
const path_hover = preload("res://src/scenes/path_hover.tscn")
const path_left_to_right = preload("res://src/scenes/path_left_to_right.tscn")
const path_right_to_left = preload("res://src/scenes/path_right_to_left.tscn")

const syringe = preload("res://src/scenes/syringe_bullet.tscn")
const diamond = preload("res://src/scenes/small_diamond_bullet.tscn")
const circle_bullet = preload("res://src/scenes/circle_bullet.tscn")

@export var pathing: Enums.Pathing


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func initialize(side_enter:Side, side_exit:Side, path:Enums.Pathing, shot_pattern, shot_movement, shot_type):
	# Set movement type
	match path:
		Enums.Pathing.STRAIGHT_LINES:
			match side_exit:
				SIDE_LEFT:
					var new_path = path_right_to_left.instantiate()
					var new_foe =foe.instantiate()
					new_foe.foe_shot_pattern = shot_pattern
					new_foe.shot_movement_type = shot_movement
					match shot_type:
						Enums.Shot_Types.CIRCLE_BULLET:
							new_foe.shot_type = circle_bullet
						Enums.Shot_Types.DIAMOND:
							new_foe.shot_type = diamond
						Enums.Shot_Types.SYRINGE:
							new_foe.shot_type = syringe
					new_foe.shot_enum = shot_type
					new_path.add_child(new_foe)
					add_child(new_path)

				SIDE_RIGHT:
					var new_path = path_left_to_right.instantiate()
					var new_foe =foe.instantiate()
					new_foe.foe_shot_pattern = shot_pattern
					new_foe.shot_movement_type = shot_movement
					new_path.add_child(new_foe)
					add_child(new_path)
					
		Enums.Pathing.HOVER_ON_POINT:
			match side_enter:
				SIDE_LEFT:
					var new_path = path_hover.instantiate()
					var new_foe = foe.instantiate()
					new_foe.foe_shot_pattern = shot_pattern
					new_foe.shot_movement_type = shot_movement
					new_foe.pathing_type = Enums.Pathing.HOVER_ON_POINT
					new_path.add_child(new_foe)
					add_child(new_path)
				SIDE_RIGHT:
					var new_path = path_hover.instantiate()
					var new_foe = foe.instantiate()
					new_foe.pathing_type = Enums.Pathing.HOVER_ON_POINT
					new_foe.foe_shot_pattern = shot_pattern
					new_foe.shot_movement_type = shot_movement
					new_path.add_child(new_foe)
					add_child(new_path)


