extends HBoxContainer

var current_selected: Control = null

const ATTACK_CARD = preload("res://scenes/cards/attack_card.tscn")
const DEFEND_CARD = preload("res://scenes/cards/defend_card.tscn")

func _ready() -> void:
	var time_offset = 1.0
	
	for card in gm.current_cards:
		var card_resource = load("res://scenes/cards/" + card.card_path)
		var added_card = card_resource.instantiate()
		
		add_child(added_card)

		added_card.material.set_shader_parameter("time_offset", time_offset)
		time_offset += 1.0

	for child in get_children():
		if child.has_signal("card_clicked"):
			child.card_clicked.connect(_on_card_selected)

func _on_card_selected(clicked_card: Control) -> void:
	# Если кликнули по уже выбранной карточке — ничего не делаем
	if current_selected == clicked_card:
		current_selected.deselect_card()
		current_selected = null
		return
		
	# 1. Если до этого была выбрана другая карточка — сбрасываем её
	if current_selected != null:
		current_selected.deselect_card()
		
	# 2. Запоминаем новую карточку как выбранную
	current_selected = clicked_card
	
	# 3. Включаем у неё состояние выбора
	current_selected.select_card()
	
	# Здесь можно выполнить логику игры (например, обновить характеристики выбранного оружия)
	print("Выбран элемент: ", current_selected.name)
