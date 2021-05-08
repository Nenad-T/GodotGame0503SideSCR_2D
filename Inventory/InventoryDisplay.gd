extends GridContainer

var inventory = preload("res://Inventory/Inventory.tres")

func _ready():
	inventory.connect("items_changed", self, "on_items_changed")
	inventory.make_items_unique()
	update_inventory_display()
	

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

#update one slot
func update_inventory_slot_display(item_index):
	#get the slot in which the item is
	var inventorySlotDisplay = get_child(item_index)
	#get the item that was passed in this function
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)


func on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

#to catch if an item is dropped outside of the slots
func _unhandled_input(event):
	if event.is_action_released("LeftMouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
