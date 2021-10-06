extends KinematicBody2D

export (int) var speed = 5
var velo = Vector2()
var dirx = 1
var diry = 1
var rng = RandomNumberGenerator.new()
var move = false
var colisao = false

var time_idle_max = 2
var time_idle_min = 1

var time_move_max = 15
var time_move_min = 5


func _physics_process(_delta):
	
	velo = velo.normalized() * speed
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		if collision.collider.name == "frog_kit" \
		or collision.collider.name == "StaticBody2D2" \
		or collision.collider.name == "StaticBody2D3" \
		and not $AnimatedSprite.get_animation() == "idle":
			colisao = true
			dirx *= -1
			$AnimatedSprite.scale.x = dirx
	
	print(diry)
	
	if move:
		$AnimatedSprite.play('move')
		velo.x += speed * dirx
		velo.y += speed * diry
		velo = move_and_slide(velo)
		
	else:
		$AnimatedSprite.play('idle')
	
	
	
func move_control():
	if rng.randi_range(0,100) < 60 and not colisao:
		dirx *= -1
		
		$AnimatedSprite.scale.x = dirx
		
	if rng.randi_range(0,100) < 10 and not colisao:
		 diry *= -1
		
		
func run_timer1(time):
	rng.randomize()
	var random = rng.randi_range(time_idle_min,time_idle_max)
	
	move_control()
	move =  true
	
	var timer1 = $Timer1
	timer1.set_wait_time(time)
	timer1.set_timer_process_mode(0)
	timer1.start()
	yield(timer1, "timeout")
	run_timer2(random)
	
	
func run_timer2(time):
	rng.randomize()
	var random = rng.randi_range(time_move_min,time_move_max)
	move = false
	
	print(random)
	var timer2 = $Timer2
	timer2.set_wait_time(time)
	timer2.set_timer_process_mode(0)
	timer2.start()
	yield(timer2, "timeout")
	run_timer1(random)


func _ready():
	run_timer2(5)
