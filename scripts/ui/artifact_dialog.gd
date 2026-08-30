extends Control

@onready var artifacts = $Artifacts
@onready var ok_button = $OKButton
@onready var cancel_button = $CancelButton

@onready var artifact_name_label = $TextureRect3/NameLabel
@onready var artifact_description_label = $TextureRect3/DescriptionLabel
@onready var artifact_rarity_label = $RarityLabel
@onready var artifact_commentary_label = $TextureRect3/CommentaryLabel

@onready var audio_ok = $AudioStreamPlayerOK
@onready var audio_cancel = $AudioStreamPlayerCancel
@onready var audio_appear = $AudioStreamPlayerAppear

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_artifact() -> void:
	for artifact in artifacts.get_children():
		artifacts.remove_child(artifact)
		artifact.queue_free()
	
	var artifact_index = randi_range(0, catalog.all_artifact_names.size()-1)
	var artifact_name = catalog.all_artifact_names.get(artifact_index)
	print(artifact_name)
	var artifact_scene = load("res://scenes/artifacts/" + artifact_name + ".tscn")
	var artifact = artifact_scene.instantiate()
	
	artifact_name_label.text = artifact.artifact_name
	artifact_description_label.text = artifact.artifact_description
	artifact_commentary_label.text = artifact.artifact_commentary
	
	match artifact.rarity:
		"common":
			artifact_rarity_label.text = "ОБЫЧНЫЙ"
			artifact_rarity_label.add_theme_color_override("font_color", Color(1,1,1))
		"rare":
			artifact_rarity_label.text = "РЕДКИЙ"
			artifact_rarity_label.add_theme_color_override("font_color", Color(0.944, 0.522, 0.29, 1.0))
		"epic":
			artifact_rarity_label.text = "ЭПИЧЕСКИЙ"
			artifact_rarity_label.add_theme_color_override("font_color", Color(1,0,1))
		"unbelievable":
			artifact_rarity_label.text = "НЕВЕРОЯТНЫЙ"
			artifact_rarity_label.add_theme_color_override("font_color", Color(0.52, 0.0, 0.0, 1.0))
	
	artifact.use_parent_material = true
	
	artifacts.add_child(artifact)
	

func _on_ok_button_pressed() -> void:
	audio_ok.play()
	
	if gm.current_artifacts.size() < 10:
		visible = false
		gm.state = "idle"
		
		for i in range(1, 11):
			if gm.current_artifacts.has(i):
				continue
					
			gm.add_artifact(i, artifacts.get_child(0))
			break
		
		artifacts.get_child(0).upon_pickup()	
	else:
		return

func _on_cancel_button_pressed() -> void:
	audio_cancel.play()
	visible = false
	gm.state = "idle"
