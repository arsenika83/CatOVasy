extends TextureRect

@onready var label = $Label
@onready var icon = $Panel/Icon
@onready var element = $Panel/ElementLabel

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

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	get_element()

func get_element():
	var el = get_parent().element
	
	match el:
		"might":
			element.text = "СИЛА"
			icon.texture = might_icon
		"fire":
			element.text = "ОГОНЬ"
			icon.texture = fire_icon
		"wind":
			element.text = "ВЕТЕР"
			icon.texture = wind_icon
		"death":
			element.text = "СМЕРТЬ"
			icon.texture = death_icon
		"life":
			element.text = "ЖИЗНЬ"
			icon.texture = life_icon
		"luck":
			element.text = "УДАЧА"
			icon.texture = luck_icon
		"accuracy":
			element.text = "ТОЧНОСТЬ"
			icon.texture = accuracy_icon
		"unluck":
			element.text = "НЕУДАЧА"
			icon.texture = unluck_icon
		"inaccuracy":
			element.text = "НЕТОЧНОСТЬ"
			icon.texture = inaccuracy_icon	
		"energy":
			element.text = "ЭНЕРГИЯ"
			icon.texture = energy_icon			
			
