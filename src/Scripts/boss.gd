extends Foe
class_name Boss

var inc: float = 0.0
var spell_card
var rng = RandomNumberGenerator.new()
var first_move:bool = true
var spell_card_idx: int
var base_card_idx: int
var spell_card_length: float = 45.0
var movement_stopped: bool = false
var bab_timer = 0.7
var screen_size

enum spell_cards {
	CHAOTIC_TRACKED,
	PAUSE,
	BIG_ASS_BULLET,
	RAIN_FROM_ABOVE,
	CLAUSTROPHOBIA,
	FINAL_SPELL,
	PAUSE_UNTIL_RATIO_100
}

enum parts {
	ONE, 
	TWO, 
	THREE
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.animation = "idle"
	self.health = 1000
	$HealthBar.max_value = health
	$HealthBar.value = health
	self.spell_card = spell_cards.CLAUSTROPHOBIA
	#self.spell_card = spell_cards.RAIN_FROM_ABOVE
	#self.spell_card = spell_cards.CHAOTIC_TRACKED
	$Foe/ShootTimer.stop()
	first_move = true
	spell_card_idx = 0
	base_card_idx = 0
	inc = 10.0
	self.SPEED = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	position = position.clamp(Vector2(screen_size.x/5, 0), Vector2(4*screen_size.x/5, screen_size.y/4))
	if progress_ratio > .98:
		if first_move:
			progress_ratio = 1.0
			$SpellCardTimer.start(spell_card_length)
			
			self.spell_card = self.spell_cards.BIG_ASS_BULLET # BIG_ASS_BULLET should be the default
			
			$Foe/ShootTimer.start(.05)
			$Foe/ShootTimer2.start(.05)
			$Foe/ShootTimer3.start(.05)
			get_new_move_curve()
			first_move = !first_move
		else:
			$MoveTimer.start(3)
			get_parent().curve.clear_points()

func get_new_move_curve():
	var vp_size = get_viewport_rect().size
	get_parent().curve.clear_points()
	get_parent().curve.add_point(self.position, Vector2(0,0), Vector2(0,0))
	get_parent().curve.add_point(Vector2( rng.randf_range( 2*vp_size.x/7 , 4 * vp_size.x/7), rng.randf_range(0, vp_size.y/4)), Vector2(0,0), Vector2(0,0))
	self.progress_ratio = 0

func move_to_center():
	var vp_size = get_viewport_rect().size
	get_parent().curve.clear_points()
	get_parent().curve.add_point(self.position, Vector2(0,0), Vector2(0,0))
	get_parent().curve.add_point(Vector2(vp_size.x / 2, vp_size.y / 4), Vector2(0,0), Vector2(0,0))
	$MoveTimer.stop()

func _on_foe_take_damage() -> void:
	self.health-=10
	$HealthBar.value-=10
	if self.health <0:
		progress_spellcards()

func chaotic_tracked(part):
	match part:
		self.parts.ONE:
			$Foe/ShootTimer.start(1)
			circle_shot(diamond, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.DIAMOND)
		self.parts.TWO:
			$Foe/ShootTimer2.start(.1)
			spiral_shot(syringe, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.SYRINGE)
		self.parts.THREE:
			$Foe/ShootTimer3.start(.2)
			random_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.CIRCLE_BULLET, 10)

func rain_from_above(part):
	match part:
		self.parts.ONE:
			$Foe/ShootTimer.start(.02)
			sweep_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.CIRCLE_BULLET)
		self.parts.TWO:
			# TODO: Replace diamonds with lasers to help with chunking
			$Foe/ShootTimer2.start(.5)
			inverted_fan_shot(diamond, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.DIAMOND, 100, PI/8)
		self.parts.THREE:
			$Foe/ShootTimer3.start(2)
			aimed_shot(big_ass_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.BIG_ASS_BULLET)

func big_ass_bullet_card(part, part_two_timer=0.2):
	match part:
		self.parts.ONE:
			$Foe/ShootTimer.start(1)
			aimed_shot(big_ass_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.BIG_ASS_BULLET)
		self.parts.TWO:
			$Foe/ShootTimer2.start(part_two_timer)
			circle_shot(syringe, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.SYRINGE)
		self.parts.THREE:
			pass

func claustrophobia(part):
	$MoveTimer.stop()
	movement_stopped = true
	move_to_center()
	match part:
		self.parts.ONE:
			$Foe/ShootTimer.start(.02)
			#sweep_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.CIRCLE_BULLET)
		self.parts.TWO:
			$Foe/ShootTimer2.start(.5)
			inc += 2
			inverted_fan_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.CIRCLE_BULLET, 100, PI/inc)
		self.parts.THREE:
			$Foe/ShootTimer3.start(.2)
			aimed_shot(diamond, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.DIAMOND)

