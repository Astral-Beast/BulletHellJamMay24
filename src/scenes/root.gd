extends Node
const death_screen = preload("res://src/scenes/death_screen.tscn")
const game = preload("res://src/scenes/game.tscn")
const controls = preload("res://src/scenes/controls_screen.tscn")
var difficulty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	show_controls()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_new_game(diff):
	self.difficulty = diff
	print(self.difficulty)
	print(diff)
	var new_game = game.instantiate()
	new_game.connect("game_over", _on_death_screen)
	add_to_group("Game")
	
	
	add_child(new_game)
	get_node("Controls_Screen/CanvasLayer").queue_free()

func _on_death_screen(score):
	var death_screen_instance = death_screen.instantiate()
	death_screen_instance.connect("new_game", _on_new_game)
	death_screen_instance.score = score
	add_child(death_screen_instance)

func show_controls():
	var new_control = controls.instantiate()
	add_to_group("Controls")
	new_control.connect("difficulty",_on_new_game)
	add_child(new_control)
	#await get_tree().create_timer(5).timeout
	#new_control.get_node("CanvasLayer/Label").queue_free()


