extends Spatial

onready var fader = $CanvasLayer/Fader

onready var menu = $CanvasLayer/Fader/Menu
onready var tut1 = $CanvasLayer/Fader/Tutorial1
onready var tut2 = $CanvasLayer/Fader/Tutorial2

func _ready():
	fader.fade_in()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_StartBtn_pressed():
	fader.fade_out()
	fader.fade_in()
	menu.visible = false
	tut1.visible = true
	yield(get_tree().create_timer(7), "timeout")
	fader.fade_out()
	yield(get_tree().create_timer(1), "timeout")
	fader.fade_in()
	tut1.visible = false
	tut2.visible = true
	yield(get_tree().create_timer(10), "timeout")
	fader.fade_out()
	fader.connect("fade_finished", self, "_on_fade_finished")
	$AnimationPlayer.play("music_fade")

func _on_fade_finished():
	get_tree().change_scene("res://src/Level.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()
