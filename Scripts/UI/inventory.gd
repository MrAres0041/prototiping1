extends Control
class_name Inventory

@onready var inv:ItemBus = preload("res://Resources/Items/PlayerInventory.tres")
#@onready var slots: Array = $NinePatchRect/SlotsContainer.get_children()
@onready var slots: Array = $NinePatchRect/CenterContainer/SlotsContainer.get_children()


func _ready() -> void:
	visible = false
	_update_slots()

func _inventory_vis():
	if Input.is_action_just_pressed("Inventory"):
		if visible:
			visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_parent().get_parent().get_parent().mouse_can_move = false
		else:
			visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_parent().get_parent().get_parent().mouse_can_move = true

func _update_slots():
	for i in range(min(inv.Items.size(), slots.size())):
		slots[i].update(inv.Items[i])
