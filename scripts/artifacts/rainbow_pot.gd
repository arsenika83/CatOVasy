class_name RainbowPotArtifact extends Artifact

var character_type = "human"
var rarity = "rare"
var complect = ""
var path = "rainbow_pot"
var artifact_name = "ГОРШОЧЕК С РАДУГОЙ"
var artifact_description = "Дает Соле 2 защиты за ЛЮБОЙ удачный удар в бою"
var artifact_commentary = "\"Попробуй радугу, поделись радугой!\""

func _ready() -> void:
	artifact_global_id = 8

	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
	
	gm.has_rainbow_pot = true
