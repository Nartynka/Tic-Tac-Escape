extends SpotLight

onready var timer = $Timer

func _ready():
	randomize()
	timer.wait_time = rand_range(0.05, 0.1)

func _on_Timer_timeout():
	timer.wait_time = rand_range(0.05, 0.1)
	light_energy = rand_range(0, 1)

