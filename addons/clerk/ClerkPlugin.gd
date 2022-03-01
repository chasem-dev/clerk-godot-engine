tool
extends EditorPlugin

func _ready():
	print("Clerk Plugin loading...")

func _enter_tree():
	print("Clerk Plugin Entered Tree...")
	add_autoload_singleton("Clerk", "res://addons/clerk/scripts/ClerkLoader.gd")
	print("ClerkSDK Loaded.")

func _exit_tree():
	pass
