@tool
extends EditorScript

const HOLDER_NAME := "AutoCollisions"
const BODY_NAME := "COL_Merged_Trimesh"
const MIN_OBJECT_SIZE := 0.05

func _run() -> void:
	var root: Node3D = get_scene() as Node3D
	if root == null:
		push_error("Bạn phải mở scene level trước.")
		return

	var old: Node = root.get_node_or_null(HOLDER_NAME)
	if old:
		old.free()

	var holder := Node3D.new()
	holder.name = HOLDER_NAME
	root.add_child(holder)
	holder.owner = root

	var meshes: Array[MeshInstance3D] = []
	_collect_meshes(root, meshes)

	var faces := PackedVector3Array()
	var root_inv: Transform3D = root.global_transform.affine_inverse()

	for m: MeshInstance3D in meshes:
		if m.mesh == null:
			continue

		var aabb: AABB = m.get_aabb()
		if max(aabb.size.x, aabb.size.y, aabb.size.z) < MIN_OBJECT_SIZE:
			continue

		var local_faces: PackedVector3Array = m.mesh.get_faces()
		var to_root: Transform3D = root_inv * m.global_transform

		for v: Vector3 in local_faces:
			faces.append(to_root * v)

	if faces.is_empty():
		push_error("Không tìm thấy mesh face nào để tạo collision.")
		return

	var body := StaticBody3D.new()
	body.name = BODY_NAME
	holder.add_child(body)
	body.owner = root

	var shape := ConcavePolygonShape3D.new()
	shape.set_faces(faces)

	var col := CollisionShape3D.new()
	col.name = "CollisionShape3D"
	col.shape = shape
	body.add_child(col)
	col.owner = root

	print("Generated merged trimesh collision.")
	print("Mesh count: ", meshes.size())
	print("Face vertices: ", faces.size())
	print("Triangles: ", faces.size() / 3)
	print("Nhớ Ctrl+S để lưu scene.")


func _collect_meshes(node: Node, result: Array[MeshInstance3D]) -> void:
	if node.name == HOLDER_NAME:
		return

	if node is MeshInstance3D:
		result.append(node as MeshInstance3D)

	for child: Node in node.get_children():
		_collect_meshes(child, result)
