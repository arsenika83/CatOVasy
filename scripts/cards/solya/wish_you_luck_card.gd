class_name WishYouLuckCard extends Card

var card_path = "wish_you_luck_card.tscn"
var icon_path = "wish_you_luck_card.png"
var tool_tip_text = ""
var card_name = "Желаю удачи!"
var card_description = "Следующий удар кота будет удачным!"
var rarity = "rare"

func _ready() -> void:
	element = "luck"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	$Label.text = "Желаю удачи!"
	type = "buff"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_human -= energy_cost
	
	get_parent().get_parent().get_parent().get_parent().log_messages.append(
		str("-[color=#1ca8fd]Соля[/color] [color=#fdd14d]желает удачи[/color] коту! Следующий его удар будет удачным\n"))
	 
	get_parent().get_parent().get_parent().get_parent().giant.luck_particles.restart()
	get_parent().get_parent().get_parent().get_parent().giant.audio_meow.play()
	get_parent().get_parent().get_parent().get_parent().giant.next_strike_lucky = true
	
	get_parent().get_parent().get_parent().get_parent().human.idle_animation_timer.start(0.6)
	
	
