extends Panel
class_name ItemDisplay

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay

func update(item: InvRes):
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
