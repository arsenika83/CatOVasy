extends Node2D

var collected = false
var gold_amount = randi_range(30, 50)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not collected:
		collected = true
		gm.money += gold_amount
		
		$AudioMoney.play()
		get_parent().get_parent().giant.money_particles.amount = gold_amount
		get_parent().get_parent().giant.money_particles.restart()
		get_parent().get_parent().giant.display_damage(str(gold_amount))
		
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.9)
		
		$Timer.start()


func _on_timer_timeout() -> void:
	queue_free()
