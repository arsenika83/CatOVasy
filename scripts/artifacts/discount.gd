class_name DiscountArtifact extends Artifact

var character_type = "human"
var rarity = "rare"
var complect = ""
var path = "discount"
var artifact_name = "СКИДОЧНЫЙ КУПОН"
var artifact_description = "В начале боя делает случайную карту в руке бесплатной.\nДает скидку 10% в магазинах"
var artifact_commentary = "\"Выгодно!\""

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
	
	gm.has_discount = true
