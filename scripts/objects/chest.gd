extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer
@export var rarity : String

var opened = false

func _ready() -> void:
	$StatusFX.play("enabled")


func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if gm.state == "idle" or gm.state == "walking":
		if not opened:
			gm.current_chest_rarity = rarity
			opened = true
			sprite.play("open")
			$StatusFX.visible = false
			audio.play()
			get_parent().get_parent().draw_artifact_dialog()
