class_name DiceArtifact extends Artifact

var character_type = "human"
var rarity = "epic"
var complect = ""
var path = "dice"
var artifact_name = "ИГРАЛЬНЫЕ КОСТИ"
var artifact_description = "Каждый удар Соли будет удачным! Появляется 15% шанс, что ваш удар будет направлен против вас..."
var artifact_commentary = "\"На все своя воля\""

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
	
	gm.has_dice = true
