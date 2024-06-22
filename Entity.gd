@icon("res://images/Chio Icon.png")
extends CharacterBody2D

class_name Entity

var stats
var SPEED = 100.0
var myName: String
var speedCounter: int
var moveset: Array[Spell] = []
@onready var basic_attack: Spell = GameData.SpellLibrary["Punch"]
var defending: bool = false

func _init():
	stats = [180, 24, 20, 15, 13, 12, 8]
	speedCounter = 0


func setHP(shp):
	stats[0] = shp

func getHP():
	return stats[0]

func setSP(ssp):
	stats[1] = ssp

func getSP():
	return stats[1]

func setAtk(satk):
	stats[2] = satk

func getAtk():
	return stats[2]

func setDef(sdef):
	stats[3] = sdef

func getDef():
	return stats[3]
	
func setMag(smag):
	stats[4] = smag

func getMag():
	return stats[4]

func setMgDf(smgdf):
	stats[5] = smgdf

func getMgDf():
	return stats[5]

func setSpd(sspd):
	stats[6] = sspd

func getSpd():
	return stats[6]

func updateCounter(reset: bool = false):
	if reset:
		speedCounter = 0
	else:
		speedCounter += stats[6]

func use(skill, target: Entity): # skill is of type Spell or Item
	if skill is Spell:
		var totalDmg = (skill.power + getMag()) # - (target.getMgDf())
		if skill.element == GameData.Element.HEAL:
			target.setHP(target.getHP() + totalDmg)
		else:
			target.setHP(target.getHP() - (totalDmg - target.getMgDf()))
		
		if target.getHP() < 0:
			target.setHP(0)
	elif skill is Item:
		skill.apply_effect(target)
	else:
		print("Error: Selected action is neither Spell nor Item")
