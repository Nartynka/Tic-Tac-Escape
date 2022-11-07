extends KinematicBody

const SPEED = 2.0
onready var navAgent := $NavigationAgent
onready var growl := $Growl

func _physics_process(_delta):
	if navAgent.is_navigation_finished():
		print("finish")
		return
	var targetPos = navAgent.get_next_location()
	var direction = global_transform.origin.direction_to(targetPos)
	var velocity = direction * SPEED
	
	if targetPos != global_transform.origin:
		self.look_at(targetPos, Vector3.UP)
	
	move_and_slide(velocity)
	
func set_target(target):
	navAgent.set_target_location(target.global_transform.origin)

func _on_Hitbox_body_entered(body):
	if body is Player:
		growl.play()
		body.is_dying = true
