extends Foe
class_name Boss

const syringe = preload("res://src/scenes/syringe_bullet.tscn")
const diamond = preload("res://src/scenes/small_diamond_bullet.tscn")
const circle_bullet = preload("res://src/scenes/circle_bullet.tscn")
var spell_card

enum shot_types {
	SYRINGE,
	DIAMOND,
	CIRCLE_BULLET
}

enum spell_cards {
	SPELL_CARD_ONE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.health = 1500
	self.spell_card = spell_cards.SPELL_CARD_ONE
	pass # Replace with function body.

func _on_shoot_timer_timeout():
	match self.spell_card:
		self.spell_cards.SPELL_CARD_ONE:
			spell_card_one()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spell_card_one():
	circle_shot(diamond, Enums.Shot_Movement.CONST_PAUSE_AIM)
	spiral_shot(syringe, Enums.Shot_Movement.CONSTANT)
	random_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, 10)
