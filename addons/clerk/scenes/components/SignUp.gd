extends Control

onready var clerk = Clerk.get_clerk()

func _on_SignUpButton_pressed():
	var first_name = $VBoxContainer/ColorRect/ProfileInfo/FirstName/LineEdit.text
	var last_name = $VBoxContainer/ColorRect/ProfileInfo/LastName/LineEdit.text
	var email = $VBoxContainer/ColorRect/ProfileInfo/Email/LineEdit.text
	var password = $VBoxContainer/ColorRect/ProfileInfo/Password/LineEdit.text
	
	var http = clerk.get_http()
	
	var headers = ["Authorization: 'Godot Game Engine'"]

	var body = {"password": password, "email_address": email,
	 "first_name": first_name, "last_name": last_name}
	var json_body = to_json(body)
	var sign_up_url = str(clerk.FRONT_END_API, "/v1/client/sign_ups?_is_native=1")
	var sign_ups = yield(http.request(sign_up_url, headers, true, HTTPClient.METHOD_POST, json_body), "completed")
	if sign_ups.status_code == 200:
		var sign_up_id = sign_ups.json.response.id
		var sign_up_verify = str(clerk.FRONT_END_API, "/v1/client/sign_ups/",  sign_up_id, "/prepare_verification")
		var sign_up_prep_verify = yield(http.request(sign_up_verify, [], true, HTTPClient.METHOD_POST, to_json({"strategy": "email_link", "redirect_url": clerk.LOGIN_REDIRECT_URL})), "completed")
		
		if sign_up_prep_verify.status_code == 200:	
			$VBoxContainer/ColorRect/ProfileInfo.visible = false
			$SignedUpNext.visible = true
			$VBoxContainer/ColorRect/CancelButton.visible = false
		else:
			printerr(sign_up_prep_verify)
	else:
		printerr("Failed to create new sign up with info...")
		printerr(sign_ups.json.errors)

func _on_Back_pressed():
	get_tree().get_root().add_child(load("res://addons/clerk/scenes/components/Login.tscn").instance())
	queue_free()


func _on_CancelButton_pressed():
	get_tree().get_root().add_child(load("res://addons/clerk/scenes/components/Login.tscn").instance())
	queue_free()

