extends RigidBody3D

var die_orientations = [
	# Face +Z up
	Vector3(0, 0, 0),
	Vector3(0, PI/2, 0),
	Vector3(0, PI, 0),
	Vector3(0, -PI/2, 0),

	# Face -Z up
	Vector3(PI, 0, 0),
	Vector3(PI, PI/2, 0),
	Vector3(PI, PI, 0),
	Vector3(PI, -PI/2, 0),

	# Face +X up
	Vector3(0, 0, -PI/2),
	Vector3(0, PI/2, -PI/2),
	Vector3(0, PI, -PI/2),
	Vector3(0, -PI/2, -PI/2),

	# Face -X up
	Vector3(0, 0, PI/2),
	Vector3(0, PI/2, PI/2),
	Vector3(0, PI, PI/2),
	Vector3(0, -PI/2, PI/2),

	# Face +Y up
	Vector3(PI/2, 0, 0),
	Vector3(PI/2, PI/2, 0),
	Vector3(PI/2, PI, 0),
	Vector3(PI/2, -PI/2, 0),

	# Face -Y up
	Vector3(-PI/2, 0, 0),
	Vector3(-PI/2, PI/2, 0),
	Vector3(-PI/2, PI, 0),
	Vector3(-PI/2, -PI/2, 0),
]

var target_quat: Quaternion
var spin_axis: Vector3
var spin_speed: float
var roll_timer: float
var rolling_phase := 0

func _ready() -> void:
	GameController.roll_die.connect(_on_roll_die)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		roll_die()
		
func _on_roll_die():
	roll_die()

func roll_die():
	# Pick random spin axis and speed
	spin_axis = Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized()
	spin_speed = randf_range(15.0, 25.0)  # radians per second
	roll_timer = 0.8                       # spin duration (seconds)
	rolling_phase = 1

func _process(delta):
	if rolling_phase == 1:
		# Phase 1: chaotic spin
		rotate(spin_axis, spin_speed * delta)
		roll_timer -= delta
		if roll_timer <= 0.0:
			# Pick final face orientation
			var target_rot = die_orientations[randi() % die_orientations.size()]
			target_quat = Basis.from_euler(target_rot).get_rotation_quaternion()
			rolling_phase = 2

	elif rolling_phase == 2:
		# Phase 2: smooth settle
		var current_quat = global_transform.basis.get_rotation_quaternion()
		var new_quat = current_quat.slerp(target_quat, delta * 4.0)
		global_transform.basis = Basis(new_quat)
		if new_quat.is_equal_approx(target_quat):
			rolling_phase = 0
