extends Node2D
signal difficulty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_easy_pressed() -> void:
	emit_signal("difficulty",Enums.Difficulty.EASY)
	pass # Replace with function body.


func _on_normal_pressed() -> void:
	emit_signal("difficulty",Enums.Difficulty.NORMAL)
	pass # Replace with function body.


func _on_master_pressed() -> void:
	emit_signal("difficulty",Enums.Difficulty.MASTER)
	pass # Replace with function body.
