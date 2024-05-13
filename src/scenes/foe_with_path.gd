extends Node2D
class_name Foe_With_Path

#Packed scenes
const foe = preload("res://src/scenes/foe.tscn")
const path_hover = preload("res://src/scenes/path_hover.tscn")
const path_left_to_right = preload("res://src/scenes/path_left_to_right.tscn")
const path_right_to_left = preload("res://src/scenes/path_right_to_left.tscn")

@export var pathing: Pathing
enum Pathing {
	STRAIGHT_LINES,
	HOVER_ON_POINT
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func initialize(side_enter:Side, side_exit:Side, path:Pathing):
	# Set movement type
	match pathing:
		Pathing.STRAIGHT_LINES:
			match side_exit:
				SIDE_LEFT:
					var new_path = path_right_to_left.instantiate()
					new_path.add_child(foe.instantiate())
					add_child(new_path)
					pass
				SIDE_RIGHT:
					var new_path = path_left_to_right.instantiate()
					var new_foe = foe.instantiate()
					new_path.add_child(foe.instantiate())
					add_child(new_path)
					print("here")
					pass
		Pathing.HOVER_ON_POINT:
			match side_enter:
				SIDE_LEFT:
					pass
				SIDE_RIGHT:
					pass

