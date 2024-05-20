extends RayCast2D
var is_casting := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Laser, "modulate", Color.RED, 1)
	tween.tween_property($Laser, "scale", Vector2(), 1)
	#tween.tween_callback(self.queue_free)
	tween.tween_callback(arrival)
	arrival()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func _physics_process(delta: float) -> void:
	var cast_point := target_position
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
func set_is_casting(cast:bool):
	is_casting = cast

func arrival():
	pass
