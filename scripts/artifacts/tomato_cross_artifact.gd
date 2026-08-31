class_name TomatoCrossArtifact extends Artifact

var rarity = "epic"
var complect = ""
var path = "tomato_cross"
var artifact_name = "МАЛЬТИЙСКИЙ КРЕСТ"
var artifact_description = "ВСЕ ваши атаки наносят урон по области в виде креста"
var artifact_commentary = "\"Вот такая загадка природы\""

func _ready() -> void:
	artifact_global_id = 14
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_tomato_cross = true 
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
