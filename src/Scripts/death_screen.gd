extends Node2D
signal new_game
var score:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if score < 10 :
		$CanvasLayer/Score.text = "You scored %s. Your ancestors wonder where they went wrong." % score
	elif score < 20:
		$CanvasLayer/Score.text = "You scored %s. Your ancestors are dissapointed." % score
	elif score < 30:
		$CanvasLayer/Score.text = "You scored %s. Your ancestors are dissapointed." % score
	else:
		$CanvasLayer/Score.text = "You scored %s. Your ancestors are are smiling upon you." % score
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_again_pressed() -> void:
	emit_signal("new_game")
	queue_free()

