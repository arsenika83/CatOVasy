class_name HeartShapedPillowArtifact extends Artifact

var rarity = "common"
var complect = ""
var icon_path = "heart_shaped_pillow.png"
var scene_path = "heart_shaped_pillow.tscn"
var tool_tip_text = "ПОДУШКА-СЕРДЕЧКО\n\nУвеличивает максимальные ОЗ \nна 15 \n(Не восстанавливает ОЗ)"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	artifact_global_id = 2
	tooltip_text = tool_tip_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func upon_pickup() -> void:
	gm.max_hp += 15
	gm.has_artifacts.append(artifact_global_id)	
