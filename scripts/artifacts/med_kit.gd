class_name MedKitArtifact extends Artifact

var character_type = "human"
var rarity = "rare"
var complect = ""
var path = "med_kit"
var artifact_name = "АПТЕЧКА"
var artifact_description = "При использовании восстанавливает 25 ОЗ"
var artifact_commentary = "\"А боль не утихает...\""

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
	if gm.has_heart_shaped_pillow:
		gm.hp_human += 26
	else:
		gm.hp_human += 25
	
	if gm.hp_human > gm.max_hp_human:
		gm.hp_human = gm.max_hp_human
