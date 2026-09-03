extends PanelContainer

@onready var current_card : Card
@onready var icon = $Icon
@onready var fire_button = $FireButton
@onready var audio = $AudioStreamPlayer

@export var type = 1
@export var rarity = "common"
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
		tooltip_text = ""
		rarity = current_card.rarity
		icon_loaded = true

func clear() -> void:
	current_card = null
	icon_loaded = false
	fire_button.disabled = true
	tooltip_text = "Пустой слот \nдля карты"
	icon.texture = load("res://assets/images/card_icons/attack_card_default.png")

func _on_fire_button_pressed() -> void:
	if gm.state != "checking_inventory":
		return
		
	get_parent().get_parent().get_parent().card_check_dialog.visible = false
	audio.pitch_scale = randf_range(0.8, 1.1)
	audio.play()
	
	if get_parent().get_parent().get_parent().state == "cat":
		if gm.current_cards_cat.erase(id):
			print(id)
	else:
		if gm.current_cards_human.erase(id):
			print(id)		
		
	tooltip_text = "Пустой слот \nдля карты"
	icon.texture = load("res://assets/images/card_icons/attack_card_default.png")
	
	get_parent().get_parent().get_parent().get_parent().get_parent().draw_upgrade_stats(rarity)
		
	current_card = null
	fire_button.disabled = true
	icon_loaded = false
	

func _on_fire_button_mouse_entered() -> void:
	if current_card != null:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
		$AudioStreamPlayerHover.play()
	
	if get_parent().get_parent().get_parent().card_check_dialog.visible == false:
		get_parent().get_parent().get_parent().draw_card_check_dialog(current_card)
	else:
		get_parent().get_parent().get_parent().card_check_dialog.visible = false

func _on_fire_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	
	if get_parent().get_parent().get_parent().card_check_dialog.visible == false:
		get_parent().get_parent().get_parent().draw_card_check_dialog(current_card)
	else:
		get_parent().get_parent().get_parent().card_check_dialog.visible = false	
