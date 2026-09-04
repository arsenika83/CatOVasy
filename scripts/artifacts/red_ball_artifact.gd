class_name RedBallArtifact extends Artifact

var character_type = "cat"
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
	gm.accuracy_cat += 1
	gm.luck_cat += 1
	gm.defence_cat += 1
	gm.damage_cat += 1
	
	gm.has_artifacts.append(artifact_global_id)
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
