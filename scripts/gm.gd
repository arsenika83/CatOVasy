extends Node

var state = "idle"
var camera_zoom = 2
var start_pos = Vector2i(64+16, 32+16)
var prev_pos = Vector2i(64+16, 32+16)

var hp = 5
var damage = 1
var xp = 0
var xp_needed = 1
var level = 1

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
