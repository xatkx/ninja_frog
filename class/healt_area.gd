extends Area2D
class_name Healt
signal receive_damage;
signal receive_heal;
signal is_death;

@export var init_life:int = 10;
var current_life:int;
var old_life:int;

func _ready():
	setup();
	
func setup() -> void:
	current_life = init_life;

func trader(value:int) -> int:
	death_detect();
	if current_life != old_life:
		pass
	return value

func take_damage(value:int) -> void:
	old_life = current_life
	current_life += -trader(value);
	current_life = clamp(current_life,0,init_life)
	receive_damage.emit()
	
func take_heal(value:int) -> void:
	current_life = trader(-value);
	receive_heal.emit()

func death_detect() -> void:
	if current_life <= 0:
		is_death.emit();
