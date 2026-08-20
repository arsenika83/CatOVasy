extends Node2D

@export var charge_count = 3

@onready var timer = $Timer
@onready var enabled = $StatusFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if charge_count == 0:
		enabled.play("not_enabled")

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if charge_count > 0:
		gm.state = "resting"
		get_parent().get_parent().find_child("Giant").audio_resting.pitch_scale = randf_range(1, 1.5)
		get_parent().get_parent().find_child("Giant").audio_resting.play()
		enabled.visible = false
		timer.start()

func _on_timer_timeout() -> void:
	charge_count -= 1
	enabled.visible = true
	gm.state = "idle"
	if gm.hp < 5:
		gm.hp += 1
