extends Resource
class_name Item

export(String) var name = ""
export(Texture) var texture
export var can_stack = true
export (int) var amount


var max_stack = 99

func add_item_quantity(amount_to_add):
	amount += amount_to_add

func decrease_item_quantity(amount_to_decrease):
	amount -= amount_to_decrease
