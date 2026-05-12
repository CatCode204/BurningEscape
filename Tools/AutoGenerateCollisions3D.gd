@tool
extends EditorScript

const HOLDER_NAME := "AutoCollisions"
const MIN_OBJECT_SIZE := 0.2

func _run():
	var root := get_scene()
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

	for m in meshes:
		if m.mesh == null:
			continue

		var aabb := m.get_aabb()
		var size := aabb.size

		if max(size.x, size.y, size.z) < MIN_OBJECT_SIZE:
			continue

		var body := StaticBody3D.new()
		body.name = "BOX_" + m.name
		body.global_transform = m.global_transform
		holder.add_child(body)
		body.owner = root

		var shape := BoxShape3D.new()
		shape.size = size

		var col := CollisionShape3D.new()
		col.shape = shape
		col.position = aabb.position + aabb.size * 0.5
		body.add_child(col)
		col.owner = root

		count += 1

	print("Generated box collision bodies: ", count)
	print("Nhớ Ctrl+S để lưu scene.")


func _collect_meshes(node: Node, result: Array[MeshInstance3D]) -> void:
	if node.name == HOLDER_NAME:
		return

	if node is MeshInstance3D:
		result.append(node)

	for child in node.get_children():
		_collect_meshes(child, result)
