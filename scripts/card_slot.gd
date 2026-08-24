extends PanelContainer

@onready var current_card : Card
@onready var icon = $Icon
@onready var fire_button = $FireButton

@export var type = 1

var icon_loaded = false

func _ready() -> void:
	if type == 1:
		icon.texture = load("res://assets/images/card_icons/attack_card_default.png")
	else:
		icon.texture = load("res://assets/images/card_icons/ability_card_default.png")
	update()
	
func _process(delta: float) -> void:
	update()
			
func update() -> void:
	if current_card != null and not icon_loaded:
		icon.texture = load("res://assets/images/card_icons/" + current_card.icon_path)
		icon_loaded = true

func _on_fire_button_pressed() -> void:
	if type == 1:
		gm.current_attack_cards[gm.current_attack_cards.find(current_card)] = null
		icon.texture = load("res://assets/images/card_icons/attack_card_default.png")
	else:
		gm.current_ability_cards[gm.current_ability_cards.find(current_card)] = null
		icon.texture = load("res://assets/images/card_icons/ability_card_default.png")
	current_card = null
	icon_loaded = false
