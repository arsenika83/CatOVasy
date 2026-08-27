extends PanelContainer

@onready var current_artifact : Artifact
@onready var icon = $Icon
#@onready var audio = $AudioStreamPlayer

@export var rarity = "common"
@export var id = 0
var loaded = false

func _ready() -> void:
	loaded = false
	if current_artifact == null:
		tooltip_text = "Пустой слот \nдля артефакта"

func _process(delta: float) -> void:
	update()

func update() -> void:
	if current_artifact != null and not loaded:
		icon.texture = load("res://assets/images/artifacts/" + current_artifact.icon_path)
		tooltip_text = current_artifact.tool_tip_text
		rarity = current_artifact.rarity
		loaded = true
