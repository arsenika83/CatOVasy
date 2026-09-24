extends Control

@onready var bg = $BG
@onready var icon = $Icon
@onready var arrow = $Arrow
@onready var label = $Label
@onready var dead = $Dead
@onready var speed_icon = $Speed
@onready var speed_label = $SpeedLabel

var creature : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if creature != null and speed_label.visible:
		speed_label.text = str(creature.current_energy, "/", creature.energy)


func _on_mouse_entered() -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().state = "checking_speed_line"
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	
	if creature != null:
		for c in get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().creatures:
			pass
		creature.cursor.visible = true

func _on_mouse_exited() -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().state = "default"
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	
	if creature != null:
		creature.cursor.visible = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		#get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().creature_check_dialog
		pass
