extends Control

var current_selected: Control = null

const ATTACK_CARD = preload("res://scenes/cards/attack_card.tscn")
const DEFEND_CARD = preload("res://scenes/cards/defend_card.tscn")

var card_change_energy_cost = 1

@onready var cards_ui = $Cards
@onready var change_button = $ChangeButton
@onready var change_cost = $ChangeButton/Label
var cards : Array[Card]

var played_cards : Array[Card]
var unplayed_cards : Array[Card]
var hand : Array[Card]

var card_index = 0

var card_change_amount = 0
var card_to_free : Control

@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	var time_offset = 0
	var y_offset = 300
	var card_count = 0
	
	var all_cards = gm.current_cards.values().duplicate()
	all_cards.shuffle()
	
	for card in all_cards:
		var card_resource = load("res://scenes/cards/" + card.card_path)
		var added_card = card_resource.instantiate()
		
		unplayed_cards.append(added_card)
		print(unplayed_cards)
		
		added_card.material.set_shader_parameter("time_offset", time_offset)
		#cards_ui.add_child(added_card)
		time_offset += 0.3
	
	for child in cards_ui.get_children():
		if child.has_signal("card_clicked"):
			child.card_clicked.connect(_on_card_selected)
			child.card_played.connect(_on_card_played)
			
	if gm.has_spinner:
		if card_change_amount < 2:
			card_change_energy_cost = 0
		else:
			card_change_energy_cost = 1
	change_cost.text = str(card_change_energy_cost)
	create_hand()
	
func offset_card(node_a: Control, offset : int) -> void:

	var index_a = node_a.get_index()
	cards_ui.move_child(node_a, index_a + offset)

func _on_card_selected(clicked_card: Control) -> void:
	audio.play()
	
	if current_selected == clicked_card:
		current_selected.deselect_card()
		current_selected = null
		return
		
	if current_selected != null:
		current_selected.deselect_card()
		
	current_selected = clicked_card
	current_selected.select_card()
	gm.current_card = current_selected

func fill_unplayed_pile():
	for card in played_cards:
		unplayed_cards.append(card)
		played_cards.erase(card)
	unplayed_cards.shuffle()

func create_hand():
	for i in range(5):
		if unplayed_cards.size() > 0:
			hand.append(unplayed_cards.pop_at(i))
		else:
			pass
	
	for card in hand:
		var card_resource = load("res://scenes/cards/" + card.card_path)
		var added_card = card_resource.instantiate()
		
		cards_ui.add_child(added_card)
	
	for child in cards_ui.get_children():
		if child.has_signal("card_clicked"):
			child.card_clicked.connect(_on_card_selected)
			child.card_played.connect(_on_card_played)
		
	
func _on_card_played(played_card: Control) -> void:
	card_to_free = played_card

	current_selected.deselect_card()
	current_selected = null
	
	$DeleteCardTimer.start()

func _on_change_button_pressed() -> void:
	if gm.has_spinner:
		if card_change_amount < 2:
			card_change_energy_cost = 0
			
	if gm.current_energy - card_change_energy_cost >= 0:
		audio.play()
		gm.current_energy -= card_change_energy_cost
		#replace_card()
		
		if gm.current_energy == 0:
			get_parent().get_parent().end_turn()
	
	card_change_amount += 1
	if card_change_amount >= 2:
		card_change_energy_cost = 1
		
	change_cost.text = str(card_change_energy_cost)


func _on_end_button_pressed() -> void:
	print("REPLACE")
	#replace_all_cards()


func _on_delete_card_timer_timeout() -> void:
	cards_ui.get_child(card_to_free.get_index()).queue_free()
