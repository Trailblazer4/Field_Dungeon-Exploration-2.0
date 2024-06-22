extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("up") and get_parent().cursor > 0:
		position.y -= 142
		get_parent().cursor -= 1
		print(get_parent().cursor)
	if Input.is_action_just_pressed("down") and get_parent().cursor < 3:
		position.y += 142
		get_parent().cursor += 1
		print(get_parent().cursor)
