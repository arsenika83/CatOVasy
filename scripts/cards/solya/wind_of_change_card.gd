class_name WindOfChangeCard extends Card

var card_path = "wind_of_change_card.tscn"
var icon_path = "wind_of_change_card.png"
var tool_tip_text = ""
var card_name = "Ветер перемен"
var card_description = "Следующие 2 замены карт будут бесплатными"
var rarity = "common"

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
		str("- [color=#fdd14d]Ветер перемен:[/color] [color=#1ca8fd]Соля[/color] получает 2 бесплатные замены карт\n"))
	 
	get_parent().get_parent().get_parent().get_parent().wind_fx.position = get_parent().get_parent().get_parent().get_parent().human.position - Vector2(16, 32)
	get_parent().get_parent().get_parent().get_parent().wind_fx.play("hit")
	get_parent().get_parent().get_parent().get_parent().human.sprite.play("wind")
	get_parent().get_parent().get_parent().get_parent().human.idle_animation_timer.start(0.3)
	
	var tween = create_tween()
	tween.tween_property(get_parent().get_parent().get_parent().get_parent().wind_fx, 
	"position:x", 
	get_parent().get_parent().get_parent().get_parent().wind_fx.position.x + 48, 
	0.2)
	
	var tween1 = create_tween()
	tween1.tween_property(get_parent().get_parent().get_parent().get_parent().human.sprite, 
	"position:x", 
	get_parent().get_parent().get_parent().get_parent().human.sprite.position.x + 4, 
	0.2)
	
	tween1.tween_property(get_parent().get_parent().get_parent().get_parent().human.sprite, 
	"position:x", 
	get_parent().get_parent().get_parent().get_parent().human.sprite.position.x, 
	0.2)
	
	gm.current_energy_human -= energy_cost
	get_parent().get_parent().free_changes += 2
