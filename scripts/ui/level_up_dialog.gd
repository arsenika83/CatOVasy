extends Control

@onready var cards = $Cards
@onready var level_label = $LevelLabel

@onready var audio = $AudioStreamPlayer
@onready var audio_burn = $AudioStreamPlayerBurn

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_cards() -> void:
	for card in cards.get_children():
		pass
		cards.remove_child(card)
		card.queue_free()
	
	for i in range(0, 3):
		var card_index = randi_range(0, catalog.all_card_names.size()-1)
		var card_name = catalog.all_card_names.get(card_index)
		var card_scene = load("res://scenes/cards/" + card_name + "_card.tscn")
		var card = card_scene.instantiate()
		
		cards.add_child(card)
		
	for child in cards.get_children():
		if child.has_signal("card_picked_up"):
			child.card_picked_up.connect(_on_card_picked_up)

func _on_card_picked_up(picked_card : Card) -> void:
	audio.pitch_scale = randf_range(0.8, 1.1)
	audio.play()
	if picked_card.type == "attack":
		if gm.current_attack_cards.size() <= 5:
			for i in range(1, 6):
				if gm.current_attack_cards.has(i):
					continue
					
				gm.add_attack_card(i, picked_card)
				break
		else:
			return
	elif picked_card.type == "ability":
		if gm.current_ability_cards.size() < 5:
			for i in range(1, 6):
				if gm.current_ability_cards.has(i):
					continue
					
				gm.add_ability_card(i, picked_card)
				break
		else:
			return
	
	if get_parent().get_parent().giant.check_xp():
		get_parent().get_parent().draw_level_up()
	else:
		visible = false
		position.x = -1500
		gm.state = "idle"
	

func _on_fire_button_1_pressed() -> void:
	audio_burn.pitch_scale = randf_range(0.8, 1.1)
	audio_burn.play()
	visible = false
	position.x = -1500
	get_parent().get_parent().draw_upgrade_stats(cards.get_child(0).rarity)

func _on_fire_button_2_pressed() -> void:
	audio_burn.pitch_scale = randf_range(0.8, 1.1)
	audio_burn.play()
	visible = false
	position.x = -1500
	get_parent().get_parent().draw_upgrade_stats(cards.get_child(1).rarity)

func _on_fire_button_3_pressed() -> void:
	audio_burn.pitch_scale = randf_range(0.8, 1.1)
	audio_burn.play()
	visible = false
	position.x = -1500
	get_parent().get_parent().draw_upgrade_stats(cards.get_child(2).rarity)

func _on_mouse_entered() -> void:
	gm.state = "leveling_up"
