extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var audio = $Audio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	audio.pitch_scale = randf_range(0.8, 1.1)
	audio.play()
	z_index += 4
	sprite.material.set_shader_parameter("speed", 5)
	sprite.material.set_shader_parameter("min_strength", 0.025)
	sprite.material.set_shader_parameter("max_strength", 0.025)
	
	var tween = create_tween()

	tween.tween_property(sprite.material, "shader_parameter/speed", 2, 0.2)
	tween.tween_property(sprite.material, "shader_parameter/min_strength", 0.005, 0.2)
	tween.tween_property(sprite.material, "shader_parameter/max_strength", 0.005, 0.2)

func _on_area_2d_area_exited(area: Area2D) -> void:
	audio.pitch_scale = randf_range(0.8, 1.1)
	audio.play()
	z_index -= 4
	sprite.material.set_shader_parameter("speed", 3)
	sprite.material.set_shader_parameter("min_strength", 0.015)
	sprite.material.set_shader_parameter("max_strength", 0.015)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite.material, "shader_parameter/speed", 2, 0.2)
	tween.tween_property(sprite.material, "shader_parameter/min_strength", 0.005, 0.2)
	tween.tween_property(sprite.material, "shader_parameter/max_strength", 0.005, 0.2)
