extends Control
signal kill
signal remove_projectile

var difficulty:Enums.Difficulty=Enums.Difficulty.EASY


var heart_vec 
var hearts_visible 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_hearts()
	get_parent().connect("hit", _on_player_hit)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill_projectile(projectile):
	remove_projectile.emit()

func _on_player_hit():
	hearts_visible -=1
	print("visible: ", hearts_visible)
	if hearts_visible < 1:
		kill.emit()
	else:
		for i in range(hearts_visible, len(heart_vec)):
			get_node(heart_vec[i]).visible = false
	
	
func update_hearts():
	self.difficulty =get_tree().get_first_node_in_group("root").difficulty
	match difficulty:
		Enums.Difficulty.EASY:
			heart_vec = ["heart", "heart2","heart3","heart4","heart5"]
			hearts_visible = 5
		Enums.Difficulty.NORMAL:
			hearts_visible =3
			heart_vec =["heart", "heart3","heart5"]
			$heart2.visible = false
			$heart4.visible = false
		Enums.Difficulty.MASTER:
			hearts_visible =1
			heart_vec =["heart3"]
			$heart.visible = false
			$heart2.visible = false
			$heart4.visible = false
			$heart5.visible = false
	for heart in heart_vec:
		get_node(heart).visible = true
