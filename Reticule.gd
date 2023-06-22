extends Node2D

const Explosion = preload("res://Explosion.tscn")

# Declare member variables here. Examples:
var numClicks: int


# Called when the node enters the scene tree for the first time.
func _ready():
	numClicks = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
	if Input.is_action_just_pressed("click") && numClicks > 0:
		var ExplosionInstance = Explosion.instance()
		ExplosionInstance._init(2)
		ExplosionInstance.position = position
		get_parent().add_child(ExplosionInstance)
		numClicks -= 1
