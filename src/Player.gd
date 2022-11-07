extends KinematicBody
class_name Player


const MAX_SPEED = 7
const ACCELERATION = 3.5
const DEACCELERATION = 16
const MOUSE_SENSITIVITY = 0.05

signal orb_collected

onready var camera = $CameraPivot/Camera
onready var rotation_helper = $CameraPivot
onready var collider = $Collider
onready var footsteps = $Footsteps
onready var breathing = $Breathing
onready var fader = $Fader

var velocity = Vector3()
var direction = Vector3()
var walking = false
var is_dying = false
var shake_amount = 0.01

func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fader.connect("fade_finished", self, "_on_fade_finished")

func _on_fade_finished():
	get_tree().change_scene("res://src/menus/GameOver.tscn")


func _physics_process(delta):
	if is_dying:
		shake_amount += 0.02 * delta
		camera.h_offset = rand_range(-1, 1) * shake_amount
		camera.v_offset = rand_range(-1, 1) * shake_amount
		fader.set_playback_speed(0.15)
		fader.fade_out()
	else:
		process_input()
		process_movement(delta)

func process_input():
	# Walking
	direction = Vector3()
	var camera_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("move_up"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("move_down"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_movement_vector.x += 1
	if Input.is_action_just_pressed("toggle_flashlight"):
		$CameraPivot/Flashlight.visible = !$CameraPivot/Flashlight.visible

	input_movement_vector = input_movement_vector.normalized()

	direction += -camera_xform.basis.z * input_movement_vector.y
	direction += camera_xform.basis.x * input_movement_vector.x

	if input_movement_vector.x != 0 or input_movement_vector.y != 0:
		walking = true
	else:
		walking = false

	if walking and !footsteps.playing:
		footsteps.play()
	elif !walking and footsteps.playing:
		footsteps.stop()
	
	# Capturing/Freeing the cursor on escape key
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func process_movement(delta):
	direction.y = 0
	direction = direction.normalized()

	var hvelocity = velocity
	hvelocity.y = 0

	var target = direction
	target *= MAX_SPEED

	var acceleration
	if direction.dot(hvelocity) > 0:
		acceleration = ACCELERATION
	else:
		acceleration = DEACCELERATION

	hvelocity = hvelocity.linear_interpolate(target, acceleration * delta)
	velocity.x = hvelocity.x
	velocity.z = hvelocity.z
	velocity = move_and_slide(velocity, Vector3(0, 1, 0), 0.05, 4)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot

func _on_Collider_area_entered(area):
	if area.is_in_group("Orb"):
		emit_signal("orb_collected")
		area.queue_free()
