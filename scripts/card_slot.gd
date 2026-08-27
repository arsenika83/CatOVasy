extends PanelContainer

@onready var current_card : Card
@onready var icon = $Icon
@onready var fire_button = $FireButton
@onready var audio = $AudioStreamPlayer

@export var type = 1
@export var id = 0

var icon_loaded = false

func _ready() -> void:
	if current_card == null:
		fire_button.disabled = true
		if type == 1:
			tooltip_text = "Пустой слот \nдля карты \nатаки"
			icon.texture = load("res://assets/images/card_icons/attack_card_default.png")
		else:
			tooltip_text = "Пустой слот \nдля карты \nспособности"
			icon.texture = load("res://assets/images/card_icons/ability_card_default.png")
		update()
	
func _process(delta: float) -> void:
	update()
			
func update() -> void:
	if current_card != null and not icon_loaded:
		fire_button.disabled = false
		icon.texture = load("res://assets/images/card_icons/" + current_card.icon_path)
		tooltip_text = current_card.tool_tip_text
		icon_loaded = true

func _on_fire_button_pressed() -> void:
	if gm.state != "checking_inventory":
		return
		
	audio.pitch_scale = randf_range(0.8, 1.1)	
	audio.play()
	if type == 1:
		if gm.current_attack_cards.erase(id):
			print(id)
		
		tooltip_text = "Пустой слот \nдля карты \nатаки"
		icon.texture = load("res://assets/images/card_icons/attack_card_default.png")
	else:
		if gm.current_ability_cards.erase(id):
			print(id)
		
		tooltip_text = "Пустой слот \nдля карты \nспособности"
		icon.texture = load("res://assets/images/card_icons/ability_card_default.png")
	get_parent().get_parent().get_parent().get_parent().draw_upgrade_stats(current_card.rarity)
		
	current_card = null
	fire_button.disabled = true
	icon_loaded = false
	
	
