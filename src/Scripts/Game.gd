extends Node2D
const banana = preload("res://src/scenes/banana.tscn")
var rng = RandomNumberGenerator.new()
signal game_over
var score:int
var banana_counter : bool = true

var sound_count = 0
var mob_packs = []
var mob_pack_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	mob_packs = EnemyPacks.mob_packs.duplicate(true)
	score = -1
	_on_score_increase()
	SignalManager.connect("score_increase", _on_score_increase)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#child_entered_tree.connect(_on_score_increase)
	pass

func _on_player_hit():
	$player_sfx_handler.play()
	cull_projectiles()

func _on_score_increase():
	score += 1
	$UI/Score.text = "Score: %s" % score

func cull_projectiles():
	# Gets all on screen bullets and queuefrees them
	for bullet in get_tree().get_nodes_in_group("Enemy_Bullets"):
		bullet.queue_free()
		
func cull_all():
	# Gets all on screen bullets and queuefrees them
	for bullet in get_tree().get_nodes_in_group("Enemy_Bullets"):
		bullet.queue_free()
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()
	get_tree().get_first_node_in_group("Player").queue_free()

func _on_player_throw_banana():
	#var vect = get_global_mouse_position() - position
	var new_banana = banana.duplicate().instantiate()
	new_banana.position = Vector2($Player.position.x, $Player.position.y-40)
	#new_banana.connect("banana_hit", _banana_hit)
	if $player_sfx_handler_banana.get_playback_position() < 0.17 && sound_count <= 5:
		sound_count += 1
	else:
		$player_sfx_handler_banana.play(0)
		sound_count = 0
		
	add_child(new_banana)
	if banana_counter :
		banana_counter = !banana_counter
		var left_banana = get_banana()
		left_banana.position = Vector2($Player.position.x-10, $Player.position.y-40)
		left_banana.banana_side = SIDE_LEFT
		add_child(left_banana)
		var right_banana = get_banana()
		right_banana.position = Vector2($Player.position.x-10, $Player.position.y-40)
		right_banana.banana_side = SIDE_RIGHT
		add_child(right_banana)
	else: 
		banana_counter = !banana_counter

func get_banana():
	var nanner = banana.duplicate().instantiate()
	return nanner

func _on_mob_spawner_timeout() -> void:
	
	if mob_pack_index < len(mob_packs):
		for pack in mob_packs[mob_pack_index]:
			var response = pack.call()
			mob_packs[mob_pack_index].pop_front()
			if response != null:
				$Mob_Spawner.stop()
				$Spawn_Pause_Timer.start(response)
				return
		mob_pack_index+=1
	
func _on_spawn_pause_timer_timeout() -> void:
	$Mob_Spawner.start()
	$Spawn_Pause_Timer.stop()
	for pack in mob_packs[mob_pack_index]:
		var response = pack.call()
		mob_packs[mob_pack_index].pop_front()
		if response != null:
			$Mob_Spawner.stop()
			$Spawn_Pause_Timer.start(response)
			return
		mob_pack_index+=1


func _on_player_game_over() -> void:
	emit_signal("game_over", score)
	
	emit_signal("game_over")
	cull_all()
	queue_free()
	
func _on_music_finished():
	$music.play()
