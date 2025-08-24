extends RigidBody3D

@onready var die = $"CollisionShape3D/die"

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
var target_die_number = 1

# Mapping of die numbers (1-6) to orientation indices
var number_to_orientation = {
	1: 9,
	2: 1,
	3: 2,
	4: 0,
	5: 3,
	6: 16
}

func _ready() -> void:
	#GameController.roll_die.connect(_on_roll_die)
	GameController.start_die_animation.connect(_on_roll_die)
	print(get_top_face(die))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		roll_die()
		
func _on_roll_die(die_number:int):
	self.target_die_number = die_number
	print(die_number)
	roll_die()

func roll_die():
	# Pick random spin axis and speed
	spin_axis = Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized()
	spin_speed = 15.0  # radians per second
	roll_timer = 0.8                       # spin duration (seconds)
	rolling_phase = 1

func _process(delta):
	if rolling_phase == 1:
		# Phase 1: chaotic spin
		rotate(spin_axis, spin_speed * delta)
		roll_timer -= delta
		if roll_timer <= 0.0:
			# Use server-provided die number to determine final orientation
			var target_orientation_index = number_to_orientation[target_die_number]
			var target_rot = die_orientations[target_orientation_index]
			target_quat = Basis.from_euler(target_rot).get_rotation_quaternion()
			rolling_phase = 2

	elif rolling_phase == 2:
		var current_quat = global_transform.basis.get_rotation_quaternion()
		var new_quat = current_quat.slerp(target_quat, delta * 4.0)
		global_transform.basis = Basis(new_quat)

		# Check closeness with a tolerance
		if abs(current_quat.dot(target_quat)) > 0.9999:
			global_transform.basis = Basis(target_quat) # snap final
			rolling_phase = 3

	elif rolling_phase == 3:
		GameController.rolled.emit(target_die_number)
		rolling_phase = 0

func get_top_face(die: Node3D):
	var dir = Vector3.BACK
	var die_center := die.global_position
	var target_dir := dir.normalized()

	var best_face: Node3D = null
	var best_dot := -INF
	var children = die.get_children().filter(func(child): return child is DieFace)
	for child in children:
		if child is Node3D:
			var face := child as Node3D
			var normal := (face.global_position - die_center).normalized()
			var d := normal.dot(target_dir)
			if d > best_dot:
				best_dot = d
				best_face = face

	return best_face.amount
