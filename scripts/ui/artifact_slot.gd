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
		icon.texture = load("res://assets/images/artifacts/" + current_artifact.path + ".png")
		tooltip_text = ""
		rarity = current_artifact.rarity
		loaded = true
		
		if current_artifact.has_method("upon_use"):
			$Usable.visible = true
		
	elif current_artifact == null and loaded:
		tooltip_text = "Пустой слот \nдля артефакта"	
		icon.texture = null
		rarity = null
		loaded = false
		$Usable.visible = false

func clear() -> void:
	current_artifact = null
	loaded = true
	tooltip_text = "Пустой слот \nдля артефакта"
	$Usable.visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if current_artifact != null:
			var giant = get_parent().get_parent().get_parent().get_parent().find_child("Giant")
			giant.artifact_sprite.play(current_artifact.path)
			
			if current_artifact.has_method("upon_use"):
				current_artifact.upon_use()
				gm.current_artifacts_cat.erase(id)
				current_artifact = null
				$Use.visible = false
				$AudioStreamPlayerClick.play()


func _on_icon_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(icon, "scale", Vector2(1.1, 1.1), 0.2)
	
	if get_parent().get_parent().artifact_check_dialog.visible == false:
			get_parent().get_parent().draw_artifact_check_dialog(current_artifact)
	else:
		get_parent().get_parent().artifact_check_dialog.visible = false
	
	if current_artifact != null:
		$AudioStreamPlayerHover.play()
		if current_artifact.has_method("upon_use"):
			$Use.visible = true

func _on_icon_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(icon, "scale", Vector2(1, 1), 0.2)
	
	if get_parent().get_parent().artifact_check_dialog.visible == false:
			get_parent().get_parent().draw_artifact_check_dialog(current_artifact)
	else:
		get_parent().get_parent().artifact_check_dialog.visible = false	
	
	if current_artifact != null:
		if current_artifact.has_method("upon_use"):
			$Use.visible = false	
