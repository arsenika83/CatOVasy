class_name HeartShapedPillowArtifact extends Artifact

var character_type = "cat"
var rarity = "epic"
var complect = ""
var path = "heart_shaped_pillow"
var tool_tip_text = ""
var artifact_name = "ПОДУШКА В ВИДЕ СЕРДЦА"
var artifact_description = "Увеличивает максимальные ОЗ кота на 20\n\nВсе виды лечения восстанавливают на 1 ОЗ больше (работает для всей команды)"
var artifact_commentary = "\"Мягко и удобно\""

func _ready() -> void:
	artifact_global_id = 2

func _process(delta: float) -> void:
	pass
	
func upon_pickup() -> void:
	gm.max_hp_cat += 20
	gm.has_heart_shaped_pillow = true
	gm.has_artifacts.append(artifact_global_id)	

	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
