class_name RedBallArtifact extends Artifact

var rarity = "common"
var complect = ""
var path = "red_ball"
var artifact_name = "КРАСНЫЙ КЛУБОК"
var artifact_description = "Повышает урон, защиту, точность и удачу на 1"
var artifact_commentary = "\"Забавно катается\""

func _ready() -> void:
	artifact_global_id = 1
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.accuracy += 1
	gm.luck += 1
	gm.defence += 1
	gm.damage += 1
	
	gm.has_artifacts.append(artifact_global_id)
	catalog.all_artifact_names.erase(path)
