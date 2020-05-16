extends Node

var scrn = null
var hero = null
var land = null

func at_hero_coord(offset=Vector3(0,0,0)):
	var output = hero.translation - offset.rotated(Vector3(0,1,0),hero.rotation.y)
	return output
