extends CenterContainer

var inventory = preload("res://Inventory/Inventory.tres")

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		if item.can_stack:
			itemAmountLabel.text = str(item.amount)
	else:
		itemTextureRect.texture = load("res://Inventory/item_slot_empty_background.png")
		itemAmountLabel.text = ""

#GODOT build in functions for drag and drop
func get_drag_data(_position):
	#this is actually the index number for the slot but it coresponds with the
	#index number for the inventory array
	var item_index = get_index()
	
	var item = inventory.remove_item(item_index)
	if item is Item:
		#create a new dictionary
		var data = {}
		#then stores the item in the dictionary so that the can_drop_data function has item
		data.item = item
		#save the item_index so if the item is droped somewhere else we can save it
		data.item_index = item_index
		#to view the item beeing draged acros screen
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data
#this function tells when this control node can accept data
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	#get the item you are holding
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	#to stack items
	if my_item is Item and my_item.name == data.item.name and my_item.can_stack:
		var able_to_add = my_item.max_stack - my_item.amount
		if able_to_add >= data.item.amount:
			my_item.add_item_quantity(data.item.amount)
			inventory.emit_signal("items_changed", [my_item_index])
		else:
			my_item.add_item_quantity(able_to_add)
			data.item.decrease_item_quantity(able_to_add)
			inventory.set_item(data.item_index, data.item)
			inventory.emit_signal("items_changed", [my_item_index])
	else:
			#swap it in inventory, if inventory is null dosnt mater the item in hand will
			#become null, if there is item in inventory it will swap with the one in hand
			inventory.swap_items(my_item_index, data.item_index)
			#so that the item you are holding dosnt get erased
			inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null
