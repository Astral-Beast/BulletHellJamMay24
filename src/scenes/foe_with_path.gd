extends Node2D
class_name Foe_With_Path

#Packed scenes
const foe = preload("res://src/scenes/foe.tscn")
const path_hover = preload("res://src/scenes/path_hover.tscn")
const path_left_to_right = preload("res://src/scenes/path_left_to_right.tscn")
const path_right_to_left = preload("res://src/scenes/path_right_to_left.tscn")

@export var pathing: Enums.Pathing


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func initialize(side_enter:Side, side_exit:Side, path:Enums.Pathing):
	# Set movement type
	print(path)
	match path:
		Enums.Pathing.STRAIGHT_LINES:
			print("straight")
			match side_exit:
				SIDE_LEFT:
					var new_path = path_right_to_left.instantiate()
					new_path.add_child(foe.instantiate())
					add_child(new_path)

				SIDE_RIGHT:
					var new_path = path_left_to_right.instantiate()
					new_path.add_child(foe.instantiate())
					add_child(new_path)
					
		Enums.Pathing.HOVER_ON_POINT:
			print("hover")
			match side_enter:
				SIDE_LEFT:
					print("here")
					var new_path = path_hover.instantiate()
					var new_foe = foe.instantiate()
					new_foe.pathing_type = Enums.Pathing.HOVER_ON_POINT
					new_path.add_child(new_foe)
					add_child(new_path)
				SIDE_RIGHT:
					var new_path = path_hover.instantiate()
					var new_foe = foe.instantiate()
					new_foe.pathing_type = Enums.Pathing.HOVER_ON_POINT
					new_path.add_child(new_foe)
					add_child(new_path)
					pass
	print_tree()

