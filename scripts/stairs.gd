extends Node2D

@export var room_number = 1
@onready var timer = $Timer

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("ENTER ", room_number)
	get_parent().get_parent().find_child("Giant").go_downstairs()
	
	get_parent().get_parent().find_child("Giant").position = self.global_position
	timer.start()

func _on_timer_timeout() -> void:
	gm.current_music_position = get_parent().get_parent().audio.get_playback_position() + 0.001
	get_tree().change_scene_to_file(str("res://scenes/levels/level", room_number, ".tscn"))
