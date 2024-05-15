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
	SPELL_CARD_ONE,
	PAUSE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.health = 1500
	self.spell_card = spell_cards.SPELL_CARD_ONE
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	if progress_ratio > .98:
		progress_ratio = 1.0
		get_parent().curve.clear_points()

func _on_shoot_timer_timeout():
	# Overrides super class func
	match self.spell_card:
		self.spell_cards.SPELL_CARD_ONE:
			spell_card_one()
		spell_cards.PAUSE:
			print("paused")

func spell_card_one():
	circle_shot(diamond, Enums.Shot_Movement.CONST_PAUSE_AIM)
	spiral_shot(syringe, Enums.Shot_Movement.CONSTANT)
	random_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, 10)

func spell_card_pause():
	pass

func _on_spell_card_timer_timeout() -> void:
	match spell_card:
		spell_cards.SPELL_CARD_ONE:
			$SpellCardTimer.start(3.5)
			print($SpellCardTimer.wait_time)
			spell_card=spell_cards.PAUSE
		spell_cards.PAUSE:
			$SpellCardTimer.start(10.0)
			print($SpellCardTimer.wait_time)
			spell_card = spell_cards.SPELL_CARD_ONE
	
