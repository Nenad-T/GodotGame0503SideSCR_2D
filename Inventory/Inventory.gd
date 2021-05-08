extends Resource
class_name Inventory

var drag_data = null

signal items_changed(indexes)

export (Array, Resource) var items = []



func set_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item
	#when emiting items changed always return array even if its only 1 item that changed
	emit_signal("items_changed", [item_index])
	return previousItem

func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	#swap items
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])
	

func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem

#all items share the same ID because they are a resource so
#this function gives all of them unique ID 
func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items
