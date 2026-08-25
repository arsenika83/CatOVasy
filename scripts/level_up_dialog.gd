extends Control

@onready var cards = $Cards


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_cards() -> void:
	for card in cards.get_children():
		cards.remove_child(card)
	
	for i in range(0, 3):
		var card_scene = load("res://scenes/cards/attack_double_claw_card.tscn")
		var card = card_scene.instantiate()
		
		cards.add_child(card)
		
	for child in cards.get_children():
		if child.has_signal("card_picked_up"):
			child.card_picked_up.connect(_on_card_picked_up)

func _on_card_picked_up(picked_card : Card) -> void:
	if picked_card.type == "attack":
		if gm.current_attack_cards.size() <= 5:
			for i in range(1, 6):
				if gm.current_attack_cards.has(i):
					continue
				gm.current_attack_cards.set(i, picked_card)
				break
			
			visible = false
			position.x = -1500
			gm.state = "idle"
		else:
			return
	elif picked_card.type == "ability":
		if gm.current_ability_cards.size() < 5:
			for i in range(1, 6):
				if gm.current_ability_cards.has(i):
					continue
				gm.current_ability_cards.set(i, picked_card)
				break
				
			visible = false
			position.x = -1500
			gm.state = "idle"
		else:
			return		

func _on_fire_button_1_pressed() -> void:
	visible = false
	position.x = -1500
	gm.state = "idle"

func _on_fire_button_2_pressed() -> void:
	visible = false
	position.x = -1500
	gm.state = "idle"

func _on_fire_button_3_pressed() -> void:
	visible = false
	position.x = -1500
	gm.state = "idle"

func _on_mouse_entered() -> void:
	gm.state = "leveling_up"
