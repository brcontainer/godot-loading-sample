extends Control

const MAIN_SCENE := "res://scenes/test_room.tscn"

var progress: Array[float] = []
var loading: bool = true
var status: ResourceLoader.ThreadLoadStatus

@onready var tree: SceneTree = get_tree()
@onready var progressbar: ProgressBar = $VBoxContainer/ProgressBar

func _ready() -> void:
	ResourceLoader.load_threaded_request(MAIN_SCENE)

func _process(_delta: float) -> void:
	if loading:
		status = ResourceLoader.load_threaded_get_status(MAIN_SCENE, progress)

		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				progressbar.value = progress[0] * 100.0

			ResourceLoader.THREAD_LOAD_FAILED:
				loading = false

			ResourceLoader.THREAD_LOAD_LOADED:
				loading = false
				progressbar.value = 100.0
				tree.change_scene_to_packed(
					ResourceLoader.load_threaded_get(MAIN_SCENE)
				)
