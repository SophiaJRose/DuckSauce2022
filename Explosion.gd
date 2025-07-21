extends Node2D

class_name Explosion

# Declare member variables here. Examples:
@onready var animSprite: AnimatedSprite2D = $ExplosionAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	animSprite.play("Explosion")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animSprite.frame == animSprite.sprite_frames.get_frame_count(animSprite.animation) - 1 && animSprite.frame_progress > 0.75:
		queue_free()


func _on_ExplosionHitbox_body_entered(body):
	if body.name.ends_with("Box"):
		var distance: Vector2
		var knockback: Vector2
		distance = body.global_position - position
		knockback = distance.normalized() * (4800 / sqrt(distance.length()))
		body.apply_impulse(knockback, Vector2(0,0))
