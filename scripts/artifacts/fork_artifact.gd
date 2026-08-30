class_name ForkArtifact extends Artifact

var rarity = "rare"
var complect = ""
var path = "fork"
var artifact_name = "РЖАВАЯ ВИЛКА"
var artifact_description = "ВСЕ ваши атаки наносят урон врагу позади цели"
var artifact_commentary = "\"За компанию!\""

func _ready() -> void:
	artifact_global_id = 11
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	gm.has_artifacts.append(artifact_global_id)
	gm.has_fork = true
	
	catalog.all_artifact_names.erase(path)