func final_spell(part):
	
	match part:
		self.parts.ONE:
			$Foe/ShootTimer.start(2)
			aimed_shot(big_ass_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.BIG_ASS_BULLET)
		self.parts.TWO:
			$Foe/ShootTimer2.start(.05)
			galactic_sweep_shot(circle_bullet, Enums.Shot_Movement.CONSTANT, Enums.Shot_Types.CIRCLE_BULLET, 12, 20, PI/4)
		self.parts.THREE:
			$Foe/ShootTimer3.start(5)
			circle_shot(syringe, Enums.Shot_Movement.CONST_PAUSE_AIM, Enums.Shot_Types.SYRINGE, .01)

func _on_spell_card_timer_timeout() -> void:
	progress_spellcards()

func progress_spellcards() -> void:
	
	print(spell_cards)
	print("index: ", spell_card_idx)
	
	match spell_card:
		spell_cards.CHAOTIC_TRACKED:
			$SpellCardTimer.start(3.0)
			spell_card=spell_cards.PAUSE
			self.health = 1000
			$HealthBar.value = self.health
		spell_cards.BIG_ASS_BULLET:
			$SpellCardTimer.start(2.0)
			spell_card=spell_cards.PAUSE
			self.health = 1000
			if spell_card_idx == 6:
				await get_tree().create_timer(7).timeout
				SignalManager.textbox_ping.emit()
		spell_cards.RAIN_FROM_ABOVE:
			$SpellCardTimer.start(2.0)
			spell_card=spell_cards.PAUSE
			self.health = 1000
		spell_cards.CLAUSTROPHOBIA:
			$SpellCardTimer.start(2.0)
			spell_card=spell_cards.PAUSE
			self.health = 1000
			$HealthBar.value = self.health
		spell_cards.PAUSE:
			
			if movement_stopped:
				$MoveTimer.start(3)
				movement_stopped = false
			spell_card_idx += 1
			
			if spell_card_idx % 2 == 0:
				if spell_card_idx <= 6:
					$SpellCardTimer.start(spell_card_length)
					spell_card = spell_cards.BIG_ASS_BULLET
					bab_timer -= 0.05
					self.health = 1000
					$HealthBar.value = self.health
				else:
					die()
			elif spell_card_idx == 1:
				$SpellCardTimer.start(spell_card_length)
				spell_card = spell_cards.CLAUSTROPHOBIA
				self.health = 1000
				$HealthBar.value = self.health
			elif spell_card_idx == 3:
				$SpellCardTimer.start(spell_card_length)
				spell_card = spell_cards.RAIN_FROM_ABOVE
				self.health = 1000
				$HealthBar.value = self.health
			elif spell_card_idx == 5:
				$SpellCardTimer.start(spell_card_length)
				spell_card = spell_cards.CHAOTIC_TRACKED
				self.health = 1000
				$HealthBar.value = self.health
			elif spell_card_idx == 7:
				await get_tree().create_timer(10).timeout
				$SpellCardTimer.start(spell_card_length)
				spell_card = spell_cards.FINAL_SPELL
				self.health = 1000
				$HealthBar.value = self.health
				
		spell_cards.PAUSE:
			$SpellCardTimer.start(2.0)
			spell_card = spell_cards.PAUSE

func _on_timeout_timer_timeout() -> void:
	get_parent().curve.add_point(Vector2(get_viewport_rect().size.x+100, 200), Vector2(0,0), Vector2(0,0))
	self.progress_ratio = 0

func _on_move_timer_timeout() -> void:
	get_new_move_curve()

func _on_shoot_timer_timeout():
	# Overrides super class func
	match self.spell_card:
		self.spell_cards.CHAOTIC_TRACKED:
			chaotic_tracked(parts.ONE)
		self.spell_cards.BIG_ASS_BULLET:
			big_ass_bullet_card(parts.ONE)
		self.spell_cards.RAIN_FROM_ABOVE:
			rain_from_above(parts.ONE)
		self.spell_cards.CLAUSTROPHOBIA:
			claustrophobia(parts.ONE)
		self.spell_cards.FINAL_SPELL:
			final_spell(parts.ONE)
	pass

func _on_shoot_timer_2_timeout():
	# Overrides super class func
	match self.spell_card:
		self.spell_cards.CHAOTIC_TRACKED:
			chaotic_tracked(parts.TWO)
		self.spell_cards.BIG_ASS_BULLET:
			big_ass_bullet_card(parts.TWO, bab_timer)
		self.spell_cards.RAIN_FROM_ABOVE:
			rain_from_above(parts.TWO)
		self.spell_cards.CLAUSTROPHOBIA:
			claustrophobia(parts.TWO)
		self.spell_cards.FINAL_SPELL:
			final_spell(parts.TWO)
	pass

func _on_shoot_timer_3_timeout():
	# Overrides super class func
	match self.spell_card:
		self.spell_cards.CHAOTIC_TRACKED:
			chaotic_tracked(parts.THREE)
		self.spell_cards.BIG_ASS_BULLET:
			big_ass_bullet_card(parts.THREE)
		self.spell_cards.RAIN_FROM_ABOVE:
			rain_from_above(parts.THREE)
		self.spell_cards.CLAUSTROPHOBIA:
			claustrophobia(parts.THREE)
		self.spell_cards.FINAL_SPELL:
			final_spell(parts.THREE)
	pass
