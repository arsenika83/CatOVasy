extends Control

@onready var settings = $MenuRect/Settings
var settings_on_screen = false
var menu_on_screen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.scale.x = 0
	$ColorRect.visible = false
	$MenuRect.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_menu() -> void:
	$ColorRect.visible = true
	$MenuRect.visible = true
	menu_on_screen = true
	
	#gm.prev_state = gm.state
	gm.state = "checking_menu"

func hide_menu() -> void:
	$ColorRect.visible = false
	$MenuRect.visible = false
	menu_on_screen = false
	
	gm.state = gm.prev_state
	
func _on_resume_button_pressed() -> void:
	hide_menu()

func _on_settings_button_pressed() -> void:
	if not settings_on_screen:
		var tween = create_tween()
		tween.tween_property(settings, "scale:x", 1, 0.15)
		settings_on_screen = true
	else:
		var tween = create_tween()
		tween.tween_property(settings, "scale:x", 0, 0.1)
		settings_on_screen = false	


func _on_open_menu_button_pressed() -> void:
	pass

func _on_open_menu_button_mouse_entered() -> void:
	if not menu_on_screen:
		show_menu()
	else:
		hide_menu()	
	$OpenMenuButton/AudioStreamPlayer.pitch_scale = randf_range(0.8, 1.2)
	$OpenMenuButton/AudioStreamPlayer.play()
	
func _on_open_menu_button_mouse_exited() -> void:
	#gm.state = gm.prev_state
	pass
