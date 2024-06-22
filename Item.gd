extends Node

class_name Item

var title: String


func apply_effect(e: Entity): # define this in every item that extends this class
	pass

# if multiple instances of the item's sprite are required at once, rather than showing the item on-screen
# make a variable to instance the Sprite2D of the item and add that to the scene

# var item_sprite = Sprite2D.new()
# item_sprite.set_texture(item.get_node("Sprite2D").texture)
# party_member.add_child(item_sprite); item_sprite.position.y -= 15
# party_member.remove_child(item_sprite); item_sprite.queue_free()
