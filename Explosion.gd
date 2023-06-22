extends Node2D

class_name Explosion

# Declare member variables here. Examples:
var anim: int
var animSprite: AnimatedSprite

func _init(animation:int = 1):
	anim = animation

# Called when the node enters the scene tree for the first time.
func _ready():
	animSprite = get_node("ExplosionAnimation")
	animSprite.animation = "Explosion" + String(anim)
	animSprite.frame = 0
	animSprite.playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animSprite = get_node("ExplosionAnimation")
	if animSprite.frame == 8:
		queue_free()


func _on_ExplosionHitbox_body_entered(body):
	if body.name.ends_with("Box"):
		var distance: Vector2
		var knockback: Vector2
		distance = body.global_position - position
		knockback = distance.normalized() * (4000 / sqrt(distance.length()))
		body.apply_impulse(Vector2(0,0),knockback)
