class_name ToyCatArtifact extends Artifact

var character_type = "cat"
var rarity = "epic"
var complect = ""
var path = "toy_cat"
var tool_tip_text = ""
var artifact_name = "ИГРУШЕЧНЫЙ КОТ"
var artifact_description = "Первые 2 атаки за бой наносят двойной урон"
var artifact_commentary = "\"Шок контент!\""

func _ready() -> void:
	artifact_global_id = 13
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	gm.has_toy_cat = true
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
