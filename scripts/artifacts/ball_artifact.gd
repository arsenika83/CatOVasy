class_name BallArtifact extends Artifact

var rarity = "common"
var complect = ""
var icon_path = "ball.png"
var scene_path = "ball.tscn"
var tool_tip_text = "КЛУБОК\n\nУвеличивает точность \nна 10%"
var artifact_name = "КЛУБОК"
var artifact_description = "Увеличивает точность на 10%"

func _ready() -> void:
	artifact_global_id = 1
	tooltip_text = tool_tip_text
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.accuracy += 10
	gm.has_artifacts.append(artifact_global_id)
