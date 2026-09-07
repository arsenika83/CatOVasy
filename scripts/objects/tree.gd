extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var speed = randf_range(1.5, 2.0)
	$Leaves.material.set_shader_parameter("speed", speed)
	$Body.material.set_shader_parameter("speed", speed)
	$Shadow.material.set_shader_parameter("speed", speed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
