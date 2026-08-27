class_name BlueBallArtifact extends Artifact

var rarity = "common"
var complect = ""
var icon_path = "blue_ball.png"
var scene_path = "blue_ball.tscn"
var tool_tip_text = "СИНИЙ КЛУБОК\n\nУвеличивает удачу \nна 10%"

func _ready() -> void:
	artifact_global_id = 2
	tooltip_text = tool_tip_text

func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.luck += 10
	gm.has_artifacts.append(artifact_global_id)
