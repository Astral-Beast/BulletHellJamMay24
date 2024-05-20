extends Node
const death_screen = preload("res://src/scenes/death_screen.tscn")
const game = preload("res://src/scenes/game.tscn")
const controls = preload("res://src/scenes/controls_screen.tscn")
const victory_screen = preload("res://src/scenes/victory_screen.tscn")
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
	new_game.connect("victory_sig", _on_victory)
	add_to_group("Game")
	
	
	add_child(new_game)
	get_node("Controls_Screen/CanvasLayer").queue_free()

func _on_death_screen(score):
	var death_screen_instance = death_screen.instantiate()
	death_screen_instance.connect("new_game", show_controls)
	death_screen_instance.score = score
	add_child(death_screen_instance)

func _on_victory(score):
	var vic_screen = victory_screen.instantiate()
	vic_screen.connect("new_game",show_controls)
	vic_screen.score = score
	add_child(vic_screen)

func show_controls():
	var new_control = controls.instantiate()
	add_to_group("Controls")
	new_control.connect("difficulty",_on_new_game)
	add_child(new_control)
	#await get_tree().create_timer(5).timeout
	#new_control.get_node("CanvasLayer/Label").queue_free()


