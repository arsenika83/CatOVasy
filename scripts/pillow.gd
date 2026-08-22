extends Node2D

@export var charge_count = 1
@export var heal_power = 5

@onready var timer = $Timer
@onready var status_fx = $StatusFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	status_fx.play("enabled")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if charge_count == 0:
		status_fx.play("not_enabled")

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if charge_count > 0:
		gm.state = "resting"
		get_parent().get_parent().find_child("Giant").audio_resting.pitch_scale = randf_range(1, 1.5)
		get_parent().get_parent().find_child("Giant").audio_resting.play()
		status_fx.visible = false
		timer.start()

func _on_timer_timeout() -> void:
	charge_count -= 1
	status_fx.visible = true
	gm.state = "idle"
	
	gm.hp += heal_power
	if gm.hp > gm.max_hp:
		gm.hp = gm.max_hp
