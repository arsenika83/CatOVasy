class_name Card extends Control

signal card_clicked(card_node)
var is_selected: bool = false

var order = 0

const SCALE_NORMAL = Vector2(1.0, 1.0)
const SCALE_HOVER = Vector2(1.1, 1.1)
const SCALE_SELECTED = Vector2(1.15, 1.15)

func _ready() -> void:
	if order == 1:
		self.rotation_degrees = 15
	elif order == 2:
		self.rotation_degrees = 30

func _process(delta: float) -> void:
	pass

# Наведение мыши
func _on_mouse_entered() -> void:
	z_index += 10
	animate_to(SCALE_HOVER, Color.WHITE)

# Мышь ушла с элемента
func _on_mouse_exited() -> void:
	z_index -= 10
	animate_to(SCALE_NORMAL, Color.WHITE)

func animate_to(target_scale: Vector2, target_color: Color, duration: float = 0.15):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 0.15).set_trans(Tween.TRANS_QUAD)
	#tween.tween_property(icon, "self_modulate", target_color, 0.15).set_trans(Tween.TRANS_QUAD)
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		card_clicked.emit(self)

func select_card():
	z_index += 10
	is_selected = true
	self.rotation_degrees += 10
	animate_to(SCALE_SELECTED, Color(1.191, 0.371, 0.385))

func deselect_card():
	z_index -= 10
	is_selected = false
	self.rotation_degrees -= 10
	animate_to(SCALE_NORMAL, Color.WHITE)
