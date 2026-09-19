extends Node2D

@export var room_number = 1
@onready var timer = $Timer

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("ENTER ", room_number)
	gm.save_game()
	
	gm.level_number += 1
	gm.current_level_name = str("level", room_number)
	
	if gm.has_cat_food:
		gm.hp_cat += 2
		if gm.hp_cat > gm.max_hp_cat:
			gm.hp_cat = gm.max_hp_cat 
	get_parent().get_parent().find_child("Giant").go_downstairs()
	
	get_parent().get_parent().find_child("Giant").position = self.global_position
	timer.start()

func _on_timer_timeout() -> void:
	gm.current_music_position = get_parent().get_parent().audio.get_playback_position() + 0.001
	lm.change_scene_with_loading(str("res://scenes/levels/level", room_number, ".tscn"))
