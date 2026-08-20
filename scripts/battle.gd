extends Node2D

var cursor_pos
var cursor_map_pos

@onready var cursor = $Cursor
@onready var map = $TileMapLayerBlack
@onready var player_camera = $Giant/Camera2D
@onready var giant = $Giant

var current_selected_card: Control = null

func _ready() -> void:
	player_camera.zoom.x = gm.camera_zoom
	player_camera.zoom.y = gm.camera_zoom
	init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cursor_pos = map.get_global_mouse_position()
	cursor_map_pos = map.local_to_map(cursor_pos)
	cursor.global_position = map.map_to_local(cursor_map_pos)
	
	if Input.is_action_just_pressed("ui_scale_up") and gm.camera_zoom <= 3:
		gm.camera_zoom += 1
		smooth_camera_zoom(":zoom:x", gm.camera_zoom)
		smooth_camera_zoom(":zoom:y", gm.camera_zoom)
	elif Input.is_action_just_pressed("ui_scale_down") and gm.camera_zoom >= 3:
		gm.camera_zoom -= 1
		smooth_camera_zoom(":zoom:x", gm.camera_zoom)
		smooth_camera_zoom(":zoom:y", gm.camera_zoom)	

func smooth_camera_zoom(value1, value2) -> void:
	var tween = create_tween()
	tween.tween_property(player_camera, str(value1), value2, 0.5)	

func init() -> void:
	giant.light.enabled = false
	
	const ENEMY_SCENE = preload("res://scenes/enemies/enemy.tscn")
	var enemy = ENEMY_SCENE.instantiate()
	enemy.position = Vector2(208, 112)
	enemy.z_index = 32
	
	add_child(enemy)

func win() -> void:
	pass

func lose() -> void:
	pass	
