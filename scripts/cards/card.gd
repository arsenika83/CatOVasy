class_name Card extends Control

signal card_clicked(card_node)
signal card_picked_up(card_node)
signal card_played(card_node)
var is_selected: bool = false

var behind_attack = false
var cross_attack = false
var row_attack_3 = false
var row_attack_5 = false
var square_attack_2x2 = false
var square_attack_3x3 = false
var everybody_attack = true

var state_modifier = ""
var enabled = true
var energy_cost = 1
var type = ""
#var rarity = "common"

const SCALE_NORMAL = Vector2(1.0, 1.0)
const SCALE_HOVER = Vector2(1.1, 1.1)
const SCALE_SELECTED = Vector2(1.15, 1.15)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if enabled:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter =  Control.MOUSE_FILTER_IGNORE

# Наведение мыши
func _on_mouse_entered() -> void:
	if enabled:
		z_index += 10
		animate_to(SCALE_HOVER, Color.WHITE)

# Мышь ушла с элемента
func _on_mouse_exited() -> void:
	if enabled:
		z_index -= 10
		animate_to(SCALE_NORMAL, Color.WHITE)

func animate_to(target_scale: Vector2, target_color: Color, duration: float = 0.15):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 0.15).set_trans(Tween.TRANS_QUAD)
	
func _on_gui_input(event: InputEvent) -> void:
	if enabled:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if gm.state == "leveling_up":
				card_picked_up.emit(self)
			else:	
				card_clicked.emit(self)

func select_card():
	if enabled:
		z_index += 10
		is_selected = true
		var tween = create_tween()
		tween.tween_property(self, "position:y", position.y-30, 0.1)
		animate_to(SCALE_SELECTED, Color(1.191, 0.371, 0.385))
		gm.state = "battle" + state_modifier
		gm.prev_state = gm.state

func deselect_card():
	if enabled:
		z_index -= 10
		is_selected = false
		var tween = create_tween()
		tween.tween_property(self, "position:y", position.y+30, 0.1)
		animate_to(SCALE_NORMAL, Color.WHITE)
		gm.state = "battle"
		
func move_back() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y+400, 0.5)
	
	var tween1 = create_tween()
	tween1.tween_property(self, "scale:y", 0.1, 0.1)
	
	var tween2 = create_tween()
	tween2.tween_property(self, "rotation_degrees", 90, 0.1)
	
func move_front(offset : int = 0) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:y", 0 + offset, 0.3)
	
	var tween1 = create_tween()
	tween1.tween_property(self, "scale", Vector2(1, 1), 0.1)
	
	var tween2 = create_tween()
	tween2.tween_property(self, "rotation_degrees", 0, 0.3)
