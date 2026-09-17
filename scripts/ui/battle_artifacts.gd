extends Control

@onready var artifact_check_dialog = $ArtifactCheckDialog

@onready var artifact_slot_1 = $ArtifactsHuman/ArtifactSlot1
@onready var artifact_slot_2 = $ArtifactsHuman/ArtifactSlot2
@onready var artifact_slot_3 = $ArtifactsHuman/ArtifactSlot3
@onready var artifact_slot_4 = $ArtifactsHuman/ArtifactSlot4
@onready var artifact_slot_5 = $ArtifactsHuman/ArtifactSlot5
@onready var artifact_slot_6 = $ArtifactsHuman/ArtifactSlot6
@onready var artifact_slot_7 = $ArtifactsHuman/ArtifactSlot7
@onready var artifact_slot_8 = $ArtifactsHuman/ArtifactSlot8
@onready var artifact_slot_9 = $ArtifactsHuman/ArtifactSlot9
@onready var artifact_slot_10 = $ArtifactsHuman/ArtifactSlot10

@onready var artifact_slots_human : Array = [artifact_slot_1, artifact_slot_2, artifact_slot_3,
artifact_slot_4, artifact_slot_5, artifact_slot_6, artifact_slot_7, artifact_slot_8, artifact_slot_9, artifact_slot_10]

@onready var artifact_slot_1_cat = $ArtifactsCat/ArtifactSlot1
@onready var artifact_slot_2_cat = $ArtifactsCat/ArtifactSlot2
@onready var artifact_slot_3_cat = $ArtifactsCat/ArtifactSlot3
@onready var artifact_slot_4_cat = $ArtifactsCat/ArtifactSlot4
@onready var artifact_slot_5_cat = $ArtifactsCat/ArtifactSlot5
@onready var artifact_slot_6_cat = $ArtifactsCat/ArtifactSlot6
@onready var artifact_slot_7_cat = $ArtifactsCat/ArtifactSlot7
@onready var artifact_slot_8_cat = $ArtifactsCat/ArtifactSlot8
@onready var artifact_slot_9_cat = $ArtifactsCat/ArtifactSlot9
@onready var artifact_slot_10_cat = $ArtifactsCat/ArtifactSlot10

@onready var artifact_slots_cat : Array = [artifact_slot_1_cat, artifact_slot_2_cat, artifact_slot_3_cat,
artifact_slot_4_cat, artifact_slot_5_cat, artifact_slot_6_cat,
artifact_slot_7_cat, artifact_slot_8_cat, artifact_slot_9_cat, artifact_slot_10_cat]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for artifact in gm.current_artifacts_human.values():
		artifact_slots_human.get(i).current_artifact = artifact
		i += 1
	
	i = 0
	for artifact in gm.current_artifacts_cat.values():
		artifact_slots_cat.get(i).current_artifact = artifact
		i += 1
		

func _process(delta: float) -> void:
	pass


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
			artifact_check_dialog.artifact_rarity.add_theme_color_override("font_color", Color.from_string("fb2ac1", Color.WHITE))
