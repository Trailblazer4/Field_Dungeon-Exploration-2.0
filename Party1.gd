extends Entity

# var stats = [100, 12, 10]
# idea: I could delay the party members more, and make them "catch up" when I stop using the "stop_frames" idea
# or just use some acceleration based on distance from next position to go to
# right now it looks good though
var position_history = []
var max_history_length = 45
signal history_updated
# const STOP_DELAY: int = 2
# var stop_frames := STOP_DELAY

var direction = Vector2(0, 1)

func _ready():
	# var player2 = get_parent().get_child(1).position
	#for i in range(20):
		#position_history.append({"x": player2.x + ((position.x - player2.x) * (i / 20)), "y": player2.y + ((position.y - player2.y) * (i / 20))})
	print(name)

func _process(delta):
	if velocity == Vector2.ZERO:
		get_child(0).face(direction)
	else:
		get_child(0).walk(velocity)

func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0

	var character_moved = false

	if Input.is_action_pressed("left"):
		direction = Vector2(-1, 0)
		velocity.x -= 1
		character_moved = true
	if Input.is_action_pressed("right"):
		direction = Vector2(1, 0)
		velocity.x += 1
		character_moved = true
	if Input.is_action_pressed("up"):
		direction = Vector2(0, -1)
		velocity.y -= 1
		character_moved = true
	if Input.is_action_pressed("down"):
		direction = Vector2(0, 1)
		velocity.y += 1
		character_moved = true

	velocity = velocity.normalized() * SPEED * delta * 100
	if Input.is_action_pressed("dash"):
		velocity *= 2.0
	move_and_slide()

	if(character_moved):
		add_position_to_history()
		emit_signal("history_updated", position_history)


func add_position_to_history():
	var past_position = {"x": position.x, "y": position.y, "Speed": velocity.length()}
	position_history.push_front(past_position)
	
	if (position_history.size() > max_history_length):
		position_history.pop_back()

# saving a scene is the same as saving an object of a class, so I will save the character scenes
# to the party/cast/ALL_PLAYABLE_CHARACTERS arrays

# I will incorporate set/get stats/weapons/character info for the Entity class
# to be able to change their objects' stats when needed

# any variables/functions I put in Entity class or in individual scenes' scripts can be used by the scenes
# and referenced by code in GameData, current_scene, or in the scene's script

# when game is first started, if user selects new game then make a new file in "user://"
# if this is their first save file, title it "user://save0.res" or something like that

# var dir = DirAccess.open("user://"); print(dir.get_files())   will show us how many files are in our saves folder

# so, when the player clicks "New Game" on the title screen we can make a new save with the name:
# var dir = DirAccess.open("user://")
# var new_save_name = "user://save" + len(dir.get_files()) + ".res"

# if the player click "Continue" and then chooses a save file, open that save file with that info

# Player scenes are only instantiated upon "New Game" being chosen
# They are immediately placed in ALL_PLAYABLE_CHARACTERS
# when saving the game, ALL_PLAYABLE_CHARACTERS is saved along with all other necessary carried info
# in a dictionary in "user://"

# and again, PlayerCharacters can be updated in real time by referencing their pointers in our arrays,
# most conveniently (and most likely to be used) in the party array
