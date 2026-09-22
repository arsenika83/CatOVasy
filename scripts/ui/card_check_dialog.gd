extends Control

@onready var card_name = $NameLabel
@onready var card_description = $DescriptionLabel
@onready var card_rarity = $RarityLabel
@onready var card_container = $Card
@onready var element_icon = $Panel/ElementIcon
@onready var element_label = $Panel/ElementLabel

@onready var might_icon = preload("res://assets/images/elements/might_element.png")
@onready var fire_icon = preload("res://assets/images/elements/fire_element.png")
@onready var wind_icon = preload("res://assets/images/elements/wind_element.png") 
@onready var death_icon = preload("res://assets/images/elements/death_element.png")
@onready var life_icon = preload("res://assets/images/elements/life_element.png") 
@onready var luck_icon = preload("res://assets/images/elements/luck_element.png") 
@onready var accuracy_icon = preload("res://assets/images/elements/accuracy_element.png")
@onready var unluck_icon = preload("res://assets/images/elements/unluck_element.png") 
@onready var inaccuracy_icon = preload("res://assets/images/elements/inaccuracy_element.png")
@onready var energy_icon = preload("res://assets/images/elements/energy_element.png")
@onready var food_icon = preload("res://assets/images/elements/food_element.png") 

var element = "might"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_element()
	
func get_element():
	match element:
		"might":
			element_label.text = "СИЛА"
			element_icon.texture = might_icon
		"fire":
			element_label.text = "ОГОНЬ"
			element_icon.texture = fire_icon
		"wind":
			element_label.text = "ВЕТЕР"
			element_icon.texture = wind_icon
		"death":
			element_label.text = "СМЕРТЬ"
			element_icon.texture = death_icon
		"life":
			element_label.text = "ЖИЗНЬ"
			element_icon.texture = life_icon
		"luck":
			element_label.text = "УДАЧА"
			element_icon.texture = luck_icon
		"accuracy":
			element_label.text = "ТОЧНОСТЬ"
			element_icon.texture = accuracy_icon
		"unluck":
			element_label.text = "НЕУДАЧА"
			element_icon.texture = unluck_icon
		"inaccuracy":
			element_label.text = "НЕТОЧНОСТЬ"
			element_icon.texture = inaccuracy_icon
		"energy":
			element_label.text = "ЭНЕРГИЯ"
			element_icon.texture = energy_icon
		"food":
			element_label.text = "ЕДА"
			element_icon.texture = food_icon	
