extends CharacterBody2D
var rotate = 0
const SPEED = 300.0
@onready var depth = $CanvasLayer/Ydepth 
@onready var longitude =  $CanvasLayer/X
@onready var dontmove =  $CanvasLayer/dontmove
@onready var timesinceattack = $CanvasLayer/timesinceattack
var timerForNextAttack = false
var timeTillNextAttack=0
var timeSinceAttack = 0
var buffer = 1
var dontmovetime= 3
var time=0
var death = false
var playHorror = false
var playMusic = false

func _ready():
	print()
	
func _physics_process(delta: float) -> void:
	Input.action_release("restart")
	timeSinceAttack+= delta
	time+= delta
	
	
	##DONT MOVE
	
	if timerForNextAttack ==false:
		timeTillNextAttack = randi_range(7, 11)
		timerForNextAttack = true
	
	if timeSinceAttack >= timeTillNextAttack:
		dontmove.visible = true
		timeSinceAttack = 0
		
	if dontmove.visible ==false:
		if playMusic ==false:
			playHorror=false
			$music.stream_paused = false
			playMusic =true
			
	if dontmove.visible ==true:
		if playHorror == false:
			$attack.play()
			playHorror = true
			$music.stream_paused = true
			playMusic = false
		if timeSinceAttack<=3:
			if (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and timeSinceAttack>buffer:
				dontmove.visible = false
				death = true
				timerForNextAttack = false
		else:
			dontmove.visible = false
			timerForNextAttack = false
			
	
	
	
	if death ==true:
		death=false
		$Ahh.play("die")
		await $Ahh.animation_finished
		get_tree().change_scene_to_file("res://main.tscn")
	
	print(velocity.x)
	print(velocity.y)
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	depth.text = "Depth under sealevel: " + str(snapped((global_position.y/20)+1000, 1))
	longitude.text = "Longitude: " + str(snapped(global_position.x/20, 1))
	timesinceattack.text = "Time since last attack: " + str(int(timeSinceAttack))
	
	if Input.is_action_pressed("turn_left"):
		if $Ahh.flip_h == false:
			rotate =-.1
		elif $Ahh.flip_h == true:
			rotate=.1
	elif Input.is_action_pressed("turn_right"):
		if $Ahh.flip_h == true:
			rotate =-.1
		elif $Ahh.flip_h == false:
			rotate=.1
	
	if velocity.x<0:
		$Ahh.flip_h = true
	elif velocity.x>0:
		$Ahh.flip_h = false
		
	$Ahh.rotation_degrees = clamp($Ahh.rotation_degrees, -80, 80)
	
	if Input.is_action_pressed("turn_left") or Input.is_action_pressed("turn_right"):
		$Ahh.rotate(rotate)
	if Input.is_action_pressed("left"):
		velocity = -Vector2(1, 0).rotated($Ahh.rotation_degrees*PI/180) * 300
		
		move_and_slide()
	if Input.is_action_pressed("right"):
		velocity = Vector2(1, 0).rotated($Ahh.rotation_degrees*PI/180) * 300
		move_and_slide()
		
	if Input.is_action_just_pressed("book"):
		if $CanvasLayer/BookKraken.visible ==true:
			$CanvasLayer/BookKraken.visible =false
		elif $CanvasLayer/BookKraken.visible ==false:
			$CanvasLayer/BookKraken.visible =true
