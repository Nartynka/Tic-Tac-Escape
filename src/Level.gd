extends Spatial

onready var monster = $Monster
onready var player = $Player
onready var orbs = $Orbs
onready var fader = $CanvasLayer/Fader
onready var orbLabel = $CanvasLayer/Fader/OrbLabel
var orbs_collected = 0
var total_orbs = 0

func _ready():
	fader.fade_in()
	total_orbs = orbs.get_child_count()
	orbLabel.text = "Orbs: 0/"+String(total_orbs)
	player.connect("orb_collected", self, "_on_orb_collected")
	fader.connect("fade_finished", self, "_on_fade_finished")

func _physics_process(_delta):
	monster.set_target(player)

func _on_orb_collected():
	orbs_collected += 1
	orbLabel.text = "Orbs: "+String(orbs_collected)+"/"+String(total_orbs)
	if orbs_collected >= total_orbs:
		fader.fade_out()

func _on_fade_finished():
	if orbs_collected >= total_orbs:
		get_tree().change_scene("res://src/menus/Win.tscn")

#func _input(_event):
#	if Input.is_action_just_pressed("fullscreen"):
#		OS.window_fullscreen = !OS.window_fullscreen
	
