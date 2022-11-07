extends Spatial

onready var fader = $CanvasLayer/Fader

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fader.fade_in()

func _on_MainMenuBtn_pressed():
	get_tree().change_scene("res://src/menus/MainMenu.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()
