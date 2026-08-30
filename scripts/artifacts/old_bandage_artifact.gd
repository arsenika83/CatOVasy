class_name OldBandageArtifact extends Artifact

var rarity = "common"
var complect = ""
var path = "old_bandage"
var tool_tip_text = ""
var artifact_name = "НОШЕНЫЙ ПЛАСТЫРЬ"
var artifact_description = "Дает 5 защиты в начале боя, пока находится в инвентаре.\n\nВосстанавливает 4 ОЗ при использовании."
var artifact_commentary = "\"Лучше чем ничего!\""

func _ready() -> void:
	artifact_global_id = 5
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	gm.has_old_bandage = true
	
	catalog.all_artifact_names.erase(path)
	
func upon_use() -> void:
	gm.hp += 4
	gm.has_old_bandage = false
