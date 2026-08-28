extends Control

@onready var master_slider: HSlider = $AUDIO/VolumeSlider
@onready var master_bus_index: int = AudioServer.get_bus_index("Master")

@onready var music_slider: HSlider = $AUDIO/MusicSlider
@onready var music_bus_index: int = AudioServer.get_bus_index("Music")

@onready var fx_slider: HSlider = $AUDIO/FXSlider
@onready var fx_bus_index: int = AudioServer.get_bus_index("SoundFX")

func _ready() -> void:
	var master_current_db = AudioServer.get_bus_volume_db(master_bus_index)
	if AudioServer.is_bus_mute(master_bus_index):
		master_slider.value = 0
	else:
		master_slider.value = db_to_linear(master_current_db)
	
	var music_current_db = AudioServer.get_bus_volume_db(music_bus_index)
	if AudioServer.is_bus_mute(music_bus_index):
		music_slider.value = 0
	else:
		music_slider.value = db_to_linear(music_current_db)
		
	var fx_current_db = AudioServer.get_bus_volume_db(fx_bus_index)
	if AudioServer.is_bus_mute(fx_bus_index):
		fx_slider.value = 0
	else:
		fx_slider.value = db_to_linear(fx_current_db)	
	
	master_slider.value_changed.connect(_on_master_slider_value_changed)
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	fx_slider.value_changed.connect(_on_fx_slider_value_changed)

func _process(delta: float) -> void:
	pass

func _on_master_slider_value_changed(value: float) -> void:
	settings.master_volume = value
	if value <= 0.05:
		AudioServer.set_bus_mute(master_bus_index, true)
	else:
		AudioServer.set_bus_mute(master_bus_index, false)
		var db_value = linear_to_db(value)
		AudioServer.set_bus_volume_db(master_bus_index, db_value)

func _on_music_slider_value_changed(value: float) -> void:
	settings.music_volume = value
	if value <= 0.05:
		AudioServer.set_bus_mute(music_bus_index, true)
	else:
		AudioServer.set_bus_mute(music_bus_index, false)
		var db_value = linear_to_db(value)
		AudioServer.set_bus_volume_db(music_bus_index, db_value)
		
func _on_fx_slider_value_changed(value: float) -> void:
	settings.sound_fx_volume = value
	if value <= 0.05:
		AudioServer.set_bus_mute(fx_bus_index, true)
	else:
		AudioServer.set_bus_mute(fx_bus_index, false)
		var db_value = linear_to_db(value)
		AudioServer.set_bus_volume_db(fx_bus_index, db_value)
