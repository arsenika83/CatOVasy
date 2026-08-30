class_name BlueBallArtifact extends Artifact

var rarity = "rare"
var complect = ""
var path = "blue_ball"
var tool_tip_text = "СИНИЙ КЛУБОК\n\nУвеличивает удачу \nна 10%"
var artifact_name = "СИНИЙ КЛУБОК"
var artifact_description = "Повышает урон и защиту на 2.\nПовышает точность и удачу на 3%"
var artifact_commentary = "\"На редкость забавно катается\""

func _ready() -> void:
	artifact_global_id = 2
	tooltip_text = tool_tip_text

func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.accuracy += 3
	gm.luck += 3
	gm.defence += 2
	gm.damage += 2
	gm.has_artifacts.append(artifact_global_id)
	catalog.all_artifact_names.erase(path)
