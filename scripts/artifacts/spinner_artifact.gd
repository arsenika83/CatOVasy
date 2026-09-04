class_name SpinnerArtifact extends Artifact

var character_type = "cat"
var rarity = "rare"
var complect = ""
var path = "spinner"
var tool_tip_text = ""
var artifact_name = "ВЕРТУШКА"
var artifact_description = "В бою первые 2 замены карты не требуют энергии"
var artifact_commentary = "\"Да поможет нам ветер!\""

func _ready() -> void:
	artifact_global_id = 6
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	gm.has_spinner = true
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
