extends CharacterBody2D

class_name Chicken

var idle = false
var walking = false

var xdir = 1 # 1 == right, -1 == left
var ydir = 1 # 1 == down, -1 == up
@export var speed = 35
@onready var level_parent = get_parent()
@export var pickup_type : PackedScene
var input = Vector2() #used to be movement
var moving_vertical_horizontal = 1 # 1==x 2 == y
var idk = false


func _ready():
	var vyber=[true,false]
	var choice = vyber[randi() % vyber.size()]
	walking=choice
	xdir = randi_range(1,2)
	ydir = randi_range(1,2)
	if walking==false:
		idle=true
	
	
func _physics_process(_delta):
	var waittime = 1
	if walking == false:
		var x = randi_range(1,2)
		if x > 1.5:
			moving_vertical_horizontal = 1
		else:
			moving_vertical_horizontal = 2	
		
	if walking == true:
		if idk==true:
			idk = false
		$AnimatedSprite2D.play("walking")
		if moving_vertical_horizontal == 1:
			if xdir == -1:
				$AnimatedSprite2D.flip_h = true
				velocity.x = -speed
				velocity.y = 0
			if xdir == 1:
				$AnimatedSprite2D.flip_h = false
				velocity.x = speed
				velocity.y = 0
			
			
		elif moving_vertical_horizontal == 2:
			if ydir == -1:
				velocity.y = -speed
				velocity.x = 0
			if ydir == 1:
				velocity.y = speed
				velocity.x = 0
		speed=35
	if idle == true:
		$AnimatedSprite2D.play("eating")
		velocity = Vector2.ZERO
		
	move_and_slide()				

func _on_change_state_timer_timeout():
	var waittime = 1
	if walking == true:
		idle = true
		walking = false
		waittime = randi_range(1,5)
	
	elif idle == true:
		walking = true
		idle = false
		var x=randi_range(1,60)
		if x==30:
			spawn_resource()
		waittime = randi_range(2,6)
	$ChangeStateTimer.wait_time = waittime
	$ChangeStateTimer.start()

func spawn_resource():
	var pickup_instance : Pickup = pickup_type.instantiate() as Pickup
	level_parent.add_child(pickup_instance)

	pickup_instance.global_position = global_transform.origin
	
	
func _on_walking_timer_timeout():
	var x = randi_range(1,2)
	var y = randi_range(1,2)
	var waittime = randi_range(1,4)
	if x > 1.5:
		xdir = 1 #right
	else:
		xdir = -1 #left
	if y > 1.5:
		ydir = 1
	else:
		ydir = -1
	$WalkingTimer.wait_time = waittime
	$WalkingTimer.start()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		idk = true 
		walking = true
		idle= false
		speed=100
		_physics_process(0)
		
