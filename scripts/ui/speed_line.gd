extends Control

var creature_scene = preload("res://scenes/ui/creature_icon.tscn")
var creatures : Array
@onready var creature_container = $ScrollContainer/MarginContainer/HBoxContainer


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
	
func progress_turn() -> void:
	var is_first = true
	
	for child in creature_container.get_children():
		child.queue_free()
	
	for c in get_parent().get_parent().turn_speed_line:
		if not c.state == "dead" or (c == get_parent().get_parent().giant and gm.state == "dead") or (c == get_parent().get_parent().human and gm.state_human == "dead"):
			var creature_icon = creature_scene.instantiate()
			creature_container.add_child(creature_icon)
		
			creature_icon.creature = c
			creature_icon.icon.texture = load(str("res://assets/images/creature_portraits/", c.creature_name, "_portrait.png"))
			
			if is_first:
				is_first = false
				creature_icon.arrow.visible = true
				creature_icon.speed_icon.visible = true
				creature_icon.speed_label.visible = true
	
	var creature_icon = creature_scene.instantiate()
	creature_container.add_child(creature_icon)
	creature_icon.icon.texture = load(str("res://assets/images/creature_portraits/turn_portrait.png"))
	creature_icon.label.text = str("ХОД ", get_parent().get_parent().turn_count+1)


func _on_mouse_entered() -> void:
	get_parent().get_parent().state = "checking_speed_line"


func _on_mouse_exited() -> void:
	get_parent().get_parent().state = "default"
