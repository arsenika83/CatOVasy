extends ScrollContainer

var buff_scene = preload("res://scenes/ui/buff.tscn")
var buffs : Array
@onready var buff_container = $BuffGrid


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func update_buffs() -> void:
	for child in buff_container.get_children():
		child.queue_free()
	
	for buff in get_parent().get_parent().get_parent().current_creature_stats.current_buffs:
		var stats = get_parent().get_parent().get_parent().current_creature_stats.current_buffs.get(buff)
		
		var buff_icon = buff_scene.instantiate()
		buff_container.add_child(buff_icon)
		
		buff_icon.power.text = str(stats.get(0))
		buff_icon.turns.text = str("x", stats.get(1))
		buff_icon.icon.texture = load(str("res://assets/images/statuses/", buff, "_status.png"))
		
func update_debuffs() -> void:
	for child in buff_container.get_children():
		child.queue_free()
	
	for debuff in get_parent().get_parent().get_parent().current_creature_stats.current_debuffs:
		var stats = get_parent().get_parent().get_parent().current_creature_stats.current_debuffs.get(debuff)
		
		var buff_icon = buff_scene.instantiate()
		buff_container.add_child(buff_icon)
		
		buff_icon.power.text = str(stats.get(0))
		buff_icon.turns.text = str("x", stats.get(1))
		buff_icon.icon.texture = load(str("res://assets/images/statuses/", debuff, "_status.png"))		


func _on_mouse_entered() -> void:
	get_parent().get_parent().get_parent().state = "checking_stats"


func _on_mouse_exited() -> void:
	get_parent().get_parent().get_parent().state = "default"
