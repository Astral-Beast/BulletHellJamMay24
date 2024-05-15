extends Node2D
const banana = preload("res://src/scenes/banana.tscn")
const enemypacks = preload("res://src/Scripts/Enemy_Packs.gd")
var mob_packs = []
var mob_pack_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	mob_packs = EnemyPacks.mob_packs

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_player_hit():
	#TODO Add sound?
	cull_projectiles()


func cull_projectiles():
	# Gets all on screen bullets and queuefrees them
	for bullet in get_tree().get_nodes_in_group("Enemy_Bullets"):
		bullet.queue_free()

func _on_player_throw_banana():
	#var vect = get_global_mouse_position() - position
	var new_banana = banana.instantiate()
	new_banana.position = Vector2($Player.position.x, $Player.position.y-40)
	#new_banana.connect("banana_hit", _banana_hit)
	add_child(new_banana)


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
