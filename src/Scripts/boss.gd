extends Foe
class_name Boss

var spell_card

enum spell_cards {
	BASIC_SPELL,
	PAUSE,
	BIG_ASS_BULLET,
	RAIN_FROM_ABOVE,
	PAUSE_UNTIL_RATIO_100
}

enum parts {
	ONE, 
	TWO, 
	THREE
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.health = 1500
	$HealthBar.max_value = health
	$HealthBar.value = health
	self.spell_card = spell_cards.RAIN_FROM_ABOVE
	#self.spell_card = spell_cards.BASIC_SPELL
	$Foe/ShootTimer.stop()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	if progress_ratio > .98:
		progress_ratio = 1.0
		$SpellCardTimer.start(30)
		self.spell_card = self.spell_cards.BASIC_SPELL
		$Foe/ShootTimer.start(.05)
		$Foe/ShootTimer2.start(.05)
		$Foe/ShootTimer3.start(.05)
		get_parent().curve.clear_points()

func _on_shoot_timer_timeout():
	# Overrides super class func
	match self.spell_card:
		self.spell_cards.BASIC_SPELL:
			basic_spell(parts.ONE)
		self.spell_cards.BIG_ASS_BULLET:
			big_ass_bullet_card(parts.ONE)
		self.spell_cards.RAIN_FROM_ABOVE:
			rain_from_above()
	pass

func _on_foe_take_damage() -> void:
	self.health-=1
	$HealthBar.value-=1
	if self.health <0:
		die()


func basic_spell(part):
	
	match part:
		self.parts.ONE:
			$Foe/ShootTimer.start(1)
			circle_shot(diamond, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.DIAMOND)
		self.parts.TWO:
			$Foe/ShootTimer2.start(.08)
			spiral_shot(syringe, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.SYRINGE)
		self.parts.THREE:
			$Foe/ShootTimer3.start(.1)
			random_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.CIRCLE_BULLET, 10)


func rain_from_above():
	#circle_shot(diamond, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.DIAMOND)
	sweep_shot(diamond, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.DIAMOND)
	random_shot(circle_bullet, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.CIRCLE_BULLET, 10)

func big_ass_bullet_card(part):
	match part:
		self.parts.ONE:
			$Foe/ShootTimer.start(1)
			aimed_shot(big_ass_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.BIG_ASS_BULLET)
		self.parts.TWO:
			$Foe/ShootTimer2.start(.5)
			circle_shot(syringe, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.SYRINGE)
		self.parts.THREE:
			pass
	

func _on_spell_card_timer_timeout() -> void:
	match spell_card:
		spell_cards.BASIC_SPELL:
			$SpellCardTimer.start(30)
			spell_card=spell_cards.PAUSE
		spell_cards.PAUSE:
			$SpellCardTimer.start(10.0)
			spell_card = spell_cards.BIG_ASS_BULLET


func _on_timeout_timer_timeout() -> void:
	get_parent().curve.clear_points()
	get_parent().curve.add_point(self.position, Vector2(0,0), Vector2(0,0))
	get_parent().curve.add_point(Vector2(get_viewport_rect().size.x+100, 200), Vector2(0,0), Vector2(0,0))
	self.progress_ratio = 0
	


func _on_shoot_timer_2_timeout():
	# Overrides super class func
	match self.spell_card:
		self.spell_cards.BASIC_SPELL:
			basic_spell(parts.TWO)
		self.spell_cards.BIG_ASS_BULLET:
			big_ass_bullet_card(parts.TWO)
	pass


func _on_shoot_timer_3_timeout():
	# Overrides super class func
	match self.spell_card:
		self.spell_cards.BASIC_SPELL:
			basic_spell(parts.THREE)
		self.spell_cards.BIG_ASS_BULLET:
			big_ass_bullet_card(parts.THREE)
	pass
