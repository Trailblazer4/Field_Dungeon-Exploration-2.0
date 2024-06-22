extends Node2D

var nextLevel = load("res://Dungeon.tscn") # or preload, either seems to work fine
# Called when the node enters the scene tree for the first time.
#var locationInfo = LocationInfo.new("Grass Field")
var loadChest = load("res://Chest.tscn")

var fadeout = false

func _ready():
	GameData.current_scene = self
	PauseMenu.current_scene = self
	var elixir: Item = load("res://ItemLibrary/Elixir.tscn").instantiate()
	#
	#var elixir_sprite = Sprite2D.new()
	#elixir_sprite.texture = elixir.get_node("Sprite2D").texture
	#elixir_sprite.scale = elixir.scale
	#$"Chest 1".add_child(elixir_sprite)
	#
	#var elixir_sprite2 = Sprite2D.new()
	#elixir_sprite2.texture = elixir.get_node("Sprite2D").texture
	#elixir_sprite2.scale = elixir.scale
	#$"Chest 1".add_child(elixir_sprite2)
	#elixir_sprite2.position.x -= 20
	#
	elixir.apply_effect(GameData.ALL_PLAYABLE_CHARACTERS[3])

	$Fade.visible = true
	add_child(GameData.party)
	
	#for pm in GameData.party.get_children():
		#if pm.get_child(0).get_node("Sprite2D").material:
			#print(pm.get_child(0).get_node("Sprite2D").material.shader)
		#else:
			#pm.get_child(0).get_node("Sprite2D").material = ShaderMaterial.new()
	
	add_child(load("res://EnemyLibrary/Slime.tscn").instantiate())
	GameData.party.position = Vector2(250, 170)
	
	
	#if(GameData.locationInfo):
		#GameData.locationInfo.queue_free()
	GameData.locationInfo = LocationInfo.new("Grass Field")
	GameData.locationInfo.addToEnemyPool("Gibbler", 94)
	GameData.locationInfo.addToEnemyPool("The Egg", 6)
	addChests()
	
	print(GameData.locationInfo)
	$Fade/AnimationPlayer.play("fadein")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("switch"):
		#GameData.rotateParty()
		#var temp = GameData.party.get_child(0).get_child(0)
		#GameData.party.get_child(0).remove_child(temp)
		#var camera = GameData.party.get_child(0).get_child(0)
		#GameData.party.get_child(0).remove_child(camera)
		#for i in range(3):
			#var newChild = GameData.party.get_child(i + 1).get_child(0)
			#GameData.party[i + 1].remove_child(newChild)
			#GameData.party[i].add_child(newChild)
		#GameData.party[3].add_child(temp)
		#GameData.party.get_child(0).add_child(camera)

	if Input.is_key_pressed(KEY_M):
		emptyPositionData()
		remove_child(GameData.party) # remove party so it doesn't get queue_free()'d
		get_tree().change_scene_to_packed(nextLevel)
	
	if Input.is_action_just_pressed("start_battle"):
		$Fade/AnimationPlayer.play("battle_fade")
		remove_child(GameData.party)
		GameData.transition(0, 2)
		get_tree().change_scene_to_file("res://Battle.tscn")
		
	#if Input.is_key_pressed(KEY_H):
		#print("Before: ", GameData.link.getHP())
		#GameData.cinnamoroll.use(GameData.cinnamoroll.moveset[1], GameData.link)
		#print("After: ", GameData.link.getHP())


func _physics_process(delta):
	pass


func emptyPositionData():
	var leader = GameData.party.get_child(0)
	leader.position_history.clear()


func addChests():
	var chestsHere = GameData.chests[GameData.locationInfo.locationName]
	for i in range(len(chestsHere)):
		var newChest = loadChest.instantiate()
		add_child(newChest)
		newChest.setChest(i, GameData.locationInfo.locationName, chestsHere[i][2])


func checkType(v):
	if v is int:
		print("Integer")
	elif v is String:
		print("Word")
	elif v is bool:
		print("TF")
	elif v is Entity:
		print("Party Member")
# use this strength in using statuses
# when a target is hit with a status, they will be given a function reference to that statuses effects
# this function will be formatted:
# if input to function call is int (then this is a damage calculation):
#	damageCalc.addEffectsFromStatus
# elif input to func call is bool (then this is saying to apply effects occuring after the character's turn):
#	play passive effect

# alternatively I could just use an int input with match(input) to decide effects
# 0: passive effect
# 1: modify the afflicted's damage calculation (such as burn decreasing magic defense)
# 2: check for extra effects from the opponent's attack (such as damage boost/replacement with another ailment)

# func burn(int whichEffect):
#	match(whichEffect):
#		0:
#			hp -= (hp * 1/16)
#		1:
#			attackMod /= 1.5
#		2:
#			if thisTurn(attacker).chosenSkill.element == Element.WIND:
#				thisTurn.damageCalc.magicMod *= 1.3     damage
#				thisTurn.damageCalc.chanceMod *= 1.6    status chance
#				remove burn effect
# each skill/equipment in the game can hold statuses to afflict, and every Entity in the game can hold
# statuses to be affected by
