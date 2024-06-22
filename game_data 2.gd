extends Node

# GameData is the node containing all of this game's global data
# this includes ALL_PLAYABLE_CHARACTERS, cast, party, inventory, story progression,
# chests opened, etc.

# possibly: could make autoload scenes for the playable characters (Party1, Party2, Party3, Party4),
# and they hold the character currently being played as
# Or even more simply, there will be an autoload scene called Party
# Party has four children in it called Player1, Player2, Player3, Player4
# if characters are swapped into/out of the the party, Party's children are added/queue_free()'d accordingly

var title = "Mr. Light & Mr. Dark: The Ghetto Chronicles"
var playerCharacter
var health = 100
var current_scene = null
@onready var party = get_parent().get_child(get_parent().get_child_count() - 1).get_node("Party")
# while testing the game the above way is how I'm getting party now, but in practice I will use the following:
# var party = load("res://Party.tscn").instantiate()
# this will serve as a global container for the party with scripts for movement. character scenes from
# ALL_PLAYABLE_CHARACTERS will be addable to this party with methods GameData.enterParty() and GameData.leaveParty()
# a player character scene will be placed in one of the Party Character containers in Party
# when a battle starts this is the party that will be used to assign characters to the battle,
# and when returning to Exploration mode or entering a new area, this global party variable will be used
# to reference the exact object for the party
# as such, areas in the world will not be built with the party in them (or even a reference to the party)
# instead, during the area's _ready() function, add_child(GameData.party). that's it.
# and of course, NEVER queue_free() the party or any of the characters in ALL_PLAYABLE_CHARACTERS
# as that will cause issues for party referencing and character save data
var fadeout = false
var fadein = true
var pausing = false

#var battle_info: BattleInfo = BattleInfo.new()

var q = []
var number_of_states = 3

var dir = DirAccess.open("user://")

func _ready():
	party.name = "Party"
	playerCharacter = "Chio"
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)	# current scene is last child of root
	for i in range(number_of_states):
		q.append(false)
	q[0] = true

func _process(delta):
	if Input.is_key_pressed(KEY_I) and q[0]:
		fadeout = true
		fadein = false
		pausing = true
	#if Input.is_key_pressed(KEY_L) and q[1]:
	#	unpause(current_scene)

	if Input.is_action_just_pressed("battle"):
		current_scene.remove_child(current_scene.get_node("Party"))
		get_tree().change_scene_to_file("res://Battle.tscn")

	if fadein:
		fadeIn(current_scene, delta)
		if current_scene.get_node("Fade").color.a <= 0:
			fadein = false
	if fadeout:
		fadeOut(current_scene, delta)
	if pausing and current_scene.get_node("Fade").color.a >= 1:
		pause(current_scene)

	#if fadeout:
		#if current_scene.get_node("Fade").color.a >= 1:
			#fadeout = false
		#else:
			#fadeOut(current_scene, delta)
	#elif pausing:
		#fadeIn(PauseMenu, delta)

func pause(scene):
	#var pauseScreen = scene.get_node("PauseScreen")
	#scene.visible = false
	# pauseScreen.visible = true
	#pauseScreen.process_mode = PROCESS_MODE_WHEN_PAUSED
	#scene.process_mode = PROCESS_MODE_DISABLED
	scene.visible = false
	PauseMenu.visible = true
	party.get_child(0).get_node("Camera2D").enabled = false
	PauseMenu.camera().enabled = true
	get_tree().paused = true
	transition(0, 1)
	print("paused")


func fadeScreen(area):
	return area.get_node("Fade")


func fadeOut(area, delta):
	var fadeout = fadeScreen(area)
	if fadeout.color.a < 1:
		fadeout.color.a += delta * 4

func fadeIn(area, delta):
	var fadeout = fadeScreen(area)
	if fadeout.color.a > 0:
		fadeout.color.a -= delta * 4

'''
func unpause(scene):
	var pauseScreen = scene.get_node("PauseScreen")
	pauseScreen.visible = false
	scene.process_mode = PROCESS_MODE_INHERIT
	#pauseScreen.process_mode = PROCESS_MODE_DISABLED
	get_tree().paused = false
	transition(1, 0)
	print("unpaused")
'''

func transition(i, j):
	q[i] = false
	q[j] = true

# when ready to use in other scripts, call GameData.goto_scene("path_to_other_scene")
func goto_scene(path):	# makes sure the current scene's code is finished executing before switching
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	### add extra behavior/functionality here for custom use ###
	
	current_scene.free()
	var load_new = ResourceLoader.load(path)
	current_scene = load_new.instantiate()
	
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func addToParty(pm: Entity, index: int):
	if party.get_child(index).get_child_count() > 0:
		party.get_child(index).remove_child(party.get_child(index).get_child(0)) # removes a character
																				# if already in desired slot
	party.get_child(index).add_child(pm)

func removeFromParty(pm: Entity):
	for child in party.get_children():
		if child.get_child(0) == pm:
			child.remove_child(pm)
			return pm

func enter_battle():
	#battle_info.locationName = current_scene.locationName
	#get_tree().change_scene_to_packed()
	pass


func _on_battle_over():
	pass # Replace with function body.


# create some functions for different statuses
# func burned(): do damage over time; if hit by earth, do extra damage/boosted grounded chance.
													   # then let this status disappear
# func freezing()
# func sick()
# then, have funcref() made to these whenever a status lands on a character.
# then when hit by an attack in battle:
# 	for status in statuses:
#	boolean affected = false
#		if attack.element == [element_name]:
#			do this
#			affected = true
#		if attack.element == [element_name]:
#			do this
#			affected = true
#		if affected:
#			statuses.pop(status)   after checking for a status against an attack, if it hit a special effect,
#								   remove the status
