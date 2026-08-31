class_name HeartShapedPillowArtifact extends Artifact

var rarity = "epic"
var complect = ""
var path = "heart_shaped_pillow"
var tool_tip_text = ""
var artifact_name = "ПОДУШКА В ВИДЕ СЕРДЦА"
var artifact_description = "Увеличивает ваши максимальные ОЗ на 20\n\nВсе виды лечения восстанавливают на 1 ОЗ больше"
var artifact_commentary = "\"Мягко и удобно\""

func _ready() -> void:
	artifact_global_id = 2

func _process(delta: float) -> void:
	pass
	
func upon_pickup() -> void:
	gm.max_hp += 20
	gm.has_heart_shaped_pillow = true
	gm.has_artifacts.append(artifact_global_id)	

	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
