extends Control

@onready var panel = $Panel
@onready var button = $ToggleLogButton
@onready var text = $Panel/Text

func _ready() -> void:
	text.text = ""

func _process(delta: float) -> void:
	pass

func _on_toggle_log_button_pressed() -> void:
	if not button.button_pressed:
		var tween = create_tween()
		tween.tween_property(panel, "scale:y", 0, 0.3)
	else:
		var tween = create_tween()
		tween.tween_property(panel, "scale:y", 1, 0.3)
