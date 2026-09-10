class_name FortuneWheelCard extends Card

var card_path = "fortune_wheel_card.tscn"
var icon_path = "fortune_wheel_card.png"
var tool_tip_text = ""
var card_name = "Колесо фортуны"
var card_description = "Дает Соле и коту 7 удачи на 2 хода"
var rarity = "rare"
var buff_type = "luck"
var luck = 7
var turns = 2

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "buff"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().log_messages.append(
		str("- [color=#fdd14d]Колесо фортуны[/color]: [color=#1ca8fd]Соля[/color] и [color=#1ca8fd]Кот[/color] получают +7% к удаче!\n"))
		
	get_parent().get_parent().get_parent().get_parent().giant.sprite.rotation_degrees = 360
	var tween1 = create_tween()
	tween1.tween_property(get_parent().get_parent().get_parent().get_parent().giant.sprite, "rotation_degrees", 0, 0.2)
		
	var targets : Array[CharacterBody2D] = [get_parent().get_parent().get_parent().get_parent().giant, get_parent().get_parent().get_parent().get_parent().human]
	get_parent().get_parent().get_parent().get_parent().human.give_buff(targets, buff_type, luck, turns)
	
