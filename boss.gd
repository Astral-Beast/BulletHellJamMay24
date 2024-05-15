extends Foe
class_name Boss

const syringe = preload("res://src/scenes/syringe_bullet.tscn")
const diamond = preload("res://src/scenes/small_diamond_bullet.tscn")
const circle_bullet = preload("res://src/scenes/circle_bullet.tscn")

enum shot_types {
	SYRINGE,
	DIAMOND,
	CIRCLE_BULLET
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.shot_type = syringe
	circle_shot(diamond)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

