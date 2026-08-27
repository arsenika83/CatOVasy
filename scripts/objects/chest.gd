extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer

var opened = false

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not opened:
		opened = true
		sprite.play("open")
		audio.play()
		get_parent().get_parent().draw_artifact_dialog()
