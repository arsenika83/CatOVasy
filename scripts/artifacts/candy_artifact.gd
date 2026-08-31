class_name CandyArtifact extends Artifact

var rarity = "common"
var complect = ""
var path = "candy"
var artifact_name = "КОНФЕТКА"
var artifact_description = "При использовании восстанавливает 15 ОЗ и понижает ваши максимальные ОЗ на 5"
var artifact_commentary = "\"Прощайте, зубы...\""

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
	
func upon_use() -> void:
	gm.max_hp -= 5
	
	if gm.has_heart_shaped_pillow:
		gm.hp += 16
	else:	
		gm.hp += 15
	
	if gm.hp > gm.max_hp:
		gm.hp = gm.max_hp
