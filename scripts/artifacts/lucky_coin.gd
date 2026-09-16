class_name LuckyCoinArtifact extends Artifact

var character_type = "human"
var rarity = "rare"
var complect = ""
var path = "lucky_coin"
var tool_tip_text = ""
var artifact_name = "СЧАСТЛИВАЯ МОНЕТКА"
var artifact_description = "Если удар был удачным, он не может промахнуться!\nУдача Соли не может быть выше 60%\n"
var artifact_commentary = "\"Орел или решка\""

func _ready() -> void:
	artifact_global_id = 3
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.min_luck_human = 5
	gm.has_lucky_coin = true
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
