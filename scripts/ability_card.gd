class_name AbilityCard extends Card

var card_path = "ability_card.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_modifier = "_ability"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
