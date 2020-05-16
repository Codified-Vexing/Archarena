extends State_Machine.Basic_State

var fly_t = 0.0
var max_fly_t = 0.2
var min_fly_t = 0.2
var trans_acc = 5

func exit():
	fly_t = 0.0

func proceed(dt):
	fly_t += dt
	if fly_t >= max_fly_t:
		behavior.stack = "walk"
	me.vel += 100 * Vector3.UP * dt
	
	me.vel += trans_acc * me.dir * dt
	
	me.vel = me.move_and_slide(me.vel, Vector3.UP, true, 4, me.max_slope, false)
		
func react(ev):
	if ev.is_action_released("jump") and fly_t >= min_fly_t:
		behavior.stack = "walk"
