class_name LuckyCollarArtifact extends Artifact

var character_type = "cat"
var rarity = "common"
var complect = ""
var path = "lucky_collar"
var artifact_name = "СЧАСТЛИВЫЙ ОШЕЙНИК"
var artifact_description = "Удача кота не может опуститься ниже 7%"
var artifact_commentary = "\"Слуга госпожи удачи\""

func _ready() -> void:
	artifact_global_id = 12
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.min_luck_cat = 7
	
	gm.has_artifacts.append(artifact_global_id)
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
