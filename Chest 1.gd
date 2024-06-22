extends StaticBody2D

@onready var touchbox = $Area2D
var open = false
var item = load("res://images/Green Elixir.png")

func _process(delta):
	for character in touchbox.get_overlapping_bodies():
		if Input.is_key_pressed(KEY_K) and !open:
			print("You found an item!")
			open = true
			var item_sprite = Sprite2D.new()
			item_sprite.texture = item
			add_child(item_sprite)
			item_sprite.position = Vector2(0, -10)
			var textbox = load("res://Textbox.tscn").instantiate()
			get_parent().get_node("Party/Party1/Camera2D").add_child(textbox)
			textbox.position = Vector2(-150, -220)
			textbox.setText("You got a ")
