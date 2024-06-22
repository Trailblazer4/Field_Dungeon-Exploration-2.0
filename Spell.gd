extends Node

class_name Spell

var title: String
var element: GameData.Element
var power: int
var spReq: int
#var effects = []

func _init(t: String, e: GameData.Element, p: int, spr: int):
	title = t
	element = e
	power = p
	spReq = spr
#
#func _ready():
	#pass # Replace with function body.
#
#
#func _process(delta):
	#pass
