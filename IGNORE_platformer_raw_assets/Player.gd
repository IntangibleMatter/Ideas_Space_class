extends KinematicBody2D

var acceleration = 512
var max_speed = 128
var friction = 0.25
var air_resistance = 0.1
var gravity = 200
var jump_force = 150

var motion := Vector2.ZERO

onready var sprite := $Sprite
onready var anim_player := $AnimationPlayer

func _physics_process(delta) -> void:
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if x_input != 0:
		motion.x += x_input * acceleration * delta
		motion.x = clamp(motion.x, -max_speed, max_speed)
		sprite.flip_h = x_input < 0
	
	motion.y += gravity * delta

	if is_on_floor():
		if x_input != 0:
			anim_player.play("walk")
		else:
			anim_player.play("idle")

		if x_input == 0:
			motion.x = lerp(motion.x, 0, friction)

		if Input.is_action_just_pressed("ui_up"):
			motion.y = -jump_force
	else:
		if motion.y < 0:
			anim_player.play("jump")
		else:
			anim_player.play("fall")
		
		if Input.is_action_just_released("ui_up") and motion.y < -jump_force / 2:
			motion.y = -jump_force/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, air_resistance)
	
	motion = move_and_slide(motion, Vector2.UP)
