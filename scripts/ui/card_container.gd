extends Control

var current_selected: Control = null

const ATTACK_CARD = preload("res://scenes/cards/attack_card.tscn")
const DEFEND_CARD = preload("res://scenes/cards/defend_card.tscn")

@onready var attack_cards_ui = $AttackCards
@onready var attack_change_button = $AttackChangeButton
var attack_cards : Array[Card]
var attack_card_index = 0

@onready var defend_cards_ui = $DefendCards
@onready var defend_change_button = $DefendChangeButton
var defend_cards : Array[Card]
var defend_card_index = 0

@onready var ability_cards_ui = $AbilityCards
@onready var ability_change_button = $AbilityChangeButton
var ability_cards : Array[Card]
var ability_card_index = 0

@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	var time_offset = 0
	var y_offset = 0
	
	for card in gm.current_attack_cards.values():
		var card_resource = load("res://scenes/cards/" + card.card_path)
		var added_card = card_resource.instantiate()
		
		attack_cards_ui.add_child(added_card)
		attack_cards.append(added_card)
		
		added_card.material.set_shader_parameter("time_offset", time_offset)
		added_card.position.y += y_offset
		y_offset = 300
	
	for child in attack_cards_ui.get_children():
		if child.has_signal("card_clicked"):
			child.card_clicked.connect(_on_card_selected)
			child.card_played.connect(_on_card_played)
			
	time_offset += 1.0
	y_offset = 0
	for card in gm.current_defend_cards.values():
		var card_resource = load("res://scenes/cards/" + card.card_path)
		var added_card = card_resource.instantiate()
		
		defend_cards_ui.add_child(added_card)
		defend_cards.append(added_card)

		added_card.material.set_shader_parameter("time_offset", time_offset)
		added_card.position.y += y_offset
		y_offset = 300
			
	for child in defend_cards_ui.get_children():
		if child.has_signal("card_clicked"):
			child.card_clicked.connect(_on_card_selected)	
			child.card_played.connect(_on_card_played)	
	time_offset += 1.0
	y_offset = 0
	
	for card in gm.current_ability_cards.values():
		var card_resource = load("res://scenes/cards/" + card.card_path)
		var added_card = card_resource.instantiate()
		
		ability_cards_ui.add_child(added_card)
		ability_cards.append(added_card)

		added_card.material.set_shader_parameter("time_offset", time_offset)
		added_card.position.y += y_offset
		y_offset = 300

	for child in ability_cards_ui.get_children():
		if child.has_signal("card_clicked"):
			child.card_clicked.connect(_on_card_selected)
			child.card_played.connect(_on_card_played)

func replace_current_card(type : String):
	match type:
		"attack":
			if attack_cards.size() == 1:
				return
			current_selected.deselect_card()
			current_selected = null
	
			attack_cards[attack_card_index].move_back()
			attack_card_index += 1
			
			if attack_card_index == attack_cards.size():
				attack_card_index = 0
				
			current_selected = attack_cards[attack_card_index]
			current_selected.move_front(-30)
			
		"ability":
			if ability_cards.size() == 1:
				return
				
			current_selected.deselect_card()
			current_selected = null
			
			ability_cards[ability_card_index].move_back()
			ability_card_index += 1
			
			if ability_card_index == ability_cards.size():
				ability_card_index = 0
				
			current_selected = ability_cards[ability_card_index]	
			current_selected.move_front(-30)

func replace_card(type : String):
	match type:
		"attack":
			attack_cards[attack_card_index].move_back()
			attack_card_index += 1
			
			if attack_card_index == attack_cards.size():
				attack_card_index = 0
				
			attack_cards[attack_card_index].move_front()
			
		"ability":
			ability_cards[ability_card_index].move_back()
			ability_card_index += 1
			
			if ability_card_index == ability_cards.size():
				ability_card_index = 0
				
			ability_cards[ability_card_index].move_front()	

func _on_card_selected(clicked_card: Control) -> void:
	# Если кликнули по уже выбранной карточке — ничего не делаем
	audio.play()
	if current_selected == clicked_card:
		current_selected.deselect_card()
		current_selected = null
		return
		
	# 1. Если до этого была выбрана другая карточка — сбрасываем её
	if current_selected != null:
		current_selected.deselect_card()
		
	current_selected = clicked_card
	current_selected.select_card()
	
func _on_card_played(played_card: Control) -> void:

	current_selected.deselect_card()
	current_selected = null
		
	print("SIGNAL TEST")
	var tween = create_tween()
	tween.tween_property(played_card, "position:y", played_card.position.y + 300, 0.5)
	

func _on_attack_change_button_pressed() -> void:
	if gm.current_energy - 1 >= 0:
		audio.play()
		gm.current_energy -= 1
		replace_card("attack")
		
		if gm.current_energy == 0:
			get_parent().get_parent().end_turn()

func _on_defend_change_button_pressed() -> void:
	if gm.current_energy - 1 >= 0:
		audio.play()
		#gm.current_energy -= 1
		replace_card("defend")
		
		if gm.current_energy == 0:
			get_parent().get_parent().end_turn()

func _on_ability_change_button_pressed() -> void:
	if gm.current_energy - 1 >= 0:
		audio.play()
		gm.current_energy -= 1
		replace_card("ability")
		
		if gm.current_energy == 0:
			get_parent().get_parent().end_turn()
