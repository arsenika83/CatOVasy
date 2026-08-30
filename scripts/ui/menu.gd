extends Control

@onready var settings_menu = $MenuRect/Settings
@onready var audio_click = $AudioStreamPlayerClick
var settings_on_screen = false
var menu_on_screen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu.scale.x = 0
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
	
	settings.save_settings_to_file()
	gm.state = gm.prev_state
	
func _on_resume_button_pressed() -> void:
	audio_click.play()
	hide_menu()

func _on_settings_button_pressed() -> void:
	audio_click.play()
	if not settings_on_screen:
		var tween = create_tween()
		tween.tween_property(settings_menu, "scale:x", 1, 0.15)
		settings_on_screen = true
	else:
		var tween = create_tween()
		tween.tween_property(settings_menu, "scale:x", 0, 0.1)
		settings_on_screen = false	


func _on_open_menu_button_pressed() -> void:
	pass

func _on_open_menu_button_mouse_entered() -> void:
	audio_click.play()
	if not menu_on_screen:
		show_menu()
	else:
		hide_menu()	
	$OpenMenuButton/AudioStreamPlayer.pitch_scale = randf_range(0.8, 1.2)
	$OpenMenuButton/AudioStreamPlayer.play()
	
func _on_open_menu_button_mouse_exited() -> void:
	#gm.state = gm.prev_state
	pass


func _on_save_quit_button_pressed() -> void:
	audio_click.play()
	settings.save_settings_to_file()
	get_tree().quit()

func _on_give_up_button_pressed() -> void:
	audio_click.play()
