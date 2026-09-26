extends Node2D

@export var mine_owner = ""
@onready var owner_sprite = $OwnerSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not mine_owner == "cat":
		mine_owner = "cat"
		gm.gold_mine_count += 1
		owner_sprite.visible = true
		owner_sprite.play("cat")
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
		tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
		$AudioOwner.play()


func _on_area_2d_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
