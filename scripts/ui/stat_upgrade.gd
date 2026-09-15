extends Control

signal stat_selected(card_node)

const SCALE_NORMAL = Vector2(1.0, 1.0)
const SCALE_HOVER = Vector2(1.1, 1.1)
const SCALE_SELECTED = Vector2(1.15, 1.15)

@onready var icon = $TextureRect2/Icon
@onready var label = $Label
@onready var bg = $BG

var rarity = "common"
var action = "base_damage_rare"
var description = ""

var loaded = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not loaded:
		loaded = true
		icon.texture = load("res://assets/images/stat_upgrades/" + action + ".png")
		bg.texture = load("res://assets/images/stat_upgrades/" + rarity + ".png")
		match action:
			"base_damage_rare":
				description = "+1 к базовому \nурону"
			"base_damage_epic":
				description = "+3 к базовому \nурону"
			"base_damage_unbelievable":
				description = "+5 к базовому \nурону"
			"defence_common":
				description = "+1 брони"
			"defence_rare":
				description = "+2 брони"
			"defence_epic":
				description = "+4 брони"
			"max_defence_common":
				description = "+3 максимальной \nброни"
			"max_defence_rare":
				description = "+5 максимальной \nброни"
			"max_defence_epic":
				description = "+7 максимальной \nброни"
			"accuracy_common":
				description = "+1% точности"
			"accuracy_rare":
				description = "+3% точности"
			"accuracy_epic":
				description = "+5% точности"
			"luck_common":
				description = "+2% к удаче"
			"luck_rare":
				description = "+4% к удаче"
			"luck_epic":
				description = "+7% к удаче"
			"hp_common":
				description = "+2 ОЗ"
			"hp_rare":
				description = "+5 ОЗ"
			"hp_epic":
				description = "+10 ОЗ"
			"hp_unbelievable":
				description = "+20 ОЗ"
			"hp_legendary":
				description = "+50 ОЗ"
			"energy_unbelievable":
				description = "+1 заряд \nэнергии"
			"energy_legendary":
				description = "+2 заряда \nэнергии"
		
		label.text = description

func animate_to(target_scale: Vector2, target_color: Color, duration: float = 0.15):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 0.15).set_trans(Tween.TRANS_QUAD)

func _on_mouse_entered() -> void:
	z_index += 10
	animate_to(SCALE_HOVER, Color.WHITE)
	
	get_parent().get_parent().human_icon.texture = load("res://assets/images/characters/solya_what.png")
	get_parent().get_parent().cat_icon.texture = load("res://assets/images/characters/cat_handsome_what.png")

func _on_mouse_exited() -> void:
	z_index -= 10
	animate_to(SCALE_NORMAL, Color.WHITE)
	
	get_parent().get_parent().human_icon.texture = load("res://assets/images/characters/solya_default.png")
	get_parent().get_parent().cat_icon.texture = load("res://assets/images/characters/cat_handsome.png")	


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if gm.state == "leveling_up":
			stat_selected.emit(self)
