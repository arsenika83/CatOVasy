class_name Artifact extends Control

var artifact_global_id = 0

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func upon_pickup() -> void:
	print("PICK UP")
	

func _on_mouse_entered() -> void:
	scale = Vector2(1.2, 1.2)


func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)
