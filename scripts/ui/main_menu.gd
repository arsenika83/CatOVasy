extends Control

var settings_on_screen = false
var profiles_on_screen = false

@onready var game_button = $Buttons/GameButton
@onready var settings_button = $Buttons/SettingsButton
@onready var quit_button = $Buttons/QuitButton

@onready var settings_menu = $Settings
@onready var profiles_menu = $Profiles

@onready var audio_click = $AudioStreamPlayerClick

func _ready() -> void:
	settings_menu.scale.x = 0
	profiles_menu.scale.x = 0
	scene_transitioner.change_scene_back()


func _process(delta: float) -> void:
	pass


func _on_game_button_pressed() -> void:
	audio_click.play()
	if not profiles_on_screen:
		var tween = create_tween()
		tween.tween_property(profiles_menu, "scale:x", 1, 0.15)
		profiles_on_screen = true
	else:
		var tween = create_tween()
		tween.tween_property(profiles_menu, "scale:x", 0, 0.1)
		profiles_on_screen = false
		
	if settings_on_screen:
		var tween = create_tween()
		tween.tween_property(settings_menu, "scale:x", 0, 0.1)
		settings_on_screen = false	


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
		
	if profiles_on_screen:
		var tween = create_tween()
		tween.tween_property(profiles_menu, "scale:x", 0, 0.1)
		profiles_on_screen = false	


func _on_quit_button_pressed() -> void:
	audio_click.play()
	get_tree().quit()
