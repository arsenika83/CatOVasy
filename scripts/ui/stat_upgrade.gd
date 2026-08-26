extends Control

signal stat_selected(card_node)

const SCALE_NORMAL = Vector2(1.0, 1.0)
const SCALE_HOVER = Vector2(1.1, 1.1)
const SCALE_SELECTED = Vector2(1.15, 1.15)

var rarity = "common"
var action = "base_damage_1"

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

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
