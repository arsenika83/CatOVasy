class_name MatchesArtifact extends Artifact

var character_type = "human"
var rarity = "common"
var complect = ""
var path = "matches"
var artifact_name = "Коробка спичек"
var artifact_description = "Пока есть спички, позволяет сжигать карты в инвентаре.\n\nКарты созданы из особого материала, так что обычный огонь их не сожжет."
var artifact_commentary = "\"Особо яркий огонь от особо особенных спичек\""

func _ready() -> void:
	artifact_global_id = 9
	$AmountLabel.text = str(gm.match_amount, "/20")
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
	
