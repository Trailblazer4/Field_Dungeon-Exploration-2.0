extends Entity


func _init():
	super()
	myName = "Fei"


func _ready():
	moveset.append(GameData.SpellLibrary["Ar"])
	moveset.append(GameData.SpellLibrary["Temp"])
	$Sprite2D.set_frame(0)


func _process(delta):
	pass


func walk(velocity: Vector2):
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	$Sprite2D/AnimationPlayer.play("walk_side")

func face(dir: Vector2):
	$Sprite2D/AnimationPlayer.stop()
	$Sprite2D.set_frame(0)


func face_left():
	$Sprite2D/AnimationPlayer.stop()
	$Sprite2D.set_frame(0)
	$Sprite2D.flip_h = true
