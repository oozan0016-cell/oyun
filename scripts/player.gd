extends CharacterBody3D

const HIZ = 5.0
const KOSMA_HIZI = 8.0
const ZIPLAMA = 4.5
const FARE_HASSASIYETI = 0.003

var yercekimi = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var kamera = $Kamera

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    _mobil_kontrollerini_olustur()
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
func _mobil_kontrollerini_olustur():
    var katman = CanvasLayer.new()
    add_child(katman)

    var arayuz = Control.new()
    arayuz.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    katman.add_child(arayuz)

    _mobil_buton(arayuz, "↑", "ui_up", 0.0, 130, -220)
    _mobil_buton(arayuz, "↓", "ui_down", 0.0, 130, -140)
    _mobil_buton(arayuz, "←", "ui_left", 0.0, 40, -140)
    _mobil_buton(arayuz, "→", "ui_right", 0.0, 220, -140)
    _mobil_buton(arayuz, "ZIPLA", "ui_accept", 1.0, -150, -150)


func _mobil_buton(parent, yazi, eylem, yatay, x, y):
	var buton = Button.new()
	buton.focus_mode = Control.FOCUS_NONE

	buton.text = yazi
	buton.custom_minimum_size = Vector2(80, 70)

	buton.anchor_left = yatay
	buton.anchor_right = yatay
	buton.anchor_top = 1.0
	buton.anchor_bottom = 1.0

	buton.offset_left = x
	buton.offset_right = x + 80
	buton.offset_top = y
	buton.offset_bottom = y + 70

	parent.add_child(buton)

	buton.button_down.connect(func():
		Input.action_press(eylem)
	)

	buton.button_up.connect(func():
		Input.action_release(eylem)
	)

	buton.mouse_exited.connect(func():
		Input.action_release(eylem)
	)
