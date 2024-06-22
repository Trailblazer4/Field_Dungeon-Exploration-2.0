extends Control


var bme = load("res://BattleMenuElement.tscn")
var cursor: int = 0
#var defaultColor: Color = Color(0/255, 128/255, 125/255, 120/255)
#var selectColor: Color = Color(0/255, 148/255, 155/255, 150/255)
#var defaultColor: Color = Color(0.0, 0.501, 0.49, 0.4706)
#var selectColor: Color = Color(0.0, 0.5804, 0.6078, 0.588)
@export var defaultColor: Color = Color("00807d78")
@export var selectColor: Color = Color("00b9b582")
var limits: Array[int] = [0,8]

var spells = [
	#["Flame", "Ar", 20],
	#["Flame", "Ard", 40],
	#["Flame", "Ardent", 60],
	#["Flame", "Ar", 20],
	#["Flame", "Ard", 40],
	#["Flame", "Ardent", 60],
	#["Flame", "Ar", 20],
	#["Flame", "Ard", 40],
	#["Flame", "Ardent", 60],
	#["Flame", "Ar", 20],
	#["Flame", "Ard", 40],
	#["Flame", "Ardent", 60],
	#["Flame", "Ar", 20],
	#["Flame", "Ard", 40],
	#["Flame", "Ardent", 60],
]

func _ready():
	#makeMagic(spells)
	pass

# i guess because of how it's set up already, i should make a function in this scene to create the magic menu
func makeMagic(spellList: Array[Spell]):
	spells = spellList
	for thing in $"VBoxContainer".get_children():
		$VBoxContainer.remove_child(thing)
		thing.queue_free()
	
	for i in range(len(spells)):
		var newLine = bme.instantiate()
		$VBoxContainer.add_child(newLine)
		
		newLine.get_node("HSplitContainer/Icon").text = str(spells[i].element)
		newLine.get_node("HSplitContainer/HSplitContainer/Name").text = spells[i].title
		newLine.get_node("HSplitContainer/HSplitContainer/SP Req").text = str(spells[i].spReq)
		newLine.get_node("ColorRect").color = defaultColor
		
		if i > 8:
			newLine.visible = false
	cursor = 0
	if len(spellList) > 0:
		$"VBoxContainer".get_child(cursor).get_node("ColorRect").color = selectColor


func makeItems(itemsList: Array):
	for thing in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(thing)
		thing.queue_free()
	
	for i in range(len(itemsList)):
		var newLine = bme.instantiate()
		$VBoxContainer.add_child(newLine)
		
		newLine.get_node("HSplitContainer/Icon").text = "Healing"
		newLine.get_node("HSplitContainer/HSplitContainer/Name").text = itemsList[i][0].title
		newLine.get_node("HSplitContainer/HSplitContainer/SP Req").text = "x%d" % itemsList[i][1]
		newLine.get_node("ColorRect").color = defaultColor
		
		if i > 8:
			newLine.visible = false
	cursor = 0
	if len(itemsList) > 0:
		$"VBoxContainer".get_child(cursor).get_node("ColorRect").color = selectColor

func _process(delta):
	if Input.is_action_just_pressed("up") and cursor > 0:
		updateCursor(-1)
		if cursor < limits[0]:
			$VBoxContainer.get_child(limits[1]).visible = false
			limits[0] -= 1; limits[1] -= 1
			$VBoxContainer.get_child(limits[0]).visible = true

	if Input.is_action_just_pressed("down") and cursor < len(spells) - 1:
		updateCursor(1)
		if cursor > limits[1]:
			$VBoxContainer.get_child(limits[0]).visible = false
			limits[0] += 1; limits[1] += 1
			$VBoxContainer.get_child(limits[1]).visible = true


func updateCursor(upDir: int):
	$VBoxContainer.get_child(cursor).get_node("ColorRect").color = defaultColor
	cursor += upDir
	$VBoxContainer.get_child(cursor).get_node("ColorRect").color = selectColor
