extends Node

const HASAR = 25
const MESAFE = 3.0
const BEKLEME = 0.6

var hazir = true

@onready var oyuncu = get_parent()
@onready var kamera = get_parent().get_node("Kamera")

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		saldir()

func saldir():
	if not hazir:
		return
	hazir = false

	var uzay = oyuncu.get_world_3d().direct_space_state
	var baslangic = kamera.global_position
	var bitis = baslangic + (-kamera.global_transform.basis.z * MESAFE)

	var sorgu = PhysicsRayQueryParameters3D.create(baslangic, bitis)
	sorgu.exclude = [oyuncu.get_rid()]
	var sonuc = uzay.intersect_ray(sorgu)

	if sonuc and sonuc.collider.has_method("hasar_al"):
		sonuc.collider.hasar_al(HASAR)

	await get_tree().create_timer(BEKLEME).timeout
	hazir = true
