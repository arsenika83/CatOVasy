extends CharacterBody2D

var speed = 320
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var area = $Area2D
@onready var respawn_timer = $RespawnTimer
@onready var fall_timer = $FallTimer
@onready var sprite = $Sprite
@onready var audio_meow = $AudioStreamPlayerMeow
@onready var audio_fall = $AudioStreamPlayerFall
@onready var audio_resting = $AudioStreamPlayerResting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(0, 0)
	spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_fall(delta)
	check_hp()
	
	match gm.state:
		"idle":
			sprite.play("idle")
			if Input.is_action_just_pressed("ui_lmb"):
				audio_meow.pitch_scale = randf_range(0.7, 1.3)
				audio_meow.play()
		"resting":
			sprite.play("resting")
		"falling":
			sprite.play("falling")
		"dead":
			sprite.play("dead")
	
	move_and_slide()

func spawn() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5)

func respawn() -> void:
	gm.state = "idle"
	global_position = gm.prev_pos
	gm.hp -= 1

func fall() -> void:
	if not gm.state == "falling":
		gm.state = "falling"
		respawn_timer.start()
		audio_fall.play()

func go_downstairs() -> void:
	audio_fall.play()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.5)

func check_fall(delta: float) -> void:
	if gm.state == "falling":
		z_index = -1
		#velocity.y += gravity * delta * 0.5
			
		scale.x -= 0.02
		scale.y -= 0.02
		
		rotation_degrees += 10
		if scale.x <= 0:
			scale.x = 0
			scale.y = 0
	else:
		z_index = 3
		rotation_degrees = 0
		#velocity.y = 0
		scale.x += 0.04
		scale.y += 0.04
		
		if scale.x >= 1:
			scale.x = 1
			scale.y = 1

func check_hp() -> void:
	if gm.hp <= 0:
		gm.state = "dead"

func check_xp() -> void:
	$AudioStreamPlayerPickUpXP.pitch_scale = randf_range(0.8, 1.2)
	$AudioStreamPlayerPickUpXP.play()
	
	if gm.xp >= gm.xp_needed:
		gm.level += 1
		gm.xp = gm.xp - gm.xp_needed
		gm.xp_needed += 1
		$AudioStreamPlayerLevelUp.play()
		

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#fall_timer.start()
	pass

func _on_respawn_timer_timeout() -> void:
	respawn()

func _on_fall_timer_timeout() -> void:
	fall()

func _on_restart_timer_timeout() -> void:
	pass # Replace with function body.
