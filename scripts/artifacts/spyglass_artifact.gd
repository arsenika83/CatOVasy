class_name SpyglassArtifact extends Artifact

var character_type = "cat"
var rarity = "common"
var complect = ""
var path = "spyglass"
var tool_tip_text = ""
var artifact_name = "ПОДЗОРНАЯ ТРУБА"
var artifact_description = "Ваша точность не может опуститься ниже 30%"
var artifact_commentary = "\"Врагу не скрыться!\""

func _ready() -> void:
	artifact_global_id = 4
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.min_accuracy_cat = 30
	gm.has_artifacts.append(artifact_global_id)

	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
