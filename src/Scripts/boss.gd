extends Foe
class_name Boss

var spell_card

enum spell_cards {
	SPELL_CARD_ONE,
	PAUSE,
	BIG_ASS_BULLET
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.health = 1500
	$HealthBar.max_value = health
	$HealthBar.value = health
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
		self.spell_cards.BIG_ASS_BULLET:
			big_ass_bullet_card()

func _on_foe_take_damage() -> void:
	self.health-=1
	$HealthBar.value-=1
	if self.health <0:
		die()


func spell_card_one():
	circle_shot(diamond, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.DIAMOND)
	spiral_shot(syringe, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.SYRINGE)
	random_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.CIRCLE_BULLET, 10)

func big_ass_bullet_card():
	aimed_shot(big_ass_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.BIG_ASS_BULLET)
	circle_shot(syringe, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.SYRINGE)
	

func _on_spell_card_timer_timeout() -> void:
	match spell_card:
		spell_cards.SPELL_CARD_ONE:
			$SpellCardTimer.start(3.5)
			spell_card=spell_cards.PAUSE
		spell_cards.PAUSE:
			$SpellCardTimer.start(10.0)
			spell_card = spell_cards.BIG_ASS_BULLET
	
