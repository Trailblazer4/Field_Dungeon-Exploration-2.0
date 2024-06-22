extends Node

var ALL_PLAYABLE_CHARACTERS = [] # holds all references to all (playable) characters in the game
var party = load("res://Party.tscn").instantiate() # initial creation of the party container
var collision_objects = [] # bookkeeping for collision objects (might delete later)
var partyCamera = Camera2D.new() # the camera focused on Party1 (leader of party, controlled by player)
var locationInfo: LocationInfo

# instance player characters
var cinnamoroll = load("res://PlayableCharacters/Cinnamoroll.tscn").instantiate()
var misty = load("res://PlayableCharacters/Misty.tscn").instantiate()
var link = load("res://PlayableCharacters/Link.tscn").instantiate()
var fei = load("res://PlayableCharacters/Fei.tscn").instantiate()

# define status functions here followed by creating a list of funcrefs
func burn():
	# what burn does, damage over time to HP
	pass

# var statusRefs = [FuncRef("burn")]

# reference the current scene of the game. update this in the _ready() function of each level in the game
var current_scene = null


var SpellLibrary: Dictionary = {
	"Punch": Spell.new("Punch", Element.VOID, 10, 0),
	"Ar": Spell.new("Ar", Element.FIRE, 20, 20),
	"Au": Spell.new("Au", Element.ICE, 20, 20),
	"Re": Spell.new("Re", Element.HEAL, 20, 20),
	"Reli": Spell.new("Reli", Element.HEAL, 40, 30),
	"Temp": Spell.new("Temp", Element.WIND, 40, 30),
}


# chests dictionary. Each key is a location name (obtained from current_scene.locationInfo.locationName)
# referencing a list of chests in that location
# each chest is a list of attributes: an item (object of type Item), a boolean tracking whether the chest
# has been opened, and a position on the level's map

# adding entries to this dictionary and properly using the addChests() method, chests can easily and cleanly
# be added to a level whenever
var chests = {
	"Grass Field": [
		["Item Object", true, Vector2(250, 300)],
		["Ultra Potion", false, Vector2(400, 375)],
		["Cookie", false, Vector2(500, 500)],
		["Elixir", false, Vector2(800, 600)],
		["Silver Sword", false, Vector2(870, 600)],
	],
	"Steampunk Showdown": [
		["Rusted Sword", false, Vector2(300,600)],
	],
}
# each chest in the game will have a script referencing
# GameData.chests[current_scene.locationInfo.locationName][chestNum]
# each chest will in its script be given a chestNum
# there will be a function open() which, if chest is closed, opens it
# and gives its item to the inventory, and sets open to true
var inventory = [
	[load("res://ItemLibrary/Elixir.tscn").instantiate(), 99],
]
func add_to_inventory(item_title: String):
	for item in inventory:
		if item[0].title == item_title:
			item[1] += 1
			return
	inventory.append([load("res://ItemLibrary/%s.tscn" % item_title).instantiate(), 1]) # items are only instantiated once in memory
																		  # paired with a counter


# handling screen fade transitions
var fadeout = false
var fadein = true
var pausing = false
var battling = false

var q = []
var number_of_states = 3

var dir = DirAccess.open("user://")


enum Status{
	BRN,
	FRZ,
	GRND,
	SICK,
	WET,
	STM,
	ZAP,
}

enum Element{
	VOID,
	FIRE,
	ICE,
	WIND,
	EARTH,
	DARK,
	LIGHT,
	HEAL,
	LIGHTNING,
	SNOW,
	MAGMA,
	METAL,
	SOUND,
	CLOUD,
	GRAVITY,
	UNSTABLE,
}


#var tf = ["Crimson", "Celeste", "Lyra", "Dante"]
func _ready():
	var chars = ["Rock", "Proto", "X", "Zero"]
	chars.insert(2, "Roll")
	print(chars)
	
	#party.move_child(party.get_child(0), 2)
	#print(party.get_children())

	#if tf:
		#print("Truthy")
	#else:
		#print("Falsy")
	#var burn :int = Status.BRN
	#print(burn)
	# instance every character in the game once and save them to A_P_C for future use/reference
	ALL_PLAYABLE_CHARACTERS.append(cinnamoroll)
	ALL_PLAYABLE_CHARACTERS.append(misty)
	ALL_PLAYABLE_CHARACTERS.append(link)
	ALL_PLAYABLE_CHARACTERS.append(fei)
	print(ALL_PLAYABLE_CHARACTERS[-1])

	# put characters in the party
	#party.get_child(0).add_child(cinnamoroll)
	#collision_objects.append(cinnamoroll.get_child(1))
	## when a character is added to the party, store a reference to their collision object in collision_objects
	## then, we will remove them from their parent and place them as a child of the party slot instead
	## when the character is removed from the party, move their collision object back under them before removing
	## move it back under them when swapping party placements as well
	## if the character swings a weapon it should be fine as the weapon will have its own collision shape
	#party.get_child(1).add_child(misty)
	#collision_objects.append(misty.get_child(1))
	#party.get_child(2).add_child(link)
	#collision_objects.append(link.get_child(1))
	#print(party.get_child(-2).get_child(0)) # negative index works with get_child, too!
	addToParty(cinnamoroll, 0)
	addToParty(misty, 1)
	addToParty(link, 2)
	addToParty(fei, 3)
	swapParty(0, 2)
	swapParty(0, 3)

	#swapParty(0, 2)
	#removeFromParty(1)
	var a = 32; var b = 255
	a = a ^ b
	b = a ^ b
	a = a ^ b
	print("a: ", a, ", b: ", b)
	#swapParty(0, 2)

	#for pm in party.get_children():
		#pm.set_collision_layer(0b1)
		#pm.set_collision_mask(0b1100)

	for i in range(number_of_states):
		q.append(false)
	q[0] = true

	partyCamera.zoom = Vector2(2, 2)
	#party.get_child(0).add_child(partyCamera)
	#var co = party.get_child(0).get_child(0).get_child(1)
	#party.get_child(0).get_child(0).remove_child(co)
	#party.get_child(0).add_child(co)

	#var locationInfo = LocationInfo.new("Grass Field")
	#locationInfo.addToEnemyPool("Pircekin", 70.1)
	#locationInfo.addToEnemyPool("Iron Knight", 100)
	#print(locationInfo.locationName, " Enemy Pool: ", locationInfo.enemyPool)


