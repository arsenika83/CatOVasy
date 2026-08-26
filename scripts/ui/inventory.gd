extends Control

@onready var card_slot_attack_1 = $Cards/CardSlotAttack1
@onready var card_slot_attack_2 = $Cards/CardSlotAttack2
@onready var card_slot_attack_3 = $Cards/CardSlotAttack3
@onready var card_slot_attack_4 = $Cards/CardSlotAttack4
@onready var card_slot_attack_5 = $Cards/CardSlotAttack5
@onready var attack_card_slots : Array = [card_slot_attack_1, card_slot_attack_2,
card_slot_attack_3, card_slot_attack_4, card_slot_attack_5]

@onready var card_slot_ability_1 = $Cards/CardSlotAbility1
@onready var card_slot_ability_2 = $Cards/CardSlotAbility2
@onready var card_slot_ability_3 = $Cards/CardSlotAbility3
@onready var card_slot_ability_4 = $Cards/CardSlotAbility4
@onready var card_slot_ability_5 = $Cards/CardSlotAbility5
@onready var ability_card_slots : Array = [card_slot_ability_1, card_slot_ability_2,
card_slot_ability_3, card_slot_ability_4, card_slot_ability_5]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_cards()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_cards() -> void:
	for i in range(0, 5):
		if gm.current_attack_cards.has(i+1) and is_instance_valid(gm.current_attack_cards.get(i+1)):
			attack_card_slots[i].current_card = gm.current_attack_cards.get(i+1)
		
	for i in range(0, 5):
		if gm.current_ability_cards.has(i+1) and is_instance_valid(gm.current_ability_cards.get(i+1)):
			ability_card_slots[i].current_card = gm.current_ability_cards.get(i+1)

func _on_mouse_entered() -> void:
	if gm.state == "idle":
		gm.state = "checking_inventory"

func _on_mouse_exited() -> void:
	if gm.state == "checking_inventory":
		gm.state = "idle"
