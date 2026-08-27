extends Control

signal stat_selected(card_node)

const SCALE_NORMAL = Vector2(1.0, 1.0)
const SCALE_HOVER = Vector2(1.1, 1.1)
const SCALE_SELECTED = Vector2(1.15, 1.15)

@onready var icon = $TextureRect2/Icon
@onready var label = $Label

var rarity = "common"
var action = "base_damage_1"
var description = ""

var loaded = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not loaded:
		loaded = true
		icon.texture = load("res://assets/images/stat_upgrades/" + action + ".png")
		match action:
			"base_damage_1":
				description = "+1 к базовому \nурону"
			"base_damage_3":
				description = "+3 к базовому \nурону"
			"base_damage_5":
				description = "+5 к базовому \nурону"
			"defence_2":
				description = "+2 брони"
			"defence_4":
				description = "+4 брони"
			"defence_7":
				description = "+7 брони"
			"max_defence_3":
				description = "+3 максимальной \nброни"
			"max_defence_6":
				description = "+6 максимальной \nброни"
			"max_defence_12":
				description = "+12 максимальной \nброни"
			"accuracy_1":
				description = "+1% точности"
			"accuracy_3":
				description = "+3% точности"
			"accuracy_5":
				description = "+5% точности"
			"luck_2":
				description = "+2% к удаче"
			"luck_4":
				description = "+4% к удаче"
			"luck_7":
				description = "+7% к удаче"
			"hp_2":
				description = "+2 ОЗ"	
			"hp_5":
				description = "+5 ОЗ"
			"hp_10":
				description = "+10 ОЗ"
			"hp_20":
				description = "+20 ОЗ"
			"hp_50":
				description = "+50 ОЗ"	
			"energy_1":
				description = "+1 заряд \nэнергии"
			"energy_2":
				description = "+2 заряда \nэнергии"
		
		label.text = description

func animate_to(target_scale: Vector2, target_color: Color, duration: float = 0.15):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 0.15).set_trans(Tween.TRANS_QUAD)

func _on_mouse_entered() -> void:
	z_index += 10
	animate_to(SCALE_HOVER, Color.WHITE)

func _on_mouse_exited() -> void:
	z_index -= 10
	animate_to(SCALE_NORMAL, Color.WHITE)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if gm.state == "leveling_up":
			stat_selected.emit(self)
