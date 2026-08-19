class_name Enemy extends Node2D

@export var damage = 1
@export var amount = 1
@export var hp = 1
@export var xp_gives = 1
var gave_xp = false
var state = "idle"
var enemy_type = "mouse"
var enemy_name = "Mouse"
var enemy_name_ru = "Мышь"

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var area_xp = $Area2DXP
@onready var audio_hit = $AudioStreamPlayerHit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp <= 0:
		hp = 0
		state = "dead"
	
	match state:
		"idle":
			pass
		"dead":
			area_xp.monitoring = true
			sprite.play("dead")
			area.monitoring = false

func move(g_pos : Vector2, e_pos : Vector2) -> void:
	if state == "idle":
		var diff_x = g_pos.x - e_pos.x
		var diff_y = g_pos.y - e_pos.y
		
		if (diff_x == 0) and diff_y < 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - 32), 0.2)
		elif diff_x > 0 and diff_y < 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y - 32), 0.2)
		elif diff_x > 0 and (diff_y == 0):
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y), 0.2)
		elif diff_x > 0 and diff_y > 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y + 32), 0.2)
		elif (diff_x == 0) and diff_y > 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x, self.position.y + 32), 0.2)
		elif diff_x < 0 and diff_y > 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y + 32), 0.2)
		elif diff_x < 0 and (diff_y == 0):
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y), 0.2)
		elif diff_x < 0 and diff_y < 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y - 32), 0.2)	

func _on_area_2d_area_entered(area: Area2D) -> void:
	gm.hp -= damage
	hp -= gm.damage
	
	audio_hit.pitch_scale = randf_range(0.8, 1.2)
	audio_hit.play()

func _on_area_2dxp_area_entered(area: Area2D) -> void:
	if not gave_xp:
		gave_xp = true
		gm.xp += xp_gives
		get_parent().get_parent().find_child("Giant").check_xp()
