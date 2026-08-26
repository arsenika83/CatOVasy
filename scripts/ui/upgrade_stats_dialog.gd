extends Control

@onready var stats = $Stats

func _ready() -> void:
	for child in stats.get_children():
		if child.has_signal("stat_selected"):
			child.stat_selected.connect(_on_stat_selected)

func _process(delta: float) -> void:
	pass

func _on_stat_selected(stat : Control) -> void:
	match stat.action:
		"base_damage_1":
			gm.damage += 1
		"base_damage_2":
			gm.damage += 2
		"base_damage_3":
			gm.damage += 3
	
	visible = false
	position.x = -1500		
	gm.state = "idle"
