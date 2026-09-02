extends Control

var current_selected: Control = null

const ATTACK_CARD = preload("res://scenes/cards/attack_card.tscn")
const DEFEND_CARD = preload("res://scenes/cards/defend_card.tscn")

var card_change_energy_cost = 1

@onready var cards_ui = $Cards
@onready var change_button = $ChangeButton
@onready var change_cost = $ChangeButton/Label

@onready var unplayed_label = $UnplayedButton/Label
@onready var played_label = $PlayedButton/Label

var cards : Array[Card]

var played_cards : Array[Card]
var unplayed_cards : Array[Card]
var hand : Array[Card]

var card_index = 0

var card_change_amount = 0
var card_to_free : Control

@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	var card_count = 0
	
	var all_cards = gm.current_cards.values().duplicate()
	all_cards.shuffle()
	
	for card in all_cards:
		var card_resource = load("res://scenes/cards/" + card.card_path)
		var added_card = card_resource.instantiate()
		
		unplayed_cards.append(added_card)
		print(unplayed_cards)
	
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
	unplayed_label.text = str(unplayed_cards.size())
	played_label.text = "0"
	create_hand()

func _process(delta: float) -> void:
	if gm.current_energy > 0:
		$EndButton/StatusFX.visible = false
		$EndButton.disabled = false

func reset_unplayed_pile():
	for card in played_cards:
		unplayed_cards.append(card)
	played_cards.clear()
	#unplayed_cards.shuffle()

func create_hand():
	for child in cards_ui.get_children():
		child.destroy()
	$UpdateHandTimer.start()
		

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
	
func _on_card_played(played_card: Control) -> void:
	hand.remove_at(played_card.get_index())
	played_cards.append(played_card.duplicate())
	
	card_to_free = played_card

	current_selected.deselect_card()
	card_to_free.destroy()
	current_selected = null
	
	unplayed_label.text = str(unplayed_cards.size())
	played_label.text = str(played_cards.size())
	
	if gm.current_energy == 0:
		$EndButton/StatusFX.visible = true

	$DeleteCardTimer.start()

func _on_change_button_pressed() -> void:
	if gm.has_spinner:
		if card_change_amount < 2:
			card_change_energy_cost = 0
			
	if gm.current_energy - card_change_energy_cost >= 0:
		audio.play()
		gm.current_energy -= card_change_energy_cost
		
		for card in hand:
			cards_ui.get_child(card.get_index()).queue_free()
		create_hand()
	
	card_change_amount += 1
	if card_change_amount >= 2:
		card_change_energy_cost = 1
		
	change_cost.text = str(card_change_energy_cost)


func _on_end_button_pressed() -> void:
	gm.current_energy = 0
	get_parent().get_parent().end_turn()
	$EndButton.disabled = true
	$EndButton/StatusFX.visible = false


func _on_delete_card_timer_timeout() -> void:
	cards_ui.remove_child(card_to_free)
	card_to_free.queue_free()

func _on_hand_clear_timer_timeout() -> void:
	for card in hand:
		print(card.card_path)
		played_cards.append(card.duplicate())
		
	for child in cards_ui.get_children():
		cards_ui.remove_child(child)
		child.queue_free()
		
	hand.clear()
	var time_offset = 0
	
	for i in range(5):
		if unplayed_cards.size() > 0:
			var random_index = randi_range(0, unplayed_cards.size()-1)
			hand.append(unplayed_cards.get(random_index))
			unplayed_cards.remove_at(random_index)
		else:
			reset_unplayed_pile()
			var random_index = randi_range(0, unplayed_cards.size()-1)
			hand.append(unplayed_cards.get(random_index))
			unplayed_cards.remove_at(random_index)
	
	unplayed_label.text = str(unplayed_cards.size())
	played_label.text = str(played_cards.size())
	
	for card in hand:
		var card_resource = load("res://scenes/cards/" + card.card_path)
		var added_card = card_resource.instantiate()
		
		time_offset += 0.2
		added_card.material.set_shader_parameter("time_offset", time_offset)
		
		cards_ui.add_child(added_card)
		
	
	for child in cards_ui.get_children():
		if child.has_signal("card_clicked"):
			child.card_clicked.connect(_on_card_selected)
			child.card_played.connect(_on_card_played)
			child.create()
		
