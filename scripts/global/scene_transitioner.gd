extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func change_scene_to() -> void:
	animation_player.play("fade")
	await animation_player.animation_finished
	
func change_scene_back() -> void:
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
