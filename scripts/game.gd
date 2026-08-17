extends Node2D

var cursor_pos
var cursor_map_pos
var player_camera_zoom = 1

@onready var giant = $Giant
@onready var map = $TileMapLayer
@onready var player_camera = $Giant/Camera2D
@onready var cursor = $Cursor

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cursor_pos = get_global_mouse_position()
	cursor_map_pos = map.local_to_map(cursor_pos)
	cursor.global_position = map.map_to_local(cursor_map_pos)
	
	if Input.is_action_just_pressed("ui_lmb"):
		move_to_map_pos() 
		
	if Input.is_action_just_pressed("ui_scale_up") and player_camera_zoom <= 3:
		player_camera_zoom += 1
		smooth_camera_zoom(":zoom:x", player_camera_zoom)
		smooth_camera_zoom(":zoom:y", player_camera_zoom)
	elif Input.is_action_just_pressed("ui_scale_down") and player_camera_zoom >= 3:
		player_camera_zoom -= 1
		smooth_camera_zoom(":zoom:x", player_camera_zoom)
		smooth_camera_zoom(":zoom:y", player_camera_zoom)	

func smooth_camera_zoom(value1, value2) -> void:
	var tween = create_tween()
	tween.tween_property(player_camera, str(value1), value2, 0.5)	
	
func move_to_map_pos() -> void:
	var map_pos = map.local_to_map(cursor_pos)
	
	var tween = create_tween()
	tween.tween_property(giant, "position", map.map_to_local(map_pos), 0.3)
