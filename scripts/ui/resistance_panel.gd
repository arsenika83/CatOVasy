extends Panel

@onready var icon = $Icon
@onready var label = $Label
@onready var amount_label = $AmountLabel

@onready var might_icon = preload("res://assets/images/elements/might_element.png")
@onready var fire_icon = preload("res://assets/images/elements/fire_element.png")
@onready var wind_icon = preload("res://assets/images/elements/wind_element.png") 
@onready var death_icon = preload("res://assets/images/elements/death_element.png")
@onready var life_icon = preload("res://assets/images/elements/life_element.png") 
@onready var luck_icon = preload("res://assets/images/elements/luck_element.png") 
@onready var accuracy_icon = preload("res://assets/images/elements/accuracy_element.png")
@onready var energy_icon = preload("res://assets/images/elements/energy_element.png") 

var amount = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_element(el, amount):
	if amount == 0:
		return
	
	amount_label.text = str(int(amount*100), "%")
	match el:
		"might":
			label.text = "СОПРОТИВЛЕНИЕ СИЛЕ"
			icon.texture = might_icon
		"fire":
			label.text = "СОПРОТИВЛЕНИЕ ОГНЮ"
			icon.texture = fire_icon
		"wind":
			label.text = "СОПРОТИВЛЕНИЕ ВЕТРУ"
			icon.texture = wind_icon
		"death":
			label.text = "СОПРОТИВЛЕНИЕ СМЕРТИ"
			icon.texture = death_icon
		"life":
			label.text = "СОПРОТИВЛЕНИЕ ЖИЗНИ"
			icon.texture = life_icon
		"luck":
			label.text = "СОПРОТИВЛЕНИЕ УДАЧЕ"
			icon.texture = luck_icon
		"accuracy":
			label.text = "СОПРОТИВЛЕНИЕ ТОЧНОСТИ"
			icon.texture = accuracy_icon
		"energy":
			label.text = "СОПРОТИВЛЕНИЕ ЭНЕРГИИ"
			icon.texture = energy_icon
