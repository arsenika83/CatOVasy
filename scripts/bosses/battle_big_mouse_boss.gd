extends Battle

@onready var titan_energy_fx = $FX/TitanEnergy

func _ready() -> void:
	enemy_positions = [Vector2(240, 80), Vector2(208, 112), Vector2(240, 144)]
	
	creature_check_dialog.visible = false
	end_battle_button.visible = false
	
	player_camera.zoom.x = gm.camera_zoom
	player_camera.zoom.y = gm.camera_zoom
	human.sprite.flip_h = false
	init()
	end_turn()
