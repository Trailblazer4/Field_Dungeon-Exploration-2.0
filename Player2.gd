extends Entity

# var party_leader
var tracking_index = 14
var direction = Vector2(0, 0)

func _ready():
	stats[1] = 99


func _process(delta):
	if direction.x == -1:
		$Sprite2D.set_frame(4)
	elif direction.x == 1:
		$Sprite2D.set_frame(8)
	elif direction.y == -1:
		$Sprite2D.set_frame(12)
	elif direction.y == 1:
		$Sprite2D.set_frame(0)
	pass


func _physics_process(delta):
	pass
	'''
	var party1 = get_parent().get_child(0)
	if position.distance_squared_to(party1.position) > 1800.0:
		velocity = velocity.move_toward(position.direction_to(party1.position), 100.0) * SPEED
	else:
		velocity = Vector2(0, 0)
	move_and_slide()
	'''


func _on_party_1_history_updated(position_history):
	if (position_history.size() < tracking_index + 1):
		return
	var past_position = position_history[tracking_index]
	direction = position.direction_to(Vector2(past_position["x"], past_position["y"]))
	velocity = direction * past_position["Speed"]
	move_and_slide()
