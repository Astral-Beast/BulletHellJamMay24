extends Node2D
signal new_game
signal close
const credits = preload("res://src/scenes/credits.tscn")
var score:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if score < 500000 :
		$CanvasLayer/Score.text = "You scored %s. Your ancestors wonder where they went wrong." % score
	elif score < 1000000:
		$CanvasLayer/Score.text = "You scored %s. Your ancestors are dissapointed." % score
	elif score < 2500000:
		$CanvasLayer/Score.text = "You scored %s. Your ancestors are indifferent to you." % score
	else:
		$CanvasLayer/Score.text = "You scored %s. Your ancestors are are smiling upon you." % score
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_again_pressed() -> void:
	emit_signal("new_game")
	queue_free()


func _on_button_pressed() -> void:
	var new_credits = credits.instantiate()
	new_credits.connect("close", make_visible)
	add_child(new_credits)
	$CanvasLayer.visible = false

func make_visible():
	$CanvasLayer.visible = true
