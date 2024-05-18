extends Node
const death_screen = preload("res://src/scenes/death_screen.tscn")
const game = preload("res://src/scenes/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("starting")
	_on_new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_new_game():
	var new_game = game.instantiate()
	new_game.connect("game_over", _on_death_screen)
	add_to_group("Game")
	add_child(new_game)

func _on_death_screen(score):
	var death_screen_instance = death_screen.instantiate()
	death_screen_instance.connect("new_game", _on_new_game)
	death_screen_instance.score = score
	add_child(death_screen_instance)
