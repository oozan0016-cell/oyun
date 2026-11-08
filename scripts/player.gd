extends CharacterBody3D

const HIZ = 5.0
const KOSMA_HIZI = 8.0
const ZIPLAMA = 4.5
const FARE_HASSASIYETI = 0.003

var yercekimi = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var kamera = $Kamera

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * FARE_HASSASIYETI)
		kamera.rotate_x(-event.relative.y * FARE_HASSASIYETI)
		kamera.rotation.x = clamp(kamera.rotation.x, -1.4, 1.4)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= yercekimi * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = ZIPLAMA

	var hiz = KOSMA_HIZI if Input.is_key_pressed(KEY_SHIFT) else HIZ
	var girdi = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var yon = (transform.basis * Vector3(girdi.x, 0, girdi.y)).normalized()

	if yon:
		velocity.x = yon.x * hiz
		velocity.z = yon.z * hiz
	else:
		velocity.x = move_toward(velocity.x, 0, hiz)
		velocity.z = move_toward(velocity.z, 0, hiz)

	move_and_slide()
