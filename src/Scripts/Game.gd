extends Node2D

const banana = preload("res://src/scenes/banana.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_throw_banana():
	var vect = get_global_mouse_position() - position
	var new_banana = banana.instantiate()
	add_child(new_banana)
	pass # Replace with function body.
