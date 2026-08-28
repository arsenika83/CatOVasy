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

@onready var card_slot_attack_1 = $Cards/CardSlotAttack1
@onready var card_slot_attack_2 = $Cards/CardSlotAttack2
@onready var card_slot_attack_3 = $Cards/CardSlotAttack3
@onready var card_slot_attack_4 = $Cards/CardSlotAttack4
@onready var card_slot_attack_5 = $Cards/CardSlotAttack5
@onready var attack_card_slots : Array = [card_slot_attack_1, card_slot_attack_2,
card_slot_attack_3, card_slot_attack_4, card_slot_attack_5]

@onready var card_slot_ability_1 = $Cards/CardSlotAbility1
@onready var card_slot_ability_2 = $Cards/CardSlotAbility2
@onready var card_slot_ability_3 = $Cards/CardSlotAbility3
@onready var card_slot_ability_4 = $Cards/CardSlotAbility4
@onready var card_slot_ability_5 = $Cards/CardSlotAbility5
@onready var ability_card_slots : Array = [card_slot_ability_1, card_slot_ability_2,
card_slot_ability_3, card_slot_ability_4, card_slot_ability_5]

@onready var hp_bar = $HP
@onready var hp_label = $HPLabel

@onready var artifact_check_dialog = $ArtifactCheckDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_cards()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_cards() -> void:
	for i in range(0, 5):
		if gm.current_attack_cards.has(i+1) and is_instance_valid(gm.current_attack_cards.get(i+1)):
			attack_card_slots[i].current_card = gm.current_attack_cards.get(i+1)
		
	for i in range(0, 5):
		if gm.current_ability_cards.has(i+1) and is_instance_valid(gm.current_ability_cards.get(i+1)):
			ability_card_slots[i].current_card = gm.current_ability_cards.get(i+1)
			
func update_artifacts() -> void:
	for i in range(0, 10):
		if gm.current_artifacts.has(i+1) and is_instance_valid(gm.current_artifacts.get(i+1)):
			artifact_slots[i].current_artifact = gm.current_artifacts.get(i+1)
			
func set_hp_bar(value : float) -> void:
	hp_bar.material.set_shader_parameter("fill_ratio", value)
	
func draw_artifact_check_dialog(artifact : Artifact) -> void:
	if artifact == null:
		artifact_check_dialog.visible = false
		return
	artifact_check_dialog.visible = true
	artifact_check_dialog.artifact_name.text = artifact.artifact_name
	artifact_check_dialog.artifact_description.text = artifact.artifact_description
	artifact_check_dialog.icon.texture = load("res://assets/images/artifacts/" + artifact.icon_path)
	
	match artifact.rarity:
		"common":
			artifact_check_dialog.artifact_rarity.text = "ОБЫЧНЫЙ"
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color(1,1,1))
		"rare":
			artifact_check_dialog.artifact_rarity.text = "РЕДКИЙ"
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color(0,1,1))
		"epic":
			artifact_check_dialog.artifact_rarity.text = "ЭПИЧЕСКИЙ"
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color(1,0,1))
		"unbelievable":
			artifact_check_dialog.artifact_rarity.text = "НЕВЕРОЯТНЫЙ"
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color(1,0,0))

func _on_mouse_entered() -> void:
	if gm.state == "idle":
		gm.state = "checking_inventory"

func _on_mouse_exited() -> void:
	if gm.state == "checking_inventory":
		gm.state = "idle"
