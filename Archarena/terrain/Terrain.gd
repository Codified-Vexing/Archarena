tool
extends StaticBody

export(Script) var voxeler # = "res://terrain/alphavox.gd"  # Renders a chunk
export(Script) var landscaper # = "res://terrain/landscapers/alphascape.gd"  # figures out what entities exist on a given part of the terrain.
export(bool) var render_in_editor = false
export(int) var i_seed = 0xdeadbeef

export(OpenSimplexNoise) var noise
export(Material) var texture

# Chunk dimensions:
var lim = Vector3(16,40,16)  # It's preferable that numbers are divisible by 2
# Chunk grid size; Defines the distance between blocks:
var granul = 0.4

var chunk = []  # Loaded Chunks
var edgyment = []  # The edge vertex coordinates for cube marching
var tristable = []  # the vertex order for cube marching tris

func _ready():
	
	G.land = self
	
	var path = "res://entities/forms/sauer.dat"
	var file = File.new()
	file.open(path, File.READ)
	var line = file.get_line()
	while line != "":
		if line.begins_with("vertices"):
			for each in line.lstrip("vertices").split(":"):
				var e = each.split_floats(",")
				e = Vector3( e[0],e[1],e[2] )
				edgyment.append(e)
		if line.begins_with("indexes"):
			for each in line.lstrip("indexes").split(":"):
				var e = each.split_floats(",")
				tristable.append(e)
				
		line = file.get_line()
	file.close()

	if not Engine.editor_hint or render_in_editor:
		
		# Explanation of how this works...
		# This script is the terrain/chunk managment. It holds data relevant to
		# all chunks.
		# The landscaper is a script which gives meaning to each voxel. Given
		# a coordinate, it returns information about that voxel.
		# The voxeler is where the Marching Cubes algorithm is implemented.
		# It will ask the landscaper about each voxel and generate a mesh
		# based on that.
		# For each chunk there's a voxeler, but you only need one landscaper
		# because there's a continuum of data between all chunks.
		
		landscaper = landscaper.new(self)
		landscaper._ready()
		
		var co = populate()

func populate():
	for x in 3:
		for z in 3:
			var c = voxeler.new(self, Vector3(x,0,z))
			c._ready()
			chunk.append(c)
			yield(get_tree(), "idle_frame")

#func _on_Timer_timeout():
#	pass
#
#func place(where):
#	var x = where.x
#	var y = where.y
#	var z = where.z
#	if mapping[x][y][z] == null:
#		mapping[x][y][z] = matterload.new(matter["dirt"])
#		make_mesh()
#
#func broke(where):
#	var x = where.x
#	var y = where.y
#	var z = where.z
#	if mapping[x][y][z] != null:
#		mapping[x][y][z] = null
#		make_mesh()
#
#func drop(who, from):
#	print("ouch")
