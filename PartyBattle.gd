extends Node2D

#@onready var party = GameData.party

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#for i in range(len(get_children())):
		#var temp = party_get(i).get_child(0)
		#party_get(i).remove_child(temp)
		#get_child(i).add_child(temp)
		#print(get_child(i).get_children())
	#for i in range(4):
		#var player = GameData.removeFromParty(GameData.party.get_child(i).get_child(0)) # remove from party,
		#get_child(i).add_child(player)													# then add to this scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_battle_over():
	var battleParty = get_children()
	for i in range(len(battleParty)):
		var pm = battleParty[i].get_child(0)
		battleParty[i].remove_child(pm)
		GameData.addToParty(pm, i)

func party_get(index: int):
	if index < 0 or index > 3:
		return -1
	return GameData.party.get_child(index)
