extends Control

@onready var debuff_weakness = $Debuffs/TextureDebuff1
@onready var debuff_undefend = $Debuffs/TextureDebuff2
@onready var debuff_inaccuracy = $Debuffs/TextureDebuff3
@onready var debuff_unluck = $Debuffs/TextureDebuff4
@onready var debuff_low_energy = $Debuffs/TextureDebuff5
@onready var debuff_6 = $Debuffs/TextureDebuff6

@onready var label_turns_weakness = $Debuffs/TextureDebuff1/TurnsLabel
@onready var label_turns_undefend = $Debuffs/TextureDebuff2/TurnsLabel
@onready var label_turns_inaccuracy = $Debuffs/TextureDebuff3/TurnsLabel
@onready var label_turns_unluck = $Debuffs/TextureDebuff4/TurnsLabel
@onready var label_turns_low_energy = $Debuffs/TextureDebuff5/TurnsLabel
@onready var label_turns_6 = $Debuffs/TextureDebuff6/TurnsLabel

@onready var buff_strength = $Buffs/TextureBuff1
@onready var buff_defend = $Buffs/TextureBuff2
@onready var buff_accuracy = $Buffs/TextureBuff3
@onready var buff_luck = $Buffs/TextureBuff4
@onready var buff_high_energy = $Buffs/TextureBuff5
@onready var buff_6 = $Buffs/TextureBuff6

@onready var label_turns_strength = $Buffs/TextureBuff1/TurnsLabel
@onready var label_turns_defend = $Buffs/TextureBuff2/TurnsLabel
@onready var label_turns_accuracy = $Buffs/TextureBuff3/TurnsLabel
@onready var label_turns_luck = $Buffs/TextureBuff4/TurnsLabel
@onready var label_turns_high_energy = $Buffs/TextureBuff5/TurnsLabel
@onready var label_turns_7 = $Buffs/TextureBuff6/TurnsLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
