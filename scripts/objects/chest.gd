extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer
@export var rarity : String

var opened = false

func _ready() -> void:
	$StatusFX.play("enabled")
	sprite.play("closed" + "_" + rarity)

func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if gm.state == "idle" or gm.state == "walking":
		if not opened:
			gm.current_chest_rarity = rarity
			opened = true
			sprite.play("open" + "_" + rarity)
			$StatusFX.visible = false
			audio.play()
			get_parent().get_parent().draw_artifact_dialog()


func _on_area_2d_highlight_area_entered(area: Area2D) -> void:
	if not opened:
		sprite.material.set_shader_parameter("mix_amount", 0.0)


func _on_area_2d_highlight_area_exited(area: Area2D) -> void:
	sprite.material.set_shader_parameter("mix_amount", 0.0)
