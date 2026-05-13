@tool
extends EditorScript

const HOLDER_NAME := "AutoCollisions"
const MIN_OBJECT_SIZE := 0.1

func _run() -> void:
	var root: Node3D = get_scene() as Node3D
	if root == null:
		push_error("Bạn phải mở scene level trước.")
		return

	var old := root.get_node_or_null(HOLDER_NAME)
	if old:
		old.free()

	var holder := Node3D.new()
	holder.name = HOLDER_NAME
	root.add_child(holder)
	holder.owner = root

	var meshes: Array[MeshInstance3D] = []
	_collect_meshes(root, meshes)

	var count := 0

	for m: MeshInstance3D in meshes:
		if m.mesh == null:
			continue

		var aabb: AABB = m.get_aabb()
		if max(aabb.size.x, aabb.size.y, aabb.size.z) < MIN_OBJECT_SIZE:
			continue

		var shape := m.mesh.create_trimesh_shape()
		if shape == null:
			continue

		var body := StaticBody3D.new()
		body.name = "COL_" + m.name
		body.global_transform = m.global_transform
		holder.add_child(body)
		body.owner = root

		var col := CollisionShape3D.new()
		col.name = "CollisionShape3D"
		col.shape = shape
		body.add_child(col)
		col.owner = root

		count += 1

	print("Generated vertex/trimesh collision bodies: ", count)
	print("Nhớ Ctrl + S để lưu scene.")


func _collect_meshes(node: Node, result: Array[MeshInstance3D]) -> void:
	if node.name == HOLDER_NAME:
		return

	if node is MeshInstance3D:
		result.append(node as MeshInstance3D)

	for child: Node in node.get_children():
		_collect_meshes(child, result)
