extends CharacterBody2D

var standard_move_path : Array[Vector2] = [Vector2(-32, 0), Vector2(0, -32), Vector2(32, 0), Vector2(0, 32), Vector2(0, 0)]
var follow_radius = 2
var follow_distance = 5
var follow_step_count = 0
var is_following = false

var state = "idle"
@export var step_count = 0

@onready var sprite = $AnimatedSprite2D
@onready var status_fx = $StatusFX

func _process(delta: float) -> void:
	match state:
		pass
			
	move_and_slide()

func move(g_pos : Vector2, e_pos : Vector2) -> void:
	if state == "idle":
		sprite.play("walking")
		$WalkingTimer.start()
		var diff_x = g_pos.x - e_pos.x
		var diff_y = g_pos.y - e_pos.y
		status_fx.visible = true
		status_fx.play("found_you")
		
		if abs(diff_x) > follow_radius or abs(diff_y) > follow_radius:
			status_fx.visible = false
			
			var next_step = Vector2(self.position.x + standard_move_path.get(step_count).x, self.position.y + standard_move_path.get(step_count).y)
			var allowed_to_move = true
			
			for edge_pos in gm.current_level_edge_positions:
				if next_step.x == edge_pos.x and next_step.y == edge_pos.y:
					allowed_to_move = false
					break
			
			if allowed_to_move:
				if standard_move_path.get(step_count).x > 0:
					sprite.flip_h = true
				elif standard_move_path.get(step_count).x < 0:
					sprite.flip_h = false
					
				var tween = create_tween()
				tween.tween_property(self, "position", next_step, 0.2)
				
			step_count += 1
			if step_count >= standard_move_path.size():
				step_count = 0
				
			return
		
		if (follow_step_count == follow_distance):
			follow_step_count = 0
			status_fx.visible = true
			is_following = false
			status_fx.play("lost_you")
			gm.enemies_following -= 1
			return
		
		if not is_following:
			gm.enemies_following += 1
			is_following = true
		
		#audio_follow.volume_db = 0 - (gm.enemies_following * 4)
		#audio_follow.play()
		if (diff_x == 0) and diff_y < 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - 32), 0.2)
		elif diff_x > 0 and diff_y < 0:
			sprite.flip_h = true
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y - 32), 0.2)
		elif diff_x > 0 and (diff_y == 0):
			sprite.flip_h = true
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y), 0.2)
		elif diff_x > 0 and diff_y > 0:
			sprite.flip_h = true
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y + 32), 0.2)
		elif (diff_x == 0) and diff_y > 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x, self.position.y + 32), 0.2)
		elif diff_x < 0 and diff_y > 0:
			sprite.flip_h = false
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y + 32), 0.2)
		elif diff_x < 0 and (diff_y == 0):
			sprite.flip_h = false
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y), 0.2)
		elif diff_x < 0 and diff_y < 0:
			sprite.flip_h = false
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y - 32), 0.2)	
		


func _on_walking_timer_timeout() -> void:
	sprite.play("idle")
