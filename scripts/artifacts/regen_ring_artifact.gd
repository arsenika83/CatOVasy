class_name RegenRingArtifact extends Artifact

var character_type = "cat"
var rarity = "unbelievable"
var complect = ""
var path = "regen_ring"
var artifact_name = "КОЛЬЦО РЕГЕНЕРАЦИИ"
var artifact_description = "Восстанавливает 2 ОЗ каждый ход в бою"
var artifact_commentary = "\"Медленно, но верно\""

func _ready() -> void:
	artifact_global_id = 8
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	gm.has_regen_ring = true
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
