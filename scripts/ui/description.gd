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
@onready var food_icon = preload("res://assets/images/elements/food_element.png") 

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	get_element()

func get_element():
	var el = get_parent().element
	
	match el:
		"might":
			element.text = "[color=#d13738]СИЛА[/color]"
			icon.texture = might_icon
		"fire":
			element.text = "[color=#ff9c61]ОГОНЬ[/color]"
			icon.texture = fire_icon
		"wind":
			element.text = "[color=#b1dcee]ВЕТЕР[/color]"
			icon.texture = wind_icon
		"death":
			element.text = "[color=#7800ba]СМЕРТЬ[/color]"
			icon.texture = death_icon
		"life":
			element.text = "[color=#5dc3ff]ЖИЗНЬ[/color]"
			icon.texture = life_icon
		"luck":
			element.text = "[color=#a5da70]УДАЧА[/color]"
			icon.texture = luck_icon
		"accuracy":
			element.text = "[color=#f6b732]ТОЧНОСТЬ[/color]"
			icon.texture = accuracy_icon
		"unluck":
			element.text = "[color=#ba037e]НЕУДАЧА[/color]"
			icon.texture = unluck_icon
		"inaccuracy":
			element.text = "[color=#32f69b]НЕТОЧНОСТЬ[/color]"
			icon.texture = inaccuracy_icon	
		"energy":
			element.text = "[color=#fd4d4f]ЭНЕРГИЯ[/color]"
			icon.texture = energy_icon
		"food":
			element.text = "[color=#d45009]ЕДА[/color]"
			icon.texture = food_icon
			
