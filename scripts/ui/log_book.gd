extends Control

@onready var panel = $Panel
@onready var button = $ToggleLogButton
@onready var text = $Panel/Text

func _ready() -> void:
	text.text = ""
	text.scroll_following = true
	panel.scale.y = 0

func _process(delta: float) -> void:
	pass

func _on_toggle_log_button_pressed() -> void:
	pass


func _on_mouse_entered() -> void:
	get_parent().get_parent().state = "checking_log"

func _on_mouse_exited() -> void:
	get_parent().get_parent().state = "default"

func _on_toggle_log_button_mouse_entered() -> void:
	if not button.button_pressed:
		button.button_pressed = true
		var tween = create_tween()
		tween.tween_property(panel, "scale:y", 1, 0.15)
	else:
		button.button_pressed = false
		var tween = create_tween()
		tween.tween_property(panel, "scale:y", 0, 0.3)