func _process(delta):
	if Input.is_key_pressed(KEY_I) and q[0]:
		current_scene.get_node("Fade/AnimationPlayer").play("fadeout")
		pausing = true
		#fadeout = true
		#fadein = false
		#pausing = true
## I just realized: why go through the trouble of coding this animation with booleans and whatever
## in _process() when I could do it with an animation player
	#if fadein:
		#fadeIn(current_scene, delta)
		#if current_scene.get_node("Fade").color.a <= 0:
			#fadein = false
	#if fadeout:
		#fadeOut(current_scene, delta)
	if pausing and current_scene.get_node("Fade").color.a >= 1:
		pause(current_scene)
	
	if Input.is_action_just_pressed("switch"):
		GameData.rotateParty()


func pause(scene):
	#var pauseScreen = scene.get_node("PauseScreen")
	#scene.visible = false
	# pauseScreen.visible = true
	#pauseScreen.process_mode = PROCESS_MODE_WHEN_PAUSED
	#scene.process_mode = PROCESS_MODE_DISABLED
	scene.visible = false
	PauseMenu.visible = true
	party.get_child(0).get_child(2).enabled = false
	PauseMenu.camera().enabled = true
	get_tree().paused = true
	transition(0, 1)
	PauseMenu.get_node("Fade/AnimationPlayer").play("fadein")
	#print("paused")


#func fadeScreen(area):
	#return area.get_node("Fade")
#
#
#func fadeOut(area, delta):
	#var fadeout = fadeScreen(area)
	#if fadeout.color.a < 1:
		#fadeout.color.a += delta * 4
#
#func fadeIn(area, delta):
	#var fadeout = fadeScreen(area)
	#if fadeout.color.a > 0:
		#fadeout.color.a -= delta * 4


func transition(i, j):
	q[i] = false
	q[j] = true


func rotateParty(): # rotate the party so that character 1 is now in slot 4, character 4 is in slot 3, etc.
	var tempParty = []
	for i in range(len(party.get_children())):
		if party.get_child(i).get_child_count() > 0:
			tempParty.append(removeFromParty(i))

	for i in range(len(tempParty)):
		var index = i - 1
		if index < 0:
			var offset: int = party.get_child_count() - len(tempParty)
			index -= offset 
		addToParty(tempParty[i], index)
	
	print("Temp Party: ", tempParty)
	print("Party:")
	for slot in party.get_children():
		print(slot.get_children())


func swapParty(i: int, j: int): # swap places of two characters in party
	var pm1 = removeFromParty(i)
	var pm2 = removeFromParty(j)
	addToParty(pm2, i)
	addToParty(pm1, j)


func addToParty(e: Entity, index: int):
	if index < -4 or index > 3:
		print("Invalid index")
		return
	party.get_child(index).add_child(e)
	var co = e.get_child(1) # collision object
	collision_objects.append(co)
	e.remove_child(co)
	party.get_child(index).add_child(co)
	if index == 0:
		party.get_child(index).add_child(partyCamera) # if adding character to slot 1,
													  # give a camera after giving character
	# note: parent.move_child(node, position) could also be useful for these kinds of tree setups
		party.get_child(index).move_child(partyCamera, 2)


func removeFromParty(index: int):
	if index < -4 or index > 3:
		print("Invalid index")
		return
	var pm = party.get_child(index).get_child(0)
	party.get_child(index).remove_child(pm)
	var co = party.get_child(index).get_child(0)
	party.get_child(index).remove_child(co)
	pm.add_child(co)
	pm.move_child(co, 1)
	if index == 0:
		party.get_child(index).remove_child(partyCamera)
	return pm # after removing character at specified slot from the tree,
			  # a reference to the character is returned


# these functions will help us generalize/simplify exiting/entering zones
func travel_to(path: String): # path is a new level scene
	current_scene.remove_child(party) # before anything, remove the party so it's not erased
	# then fade the screen out
	get_tree().change_scene_to_file(path) # change level
	# in the _ready() function of the new scene there should be a LocationInfo made,
	# and a statement setting GameData.current_scene = self
	# fade the screen in
	addChests()
	current_scene.add_child(party)


func addChests():
	var loadChest = load("res://Chest.tscn")
	var chestsHere = chests[current_scene.locationInfo.locationName]
	for i in range(len(chestsHere)):
		var newChest = loadChest.instantiate()
		add_child(newChest)
		newChest.setChest(i, current_scene.locationInfo.locationName, chestsHere[i][2])


func enter_battle():
	# play animation for battle fade
	# current_scene.remove_child(party)
	# get_tree().change_scene_to_packed("res://Battle.tscn")
	
	# then in Battle.tscn._ready(), remove characters from GameData.party and add them to slots in Battle.party
	pass
