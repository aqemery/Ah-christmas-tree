extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var title_text: Sprite2D = $"Title-text"
@onready var label: Label = $Label
@onready var label_2: Label = $Label2



func _ready() -> void:
    title_text.visible = true
    label.visible = true
    label_2.visible = false
    
    

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("fire") and animation_player.current_animation != "intro":
        animation_player.play("intro")
        
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
    
        

func start():
    var root = preload("res://root.tscn")
    get_tree().change_scene_to_packed(root)
