extends Entity


func _init():
	super()
	myName = "Misty"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func walk(v): # these functions will be called by the Party Member container, with velocity and
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

func face(d):
	$Sprite2D/AnimationPlayer.stop()
	if d.x < 0:
		$Sprite2D.set_frame(4)
	elif d.x > 0:
		$Sprite2D.set_frame(8)
	elif d.y < 0:
		$Sprite2D.set_frame(12)
	elif d.y > 0:
		$Sprite2D.set_frame(0)


func face_left():
	$Sprite2D/AnimationPlayer.stop()
	$Sprite2D.set_frame(4)
