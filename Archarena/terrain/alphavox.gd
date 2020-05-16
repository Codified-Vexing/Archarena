extends Node

var Got  # The Terrain managing script

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
	return (voxel_chunk_pos + offset) * Got.grid

func re_mesh():
	var msh = Mesh.new()

	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for x in Got.lim.x:
		for y in Got.lim.y:
			for z in Got.lim.z:

				var this = Got.landscaper.at(voxel_world_pos(Vector3(x,y,z)), Vector3(x,y,z))
				
				var atta = {
					"top": Got.landscaper.at(voxel_world_pos(Vector3(x,y+1,z)), Vector3(x,y+1,z)),
					"bottom": Got.landscaper.at(voxel_world_pos(Vector3(x,y-1,z)), Vector3(x,y-1,z)),
					"east": Got.landscaper.at(voxel_world_pos(Vector3(x-1,y,z)), Vector3(x-1,y,z)),
					"west": Got.landscaper.at(voxel_world_pos(Vector3(x+1,y,z)), Vector3(x+1,y,z)),
					"north": Got.landscaper.at(voxel_world_pos(Vector3(x,y,z+1)), Vector3(x,y,z+1)),
					"south": Got.landscaper.at(voxel_world_pos(Vector3(x,y,z-1)), Vector3(x,y,z-1)), 
				}
				
				if this == null:
					pass
				else:
					for f in atta:
						if atta[f] == null:
							for base_i in this.curr_form().faces[f]:
								var v = this.curr_form().vertices[base_i] + voxel_world_pos(Vector3(x,y,z))
								if not terr_v.has(v):
									terr_v[v] = terr_v.size()
									st.add_vertex(v)
								st.add_index(terr_v[v])
								
	st.generate_normals()
	#st.generate_tangents()
	st.commit(msh)

	surface.mesh = msh
	surface.create_trimesh_collision()
