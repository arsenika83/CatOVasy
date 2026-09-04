extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(gm.current_energy_cat, "/", gm.max_energy_cat)
	
	if gm.current_energy_cat == 1:
		$BigActive.visible = false
		$SmallActive.visible = true
		
		$BigNotActive.visible = true
		$SmallNotActive.visible = false
	elif gm.current_energy_cat == 0:
		$BigActive.visible = false
		$SmallActive.visible = false
		
		$BigNotActive.visible = true
		$SmallNotActive.visible = true
	else:
		$BigActive.visible = true
		$SmallActive.visible = true
		
		$BigNotActive.visible = false
		$SmallNotActive.visible = false
		
