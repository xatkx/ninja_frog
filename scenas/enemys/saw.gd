extends CharacterBody2D

@onready var ray_to_wall = $raytoWall as RayCast2D;
@onready var ray_to_floor = $raytoFloor as RayCast2D;

var ray_wall_target_position_x = 40
var ray_floor_location_position_x = 40;
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var switch:int = 1;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.x = SPEED;
	ray_to_floor.position.x = ray_floor_location_position_x;
	ray_to_wall.target_position.x = ray_wall_target_position_x
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if wall_and_floor_detect():
		velocity.x *= -1;
		ray_to_floor.position.x *= -1;
		ray_to_wall.target_position.x *= -1;
		
	move_and_slide()


func wall_and_floor_detect() -> bool:
	if not ray_to_floor.get_collider() || ray_to_wall.get_collider():
		return true;
	return false;
