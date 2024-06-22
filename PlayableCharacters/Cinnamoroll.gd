extends Entity


func _init():
	super()
	myName = "Cinnamoroll"

# Called when the node enters the scene tree for the first time.
func _ready():
	moveset.append(GameData.SpellLibrary["Re"])
	moveset.append(GameData.SpellLibrary["Reli"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# PM Container will have the following logic in _physics_process(delta):
# if velocity == Vector2.ZERO:
#	get_child(0).face(direction)
# else:
#	get_child(0).walk(velocity)

func walk(v: Vector2): # these functions will be called by the Party Member container, with velocity and
			# direction inputs respectively, to reference the function within the party member
			# to play the appropriate animations
	if v.y < 0:
		$Sprite2D/AnimationPlayer.play("walk_up")
	elif v.y > 0:
		$Sprite2D/AnimationPlayer.play("walk_down")
	elif v.x < 0:
		$Sprite2D/AnimationPlayer.play("walk_left")
	elif v.x > 0:
		$Sprite2D/AnimationPlayer.play("walk_right")

func face(d: Vector2):
	$Sprite2D/AnimationPlayer.stop()
	if d.x < 0:
		$Sprite2D.set_frame(2)
	elif d.x > 0:
		$Sprite2D.set_frame(1)
	elif d.y < 0:
		$Sprite2D.set_frame(3)
	elif d.y > 0:
		$Sprite2D.set_frame(0)


func face_left():
	$Sprite2D/AnimationPlayer.stop()
	$Sprite2D.set_frame(2)
