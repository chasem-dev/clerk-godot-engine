extends Control


const PROFILE_SCENE = preload("res://addons/clerk/scenes/components/Profile.tscn")
const SIGN_UP_SCENE = preload("res://addons/clerk/scenes/components/SignUp.tscn")

onready var clerk = Clerk.get_clerk()
var error

var sign_in_response

func _ready():
	if(clerk == null):
		printerr("ERROR: CLERK IS NOT INITIALIZED.")

func set_error(error_text: String):
	error = error_text
	$Error.text = error_text
	$Error.visible = true

func _on_SignIn_pressed():
	var email = $VBoxContainer/ColorRect/DefaultLogin/VBoxContainer/Email.text
	var password = $VBoxContainer/ColorRect/DefaultLogin/VBoxContainer/Password.text
	set_error("")
	$VBoxContainer/ColorRect/DefaultLogin.visible = false
	$LoadingSprite.visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	
	var sign_in_response = yield(clerk.sign_in(email, password), "completed")
	
	if sign_in_response.json != null && sign_in_response.json.has("errors") :
		var error = sign_in_response.json.errors[0]
		clerk.get_http().jwt = null
		if error.message == "Identifier is invalid.":
			set_error("Please provide a properly formatted Email Address.")
		else:
			set_error(str("Response Status: ", error.message))
		$LoadingSprite.visible = false
		$VBoxContainer/ColorRect/DefaultLogin.visible = true
	else:
		if sign_in_response.json.has("response") :
			var response = sign_in_response.json.response
			print(response)
			if response.status == "complete":
				get_tree().get_root().add_child(PROFILE_SCENE.instance())
				queue_free()
			else:
				clerk.get_http().jwt = null
				$LoadingSprite.visible = false
				$VBoxContainer/ColorRect/DefaultLogin.visible = true
				if response.status == "needs_identifier":
					set_error("Email not found, please sign up below!")
				elif response.status == "needs_first_factor":
					set_error("Email or Password incorrect.")
				else:
					set_error(str("Response Status: ", response.status))
		else:
			set_error(str("Status Code: ", sign_in_response.status_code))

func _on_SignUp_pressed():
	get_tree().get_root().add_child(SIGN_UP_SCENE.instance())
	queue_free()
