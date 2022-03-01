extends Node

var jwt

func create_http() -> HTTPRequest:
	var http_node : HTTPRequest = HTTPRequest.new()
	add_child(http_node)
	return http_node

func request(endpoint: String, params: PoolStringArray, use_ssl = true, method = HTTPClient.METHOD_GET, data : String = ""):
	var http : HTTPRequest = create_http()
	print_debug(endpoint, " STARTED")
	
	if jwt != null:
		params.append(jwt)
	
	if(http.request(endpoint, params, use_ssl, method, data) == OK):
		#	result, response_code, headers, body
		var response = yield(http, "request_completed")			
		var result = response[0]
		var status_code = response[1]
		var headers : PoolStringArray = response[2]
		var content = response[3].get_string_from_utf8()
#		print_debug(content, " content")
		var json = parse_json(content)
		
		if self.jwt == null:			
			for header in headers:
#				print_debug(header)
				if "authorization" in header:
					self.jwt = header
					print_debug("Set Auth Header....")
					break
	
		print_debug(endpoint, " Finished")
		var return_obj = {"result": result, "status_code": status_code, "headers": headers, "json": json}
		http.queue_free()
		return return_obj
	else:
		printerr("Failed to create GET request for URL: ", endpoint, " params: ", params, " ssl: ", use_ssl)
		http.queue_free()
		return {}
