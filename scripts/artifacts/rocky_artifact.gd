class_name RockyArtifact extends Artifact

var character_type = "cat"
var rarity = "common"
var complect = ""
var path = "rocky"
var artifact_name = "КАМУШЕК"
var artifact_description = "В конце вашего хода наносит случайному врагу 2 единицы урона"
var artifact_commentary = "\"Лови!\""

func _ready() -> void:
	artifact_global_id = 14
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_rocky = true 
	catalog.all_artifact_names.append("mrs_rocky")
	catalog.all_artifact_names_rare.append("mrs_rocky")
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
