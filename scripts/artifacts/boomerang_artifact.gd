class_name BoomerangArtifact extends Artifact

var character_type = "cat"
var rarity = "rare"
var complect = ""
var path = "boomerang"
var artifact_name = "БУМЕРАНГ"
var artifact_description = "Каждый промах по врагу наносит ему 1 единицу урона (считается успешным ударом, работает для всей команды)"
var artifact_commentary = "\"Чтобы не расслаблялись >:(\""

func _ready() -> void:
	artifact_global_id = 7
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	gm.has_boomerang = true
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
