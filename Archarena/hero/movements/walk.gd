extends State_Machine.Basic_State

var max_speed = [8, 16]
var trans_acc = 20
var friction_acc = 8

func proceed(dt):
	if me.vel.length() <= max_speed[int(Input.is_action_pressed("sprint"))]:
		me.vel += trans_acc * me.dir * dt
	me.vel -= friction_acc * me.vel.normalized() * Vector3(1,0,1) * dt
	
	if !me.is_on_floor():
		me.vel += me.grav * me.grav_dir * dt
		
	me.vel = me.move_and_slide(me.vel, Vector3.UP, true, 4, me.max_slope, true)
	
func react(ev):
	if ev.is_action_pressed("jump") and me.is_on_floor():
		behavior.stack = "jump"
