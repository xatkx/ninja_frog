extends CharacterBody2D
class_name Player


@onready var ray_cast:RayCast2D = $RayCast2D as RayCast2D;
var largo = 11;
@onready var animation:AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D;
@export var SPEED:int = 300;
@export var JUMP:int = -400;
@export var GRAVITY:int = 100 * 9.8;
@export var max_jumps:int = 2;

@onready var coyote_timer:Timer = $coyoteTimer as Timer
var coyote_jump: bool = false;
var is_jump: bool = false;

var allow_animation:bool = false


var count_jump:int = 0;

var right_or_left:bool

var grap:bool = false;
func _ready():
	animation.play("appering");

func _physics_process(delta):
	if velocity.x != 0:
		right_or_left = bool(velocity.x < 0);
	if is_on_floor():
		coyote_jump = false
		is_jump = false;
		count_jump = 0;
#gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta;
		if not coyote_jump:
			coyote_jump = true
			coyote_timer.start()
#salto
	if Input.is_action_just_pressed("ui_accept") and derecho_a_saltar():
		count_jump +=1;
		is_jump = true;
		velocity.y = JUMP;	
#control de direcion
	var direction:int = Input.get_axis("ui_left","ui_right");
	velocity.x = direction * SPEED;
#control de animaciones
#control ray cast axis
	raycast_axis();
	wall_grap();
	ctrl_animation(velocity);
	move_and_slide();

func ctrl_animation(axis:Vector2) -> void:
	axis.normalized();
	if not allow_animation:
			return;
	if grap:
		animation.play("walljump");
	else:
		
		if axis.x == 0:
			animation.play("idle");
			pass
		elif axis.x != 0:
			animation.play("run");
			animation.flip_h = right_or_left;
			
		if axis.y > 0:
			animation.play("fall");
			pass
		elif axis.y < 0 and count_jump > 1:
			animation.play("doblejump");
			allow_animation = false;
			#print(axis) bugg aqui
		elif axis.y < 0:
			animation.play("jump");
func raycast_axis():
	if animation.flip_h:
		ray_cast.target_position.x = -largo;
	elif not animation.flip_h:
		ray_cast.target_position.x = largo;
func wall_grap():
	grap = false
	if ray_cast.get_collider():
	
		if ray_cast.get_collider().is_in_group("grap"):
			if velocity.y > 0:
				
				count_jump = 0;
				is_jump = false
				grap = true
				
				velocity.y = velocity.y / 8
func derecho_a_saltar() -> bool:
	if is_on_floor():
		return true;
	elif not coyote_timer.is_stopped() and not is_jump: # retorna verda mientras el timer coyote este coriendo y no haigas saltado ni una vez
		return true;
	elif count_jump < max_jumps and is_on_floor():
		return true;
	elif not is_on_floor() and count_jump < max_jumps:
		if not grap:
			count_jump +=2;
		return true;
	else:
		return false;

func _on_animated_sprite_2d_animation_finished():
	allow_animation = true;

func _on_timer_timeout():
	pass
	
