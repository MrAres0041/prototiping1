class_name Player
extends CharacterBody3D

var pitch :float = 0.0 
var speed:float = 5.0
var jumps:int = 0
var dash_timer:float = 0.0
var dash_cd_timer:float = 0.0
var dash_dir:Vector3 = Vector3.ZERO
var is_dashing:bool = false
var direction: Vector3
var forward:Vector3
var right:Vector3
var target_pos: Vector3 = Vector3(0,0,0)
var target_normal: Vector3 = Vector3(0,0,0)
var voxel_pos: Vector3 = Vector3(0,0,0)
var mouse_can_move:bool = false

const JUMP_VELOCITY:float = 10.0
const GRAVITY:float = 20.0
const MOUSE_SENSITIVITY:float = 0.002
const MAX_LOOK_ANGLE = deg_to_rad(89)
const MAX_JUMPS:int = 2

const DASH_CD:float = 1.5
const DASH_SPEED:float = 40.0
const DASH_TIME:float = 0.15


@onready var timer: Timer = $Timer
@onready var head: Node3D = $Head
@onready var target_ray: RayCast3D = $Head/Camera3D/TargetRay
@onready var voxel_lod_terrain:VoxelTerrain = get_parent()
@onready var voxel_tool: VoxelTool = voxel_lod_terrain.get_voxel_tool()
@onready var inventory: Inventory = $Head/Camera3D/Inventory


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion and !mouse_can_move:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		pitch = clamp(pitch - event.relative.y * MOUSE_SENSITIVITY, -MAX_LOOK_ANGLE, MAX_LOOK_ANGLE)
		head.rotation.x = pitch

func _physics_process(delta):
	direction = Vector3.ZERO
	forward = -global_transform.basis.z
	right = global_transform.basis.x


	if Input.is_action_pressed("W"):
		direction += forward
	if Input.is_action_pressed("S"):
		direction -= forward
	if Input.is_action_pressed("A"):
		direction -= right
	if Input.is_action_pressed("D"):
		direction += right

	if Input.is_action_just_pressed("Run"):
		speed = speed*2
	if Input.is_action_just_released("Run"):
		speed = speed/2

	direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	inventory._inventory_vis()

	_PlaceDestroyBlock(target_pos)
	_Jump(delta)
	_Dash(delta)

	move_and_slide()

func _Dash(delta):
	if dash_cd_timer > 0:
		dash_cd_timer -= delta
		
	if is_dashing:
		dash_timer -= delta
		velocity = dash_dir * DASH_SPEED
		velocity.y -= GRAVITY * delta
		if dash_timer <= 0:
			is_dashing = false
			dash_cd_timer = DASH_CD
	
	elif Input.is_action_just_pressed("Dash") and dash_cd_timer <= 0:
		if direction != Vector3.ZERO:
			dash_dir = direction
		else:
			dash_dir = forward
		is_dashing = true
		dash_timer = DASH_TIME

func _Jump(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		jumps = 0
		
	if Input.is_action_just_pressed("Jump") and jumps < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jumps += 1

func world_to_voxel(world_pos: Vector3) -> Vector3i:
	# El tamaño de un voxel en unidades del mundo (normalmente 1)
	var voxel_size = 1.0
	# Origen del terreno
	var origin = voxel_lod_terrain.global_transform.origin
	# Convertir
	var local = (world_pos - origin) / voxel_size
	return Vector3i(floor(local.x), floor(local.y), floor(local.z))

func _PlaceDestroyBlock(target_pos):
	if !target_ray.is_colliding():
		return
	
	target_pos = target_ray.get_collision_point()
	target_normal = target_ray.get_collision_normal()
	
	# Posición del voxel al que apuntás:
	voxel_pos = world_to_voxel(target_pos)
	
	if Input.is_action_just_pressed("R_Click") and !mouse_can_move:
		#var new_voxel_pos = voxel_pos + Vector3(target_normal) * 0 # ROTO
		var new_voxel_pos = world_to_voxel(target_pos + target_normal * 0.5) #FIXED Matematicas, no preguntes
		voxel_tool.mode = VoxelTool.MODE_ADD
		voxel_tool.set_voxel(new_voxel_pos,2)
	
	if Input.is_action_just_pressed("L_Click") and !mouse_can_move:
		var new_voxel_pos = world_to_voxel(target_pos - target_normal * 0.5) #FIXED Matematicas, no preguntes
		voxel_tool.mode = VoxelTool.MODE_REMOVE
		voxel_tool.set_voxel(new_voxel_pos,0)
