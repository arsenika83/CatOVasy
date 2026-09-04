class_name PortraitOfTheUnknownArtifact extends Artifact

var character_type = "human"
var rarity = "rare"
var complect = ""
var path = "portrait_of_the_unknown"
var artifact_name = "ПОРТРЕТ НЕИЗВЕСТНОЙ"
var artifact_description = "Каждый успешный удар Соли снижает удачу противника на 3%"
var artifact_commentary = "\"В последние дни меня посещало ненастье\""

func _ready() -> void:
	artifact_global_id = 9
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	gm.has_portrait_of_the_unknown = true
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
