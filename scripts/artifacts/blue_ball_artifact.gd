class_name BlueBallArtifact extends Artifact

var character_type = "cat"
var rarity = "rare"
var complect = ""
var path = "blue_ball"
var tool_tip_text = "СИНИЙ КЛУБОК\n\nУвеличивает удачу \nна 10%"
var artifact_name = "СИНИЙ КЛУБОК"
var artifact_description = "Повышает урон и защиту кота на 2.\nПовышает точность и удачу кота на 3%"
var artifact_commentary = "\"На редкость забавно катается\""

func _ready() -> void:
	artifact_global_id = 2
	tooltip_text = tool_tip_text

func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.accuracy_cat += 3
	gm.luck_cat += 3
	gm.defence_cat += 2
	gm.damage_cat += 2
	gm.has_artifacts.append(artifact_global_id)
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
