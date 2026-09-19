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

func swap_nodes(n1: Node, n2: Node):
	if n1.get_parent() != n2.get_parent():
		return
		
	var parent = n1.get_parent()
	
	var index_1 = n1.get_index()
	var index_2 = n2.get_index()
	
	parent.move_child(n1, index_2)
	parent.move_child(n2, index_1)

func show_menu() -> void:
	$ColorRect.visible = true
	$MenuRect.visible = true
	menu_on_screen = true
	
	gm.prev_state = gm.state
	gm.state = "checking_menu"
	
	swap_nodes(self, get_parent().get_parent().front)

func hide_menu() -> void:
	$ColorRect.visible = false
	$MenuRect.visible = false
	menu_on_screen = false
	
	settings.save_settings_to_file()
	gm.state = gm.prev_state
	
	swap_nodes(self, get_parent().get_parent().front)
	
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
	#if not gm.state == "battle" and not gm.state == "playing_a_card":
		#sm.save_game() #СОХРАНЕНИЕ ТОЛЬКО НЕ В БОЮ
	scene_transitioner.change_scene_to()
	settings.save_settings_to_file()
	get_tree().quit()

func _on_give_up_button_pressed() -> void:
	audio_click.play()
	sm.clear_save()
	sm.load_game()
	
	scene_transitioner.change_scene_to()
	lm.change_scene_with_loading(str("res://scenes/ui/main_menu.tscn"))


func _on_mouse_entered() -> void:
	if get_parent().get_parent().name != "Battle":
		if menu_on_screen:
			get_parent().get_parent().level_up_dialog.mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
		else:
			get_parent().get_parent().level_up_dialog.mouse_filter = MouseFilter.MOUSE_FILTER_STOP

func _on_menu_rect_mouse_entered() -> void:
	gm.state = "checking_menu"


func _on_main_menu_button_pressed() -> void:
	scene_transitioner.change_scene_to()
	lm.change_scene_with_loading(str("res://scenes/ui/main_menu.tscn"))
