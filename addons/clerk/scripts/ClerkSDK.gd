extends Node

# Update this to be your Clerk frontend API.
# https://g.pippy.io/deserted-servant-7111/clerk-example.png
const FRONT_END_API = "https://clerk.main.alien-31.lcl.dev"

# Once a user clicks on the Email link provided, it will automatically forward them to the following.
# This URL doesn't really matter, after they click the link, they're verified.
const LOGIN_REDIRECT_URL = "https://clerk.dev"

const HTTP_HANDLER = preload("res://addons/clerk/scripts/utils/HTTP.gd")
onready var http : HTTP_HANDLER
func get_http() -> HTTP_HANDLER:
	return http

func _ready():
	http = HTTP_HANDLER.new()
	http.name = "HTTPHandler"
	add_child(http)
	
func me():
	var me_url = str(front_end_api, "/v1/me?_is_native=1")
	var me = yield(http.request(me_url, []), "completed")
	return me

func sign_in(email : String, password: String):
	var headers = ["Authorization: 'Godot Game Engine'"]

	var body = {"password": password, "identifier": email, "strategy": "password"}
	var json_body = to_json(body)
	var sign_in_url = str(front_end_api, "/v1/client/sign_ins?_is_native=1")
	var sign_ins = yield(http.request(sign_in_url, headers, true, HTTPClient.METHOD_POST, json_body), "completed")
	return sign_ins

func sign_up(email : String, password: String):
	var headers = ["Authorization: 'Godot Game Engine'"]

	var body = {"password": password, "email_address": email}
	var json_body = to_json(body)
	var sign_up_url = str(front_end_api, "/v1/client/sign_ups?_is_native=1")
	var sign_ups = yield(http.request(sign_up_url, headers, true, HTTPClient.METHOD_POST, json_body), "completed")
	
	var sign_up_id = sign_ups.json.response.id
	var sign_up_verify = str(front_end_api, "/v1/client/sign_ups/",  sign_up_id, "/prepare_verification")
	var sign_up_prep_verify = yield(http.request(sign_up_verify, [], true, HTTPClient.METHOD_POST, to_json({"strategy": "email_link", "redirect_url": "https://chasem.dev"})), "completed")
	print(sign_up_prep_verify.json)

func sign_out():
	http.jwt = null
