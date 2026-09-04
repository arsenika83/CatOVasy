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

@onready var cat_texture = $TextureRectCat
@onready var human_texture = $TextureRectHuman

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_artifact() -> void:
	for artifact in artifacts.get_children():
		artifacts.remove_child(artifact)
		artifact.queue_free()
	
	var artifact_index
	var artifact_name
	
	var rarity = gm.current_chest_rarity
	match rarity:
		"all":
			pass
		"common":
			var rare_chance = randi_range(1, 100) < 20
			if rare_chance or catalog.all_artifact_names_common.size() == 0:
				rarity = "rare"
					
		"rare":
			var epic_chance = randi_range(1, 100) < 5
			if epic_chance or catalog.all_artifact_names_rare.size() == 0:
				rarity = "epic"
					
		"epic":
			var unbelievable_chance = randi_range(1, 100) < 2
			if unbelievable_chance or catalog.all_artifact_names_epic.size() == 0:
				rarity = "unbelievable"
					
		"unbelievable":
			var legendary_chance = randi_range(1, 100) < 3
			if legendary_chance:
				rarity = "legendary"
								
	match rarity:
		"all":
			artifact_index = randi_range(0, catalog.all_artifact_names.size()-1)
			artifact_name = catalog.all_artifact_names.get(artifact_index)
		"common":
			artifact_index = randi_range(0, catalog.all_artifact_names_common.size()-1)
			artifact_name = catalog.all_artifact_names_common.get(artifact_index)
		"rare":
			artifact_index = randi_range(0, catalog.all_artifact_names_rare.size()-1)
			artifact_name = catalog.all_artifact_names_rare.get(artifact_index)
		"epic":
			artifact_index = randi_range(0, catalog.all_artifact_names_epic.size()-1)
			artifact_name = catalog.all_artifact_names_epic.get(artifact_index)
		"unbelievable":
			artifact_index = randi_range(0, catalog.all_artifact_names_unbelievable.size()-1)
			artifact_name = catalog.all_artifact_names_unbelievable.get(artifact_index)
	
	print(artifact_name)
	var artifact_scene = load("res://scenes/artifacts/" + artifact_name + ".tscn")
	var artifact = artifact_scene.instantiate()
	
	if artifact.character_type == "cat":
		cat_texture.visible = true
		human_texture.visible = false
	else:
		cat_texture.visible = false
		human_texture.visible = true
		
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
	
	if artifacts.get_child(0).character_type == "cat":
		if gm.current_artifacts_cat.size() < 10:
			visible = false
			gm.state = "idle"
			
			for i in range(1, 11):
				if gm.current_artifacts_cat.has(i):
					continue
						
				gm.add_artifact_cat(i, artifacts.get_child(0))
				break
			
			artifacts.get_child(0).upon_pickup()
		else:
			return
	else:
		if gm.current_artifacts_human.size() < 10:
			visible = false
			gm.state = "idle"
			
			for i in range(1, 11):
				if gm.current_artifacts_human.has(i):
					continue
						
				gm.add_artifact_human(i, artifacts.get_child(0))
				break
			
			artifacts.get_child(0).upon_pickup()
		else:
			return

func _on_cancel_button_pressed() -> void:
	audio_cancel.play()
	visible = false
	gm.state = "idle"
