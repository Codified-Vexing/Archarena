extends Node

var Got  # The Terrain managing script
var isoval = 0
var terr_v = {}  # set vertex, get index
var st

var offset := Vector3.ZERO  # Defines the position of the chunk in the world
var surface: MeshInstance

func _init(manager, pos_offset=offset):
	Got = manager
	offset = pos_offset * Got.lim
	
func _ready():
	st = SurfaceTool.new()
	surface = MeshInstance.new()
	surface.mesh = Mesh.new()
	surface.name = "chunk_" + str(offset.x) + "x_" +str(offset.y) + "y_" + str(offset.z) + "z"
	Got.add_child(surface)
	re_mesh()

func voxel_world_pos(voxel_chunk_pos):
	return (voxel_chunk_pos + offset) * Got.granul

func re_mesh():
	var msh = Mesh.new()
	
	terr_v.clear()
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for x in Got.lim.x:
		for y in Got.lim.y:
			for z in Got.lim.z:

				var cell_index := 0
				var cell = [
							Got.landscaper.at(voxel_world_pos(Vector3(x,y,z)), Vector3(x,y,z)),
							Got.landscaper.at(voxel_world_pos(Vector3(x+1,y,z)), Vector3(x+1,y,z)),
							Got.landscaper.at(voxel_world_pos(Vector3(x+1,y,z+1)), Vector3(x+1,y,z+1)),
							Got.landscaper.at(voxel_world_pos(Vector3(x,y,z+1)), Vector3(x,y,z+1)),
							Got.landscaper.at(voxel_world_pos(Vector3(x,y+1,z)), Vector3(x,y+1,z)),
							Got.landscaper.at(voxel_world_pos(Vector3(x+1,y+1,z)), Vector3(x+1,y+1,z)),
							Got.landscaper.at(voxel_world_pos(Vector3(x+1,y+1,z+1)), Vector3(x+1,y+1,z+1)),
							Got.landscaper.at(voxel_world_pos(Vector3(x,y+1,z+1)), Vector3(x,y+1,z+1)),
							]
	
				var cnt: int = 0
				for sample in cell:
					if sample < isoval: 
						cell_index |= int(pow(2, cnt))
					cnt += 1
				
				for base_i in Got.tristable[cell_index]:
					if base_i >= 0:
						var v = Got.edgyment[base_i] * Got.granul + voxel_world_pos(Vector3(x,y,z))
						if not terr_v.has(v):
							terr_v[v] = terr_v.size()
							st.add_vertex(v)
						st.add_index(terr_v[v])

	st.generate_normals()
	#st.generate_tangents()
	st.commit(msh)

	surface.mesh = msh
	surface.create_trimesh_collision()
	surface.set_surface_material(0, Got.texture)
