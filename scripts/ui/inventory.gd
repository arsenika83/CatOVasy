extends Control

@onready var artifact_slot_1 = $Artifacts/ArtifactSlot1
@onready var artifact_slot_2 = $Artifacts/ArtifactSlot2
@onready var artifact_slot_3 = $Artifacts/ArtifactSlot3
@onready var artifact_slot_4 = $Artifacts/ArtifactSlot4
@onready var artifact_slot_5 = $Artifacts/ArtifactSlot5
@onready var artifact_slot_6 = $Artifacts/ArtifactSlot6
@onready var artifact_slot_7 = $Artifacts/ArtifactSlot7
@onready var artifact_slot_8 = $Artifacts/ArtifactSlot8
@onready var artifact_slot_9 = $Artifacts/ArtifactSlot9
@onready var artifact_slot_10 = $Artifacts/ArtifactSlot10

@onready var artifact_slots : Array = [artifact_slot_1, artifact_slot_2, artifact_slot_3,
artifact_slot_4, artifact_slot_5, artifact_slot_6, artifact_slot_7, artifact_slot_8, artifact_slot_9, artifact_slot_10]

@onready var card_slots : Array = []

@onready var hp_bar = $HP
@onready var hp_label = $HPLabel

@onready var artifact_check_dialog = $ArtifactCheckDialog
@onready var card_check_dialog = $CardCheckDialog

@onready var cat_button = $CatButton
@onready var human_button = $HumanButton

var state = "cat"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cat_button.button_pressed = true
	var id = 1
	for card_slot in $ScrollContainer/Cards.get_children():
		card_slots.append(card_slot)
		card_slot.id = id
		id += 1
	update_cards("cat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_cards(type : String) -> void:
	if type == "cat":
		for i in range(0, 31):
			if gm.current_cards_cat.has(i+1) and is_instance_valid(gm.current_cards_cat.get(i+1)):
				card_slots[i].current_card = gm.current_cards_cat.get(i+1)
	else:
		for i in range(0, 31):
			if gm.current_cards_human.has(i+1) and is_instance_valid(gm.current_cards_human.get(i+1)):
				card_slots[i].current_card = gm.current_cards_human.get(i+1)
			
func update_artifacts(type : String) -> void:
	if type == "cat":
		for i in range(0, 10):
			if gm.current_artifacts_cat.has(i+1) and is_instance_valid(gm.current_artifacts_cat.get(i+1)):
				artifact_slots[i].current_artifact = gm.current_artifacts_cat.get(i+1)
	else:			
		for i in range(0, 10):
			if gm.current_artifacts_human.has(i+1) and is_instance_valid(gm.current_artifacts_human.get(i+1)):
				artifact_slots[i].current_artifact = gm.current_artifacts_human.get(i+1)
				
func set_hp_bar(value : float) -> void:
	hp_bar.material.set_shader_parameter("fill_ratio", value)
	
func draw_artifact_check_dialog(artifact : Artifact) -> void:
	if artifact == null:
		artifact_check_dialog.visible = false
		return
	artifact_check_dialog.visible = true
	artifact_check_dialog.artifact_name.text = artifact.artifact_name
	artifact_check_dialog.artifact_description.text = artifact.artifact_description
	artifact_check_dialog.artifact_commentary.text = artifact.artifact_commentary
	artifact_check_dialog.icon.texture = load("res://assets/images/artifacts/" + artifact.path + ".png")
	
	match artifact.rarity:
		"common":
			artifact_check_dialog.artifact_rarity.text = "ОБЫЧНЫЙ"
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color(1,1,1))
		"rare":
			artifact_check_dialog.artifact_rarity.text = "РЕДКИЙ"
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color(0.944, 0.522, 0.29, 1.0))
		"epic":
			artifact_check_dialog.artifact_rarity.text = "ЭПИЧЕСКИЙ"
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color(1,0,1))
		"unbelievable":
			artifact_check_dialog.artifact_rarity.text = "НЕВЕРОЯТНЫЙ"
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color(0.52, 0.0, 0.0, 1.0))

func draw_card_check_dialog(card : Card) -> void:
	if card == null:
		card_check_dialog.visible = false
		return
		
	for c in card_check_dialog.card_container.get_children():
		card_check_dialog.card_container.remove_child(c)
		c.queue_free()
		
	var card_scene = load("res://scenes/cards/" + card.card_path)
	var added_card = card_scene.instantiate()
	added_card.use_parent_material = true
		
	card_check_dialog.card_container.add_child(added_card)	
		
	card_check_dialog.visible = true
	card_check_dialog.card_name.text = card.card_name
	card_check_dialog.card_description.text = card.card_description
	
	match card.rarity:
		"common":
			card_check_dialog.card_rarity.text = "ОБЫЧНАЯ"
			card_check_dialog.card_rarity.add_theme_color_override("font_color", Color(1,1,1))
		"rare":
			card_check_dialog.card_rarity.text = "РЕДКАЯ"
			card_check_dialog.card_rarity.add_theme_color_override("font_color", Color(0.944, 0.522, 0.29, 1.0))
		"epic":
			card_check_dialog.card_rarity.text = "ЭПИЧЕСКАЯ"
			card_check_dialog.card_rarity.add_theme_color_override("font_color", Color(1,0,1))
		"unbelievable":
			card_check_dialog.card_rarity.text = "НЕВЕРОЯТНАЯ"
			card_check_dialog.card_rarity.add_theme_color_override("font_color", Color(0.52, 0.0, 0.0, 1.0))

func _on_mouse_entered() -> void:
	if gm.state == "idle":
		gm.state = "checking_inventory"

func _on_mouse_exited() -> void:
	if gm.state == "checking_inventory":
		gm.state = "idle"

func clear_slots() -> void:
	for card_slot in card_slots:
		card_slot.clear()

func _on_cat_button_pressed() -> void:
	state = "cat"
	clear_slots()
	human_button.button_pressed = false
	update_cards("cat")
	update_artifacts("cat")


func _on_human_button_pressed() -> void:
	state = "human"
	clear_slots()
	cat_button.button_pressed = false
	update_cards("human")
	update_artifacts("human")
