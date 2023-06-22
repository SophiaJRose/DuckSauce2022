extends Node2D


# Declare member variables here. Examples:
var colour: Color
var boxStartPoints = {}
var totalDistance: int
var allMoved: bool

func init(boxColour: Color):
	colour = boxColour


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.get_node("BoxColour").color = colour
		boxStartPoints[child.name] = child.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	totalDistance = 0
	allMoved = true
	for child in get_children():
		var startPoint = boxStartPoints[child.name]
		if child.global_position != startPoint:
			var displacement: Vector2
			displacement = child.global_position - startPoint
			totalDistance += displacement.length()
		else:
			allMoved = false
