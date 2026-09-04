class_name MrsRockyArtifact extends Artifact

var character_type = "cat"
var rarity = "rare"
var complect = ""
var path = "mrs_rocky"
var artifact_name = "ЖЕНА КАМУШКА"
var artifact_description = "В конце вашего хода КАМУШЕК наносит 2 единицы урона ВСЕМ врагам"
var artifact_commentary = "\"Ловите!\""

func _ready() -> void:
	artifact_global_id = 14
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_mrs_rocky = true 
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
