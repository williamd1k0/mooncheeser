extends Node

signal request_complete(data, code)
signal request_error(response, error)

# Status codes
signal status_200(data)
signal status_400(data)
signal status_401(data)

enum {
	RESPONSE_UTF8_STR
	RESPONSE_ASCII_STR,
	RESPONSE_JSON_DICT,
}

enum {
	METHOD_GET,
	METHOD_HEAD,
	METHOD_POST,
	METHOD_PUT, 
	METHOD_DELETE,
	METHOD_OPTIONS
}

enum {
	STATUS_OK = 200,
	STATUS_BAD_REQUEST = 400,
	STATUS_UNAUTHORIZED = 401
}

const CONFIG_PATH = 'res://.server.cfg'
const HEADERS = [
    "User-Agent: Godot/2.1.3",
    "Accept: */*"
]

var TOKEN = ''
var HOST_PORT = ''
var ping_check = true
var PING_ROUTE = ''
var DEFAULT_METHOD = 0
var RESPONSE_TYPE = 0
var configs = ConfigFile.new()

var client = HTTPClient.new()
var http = HTTPRequest.new()
var timer = Timer.new()

func _ready():
	configs.load(CONFIG_PATH)
	if not configs.has_section('configs'):
		init_config_file()
	update_server_configs()
	HEADERS.append('Client-Token: '+TOKEN)
	add_child(http)
	add_child(timer)
	http.connect("request_completed", self, '_on_request_completed')
	timer.connect("timeout", self, '_on_connection_timeout')
	if ping_check:
		check_connection()

func init_config_file():
	configs.set_value('configs', 'host_port', 'http://127.0.0.1:80')
	configs.set_value('configs', 'ping_route', '/')
	configs.set_value('configs', 'client_token', 'your-client-secret')
	configs.set_value('configs', 'default_method', 0)
	configs.set_value('configs', 'response_type', 0)
	configs.save(CONFIG_PATH)

func update_server_configs():
	HOST_PORT = configs.get_value('configs', 'host_port')
	TOKEN = configs.get_value('configs', 'client_token')
	PING_ROUTE = configs.get_value('configs', 'ping_route')
	DEFAULT_METHOD = configs.get_value('configs', 'default_method')
	RESPONSE_TYPE = configs.get_value('configs', 'response_type')

func check_connection():
	print('CHECKING CONNECTION')
	request(PING_ROUTE)

func request(route, data={}, method=-1, timeout=5):
	if method == -1:
		method = DEFAULT_METHOD
	http.cancel_request()
	if method == HTTPClient.METHOD_GET:
		var query_data = client.query_string_from_dict(data)
		http.request(parse_route(route)+'?'+query_data, HEADERS, true, method)
	else:
		http.request(parse_route(route), HEADERS, true, method, data.to_json())
	timer.set_wait_time(timeout)
	timer.start()

func request_get(route, data={}, timeout=5):
	request(route, data, METHOD_GET, timeout)

func request_post(route, data={}, timeout=5):
	request(route, data, METHOD_POST, timeout)

func parse_route(route):
	if route[0] != '/':
		route = '/' + route
	return HOST_PORT+route

func _on_connection_timeout():
	print('CONNECTION PROBLEM')
	http.cancel_request()

func _on_request_completed(result, response_code, headers, body):
	print("REQUEST COMPLETED")
	prints("RESULT:", result)
	timer.stop()
	print(response_code)
	print(headers)
	if result == HTTPRequest.RESULT_CANT_CONNECT:
		emit_signal('request_error', body, response_code)
		return
	if response_code >= 400 or result != HTTPRequest.RESULT_SUCCESS: 
		emit_signal('request_error', body, response_code)
	print(body.get_string_from_utf8())
	
	var response
	if RESPONSE_TYPE == RESPONSE_UTF8_STR:
		response = body.get_string_from_utf8()
	elif RESPONSE_TYPE == RESPONSE_ASCII_STR:
		response = body.get_string_from_ascii()
	elif RESPONSE_TYPE == RESPONSE_JSON_DICT:
		response = Dictionary()
		response.parse_json(body.get_string_from_utf8())
	print(response)
	emit_signal('request_complete', response, response_code)
	
	if response_code == STATUS_OK:
		emit_signal("status_200", response)
	elif response_code == STATUS_BAD_REQUEST:
		emit_signal("status_400", response)
	elif response_code == STATUS_UNAUTHORIZED:
		emit_signal("status_401", response)
