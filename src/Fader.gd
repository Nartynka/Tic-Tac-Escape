extends ColorRect

onready var animationPlayer = $AnimationPlayer

signal fade_finished

func fade_in():
	animationPlayer.play("fade_in")

func fade_out():
	animationPlayer.play("fade_out")

func set_playback_speed(speed):
	animationPlayer.playback_speed = speed

func _on_animation_finished(_name):
	emit_signal("fade_finished")
