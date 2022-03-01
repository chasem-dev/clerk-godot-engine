extends Node


const ClerkSDK = preload("res://addons/clerk/scripts/ClerkSDK.gd")
var instance : ClerkSDK = null

func get_clerk() -> ClerkSDK:
	if instance == null:
		instance = ClerkSDK.new()
		instance.name = "Clerk"
		get_tree().get_root().call_deferred("add_child", instance)
	
	return instance
