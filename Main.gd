extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const BoxPattern1 = preload("res://BoxPattern1.tscn")
const BoxPattern2 = preload("res://BoxPattern2.tscn")
const BoxPattern3 = preload("res://BoxPattern3.tscn")
var Patterns = [BoxPattern1,
				BoxPattern2,
				BoxPattern3	]
var Red = Color8(224,64,64)
var Green = Color8(64,224,64)
var Blue = Color8(64,64,224)
var Yellow = Color8(224,224,64)
var Orange = Color8(224,128,64)
var Cyan = Color8(64,224,256)
var Purple = Color8(160,64,224)
var Pink = Color8(224,96,128)
var Colours = {	"Red": Red,
				"Green": Green,
				"Blue": Blue,
				"Yellow": Yellow,
				"Orange": Orange,
				"Cyan": Cyan,
				"Purple": Purple,
				"Pink": Pink		}
var usedColours = []
var spawns = [	Vector2(204,100),
				Vector2(204,500),
				Vector2(306,300),
				Vector2(512,100),
				Vector2(512,500),
				Vector2(718,300),
				Vector2(820,100),
				Vector2(820,500),	]
var bonuses = {	"AllRedMoved": false,
				"AllGreenMoved": false,
				"AllBlueMoved": false,
				"AllYellowMoved": false,
				"AllOrangeMoved": false,
				"AllCyanMoved": false,
				"AllPurpleMoved": false,
				"AllPinkMoved": false,
				"AllColoursMoved": false,
				"AllBlocksMoved": false		}
var bonusValues = {	"AllRedMoved": 1000,
					"AllGreenMoved": 1000,
					"AllBlueMoved": 1000,
					"AllYellowMoved": 1000,
					"AllOrangeMoved": 1000,
					"AllCyanMoved": 1000,
					"AllPurpleMoved": 1000,
					"AllPinkMoved": 1000,
					"AllColoursMoved": 500,
					"AllBlocksMoved": 10000	}
var bonusStrings = {"AllRedMoved": "All Red Blocks Moved +",
					"AllGreenMoved": "All Green Blocks Moved +",
					"AllBlueMoved": "All Blue Blocks Moved +",
					"AllYellowMoved": "All Yellow Blocks Moved +",
					"AllOrangeMoved": "All Oranges Blocks Moved +",
					"AllCyanMoved": "All Cyan Blocks Moved +",
					"AllPurpleMoved": "All Purple Blocks Moved +",
					"AllPinkMoved": "All Pink Blocks Moved +",
					"AllColoursMoved": "Blocks Of All Colours Moved +",
					"AllBlocksMoved": "All Blocks Moved +"		}
var distanceScore: int
var totalScore: int

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TextLayer").get_node("ScoreLabel").visible = false
	randomize()
	for spawn in spawns:
		var pattern = Patterns[randi() % Patterns.size()].instantiate()
		var colour = Colours.keys()[randi() % Colours.size()]
		while (usedColours.has(colour)):
			colour = Colours.keys()[randi() % Colours.size()]
		pattern.init(Colours[colour])
		usedColours.append(colour)
		pattern.name = colour + "Pattern"
		pattern.position = spawn
		add_child(pattern)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
	var textLayer = get_node("TextLayer")
	var scoreText = textLayer.get_node("ScoreLabel")
	var explosionCounter = textLayer.get_node("ExplosionCounter")
	var explosionCount = get_node("Reticule").numClicks
	var explosionCounterString = "Explosions Left: %s" % explosionCount
	if explosionCount == 0:
		explosionCounterString = explosionCounterString + ". Press R to reset or Esc to quit."
	explosionCounter.text = explosionCounterString
	distanceScore = 0
	totalScore = 0
	var allColoursMoved = true
	var allBlocksMoved = true
	for child in get_children():
		if child.name.ends_with("Pattern"):
			if child.totalDistance == 0:
				allColoursMoved = false
			distanceScore += child.totalDistance
			totalScore += child.totalDistance
			if child.allMoved:
				var colourString = child.name.replace("Pattern", "")
				bonuses["All" + colourString + "Moved"] = true
			else:
				allBlocksMoved = false
	bonuses["AllColoursMoved"] = allColoursMoved
	bonuses["AllBlocksMoved"] = allBlocksMoved
	if distanceScore != 0:
		scoreText.visible = true
		var scoreString = "Distance Score: %s\n" % distanceScore
		for bonus in bonuses.keys():
			if bonuses[bonus]:
				scoreString = scoreString + "Bonus: %s%s\n" % [bonusStrings[bonus], bonusValues[bonus]]
				totalScore += bonusValues[bonus]
		scoreString = scoreString + "Total Score: %s" % totalScore
		scoreText.text = scoreString
