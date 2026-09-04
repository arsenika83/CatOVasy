class_name CatFoodArtifact extends Artifact

var character_type = "cat"
var rarity = "rare"
var complect = ""
var path = "cat_food"
var tool_tip_text = "КОШАЧИЙ КОРМ\n\n"
var artifact_name = "КОШАЧИЙ КОРМ"
var artifact_description = "Восстанавливает 1 ОЗ кота в конце каждого боя.\n\nВосстанавливает 2 ОЗ кота при переходе на новую локацию."
var artifact_commentary = "\"Главное не подавиться\""

func _ready() -> void:
	artifact_global_id = 3
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	gm.has_cat_food = true
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
