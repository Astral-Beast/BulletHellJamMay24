extends Area2D
signal graze


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CollisionShape2D.position = get_tree().get_first_node_in_group("Player").position
	var overlap = len(get_overlapping_areas())
	if overlap >0: 
		emit_signal("graze", overlap)
