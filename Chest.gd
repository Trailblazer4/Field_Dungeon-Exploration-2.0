extends StaticBody2D

var chestNum: int
var place: String


func _process(delta):
	if Input.is_key_pressed(KEY_K) and GameData.party.get_child(0) in $Area2D.get_overlapping_bodies():
		open()


func setChest(cn: int, pl: String, pos: Vector2):
	chestNum = cn
	place = pl
	position = pos
	if GameData.chests[place][chestNum][1]:
		$Sprite2D.set_frame(1)
	else:
		$Sprite2D.set_frame(0)


func open():
	if !GameData.chests[place][chestNum][1]:
		GameData.chests[place][chestNum][1] = true
		$Sprite2D.set_frame(1)
		print("You got ", GameData.chests[place][chestNum][0])
		GameData.add_to_inventory(GameData.chests[place][chestNum][0])
		print(GameData.chests)


func setIcon(path: String):
	$Sprite2D.set_texture(path)
