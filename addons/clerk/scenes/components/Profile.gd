extends Control

onready var clerk = Clerk.get_clerk()
var avatar_loc

# Called when the node enters the scene tree for the first time.
func _ready():
	var me_response = yield(clerk.me(), "completed")
	var json = me_response.json	
	print("Hello")
	
	var email = json.response.email_addresses[0].email_address
	var first_name = json.response.first_name
	var last_name = json.response.last_name
	var profile_image_url = json.response.profile_image_url	
	yield(download_avatar(profile_image_url), "completed")
	
	$VBoxContainer/ColorRect/Main/ProfileInfo/Email/TextEdit.text = email
	$VBoxContainer/ColorRect/Main/ProfileInfo/FirstName/TextEdit.text = str(first_name)
	$VBoxContainer/ColorRect/Main/ProfileInfo/LastName/TextEdit.text = str(last_name)
	
	$VBoxContainer/ColorRect/Main/ProfileInfo.visible = true
	$VBoxContainer/ColorRect/LoadingSprite.visible = false
	
	

func download_avatar(url : String):
	var avatar_request = HTTPRequest.new()
	add_child(avatar_request)
	
	var ext = ".jpeg"
	
	if ".png" in url:
		ext = ".png"
	
	var file_dir = str(OS.get_user_data_dir(), "/", "avatar", ext)
	avatar_loc = str("/", "avatar", ext)
	print("file_dir: " + file_dir)
	
	avatar_request.set_download_file(file_dir)
	avatar_request.connect("request_completed", self, "_avatar_request_completed")
	avatar_request.request(url)
	yield(avatar_request, "request_completed")
	print_debug(url)

	
func _avatar_request_completed(result, response_code, headers, body):
	print("Request completed ", result, ", ", response_code)
	
	if result == 0 and response_code == 200:
		var file_dir = str(OS.get_user_data_dir(), avatar_loc)
		print("avatar_file_dir: " + file_dir)
		
		var tex = ImageTexture.new()
		var img = Image.new()		
		img.load(file_dir)
		img.resize(64, 64)
		tex.create_from_image(img)
		
		$VBoxContainer/ColorRect/Avatar.texture = tex.duplicate()
		$VBoxContainer/ColorRect/Avatar.visible = true


func _on_SignOut_pressed():
	clerk.get_http().jwt = null
	queue_free()
	get_tree().get_root().add_child(load("res://addons/clerk/scenes/components/Login.tscn").instance())
