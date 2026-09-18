class_name MotivationalPosterArtifact extends Artifact

var character_type = "cat"
var rarity = "epic"
var complect = ""
var path = "motivational_poster"
var artifact_name = "МОТИВАЦИОННЫЙ ПЛАКАТ"
var artifact_description = "Каждый промах кота дает ему 3 единицы защиты"
var artifact_commentary = "\"Держись!\""

func _ready() -> void:
	pass
	#artifact_global_id = 100
	
func _process(delta: float) -> void:
	pass

func upon_pickup() -> void:
	#gm.has_artifacts.append(artifact_global_id)
	gm.has_motivational_poster = true
	
	catalog.all_artifact_names.erase(path)
	catalog.all_artifact_names_common.erase(path)
	catalog.all_artifact_names_rare.erase(path)
	catalog.all_artifact_names_epic.erase(path)
	catalog.all_artifact_names_unbelievable.erase(path)
