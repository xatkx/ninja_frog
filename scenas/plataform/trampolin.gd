extends RigidBody2D

@export var inpulso:int


func _on_event_action_body_entered(body):
	$animation.play("action");
	if body is Player:
		body.velocity.y -= inpulso;
