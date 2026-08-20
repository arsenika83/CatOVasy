class_name DefendCard extends Card

var defend = 50
var card_path = "defend_card.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_modifier = "_defend"
	#label.text = str("+", defend, " брони")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
