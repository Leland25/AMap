extends Control

#nice little variables here :>
@onready var email: LineEdit = $EmailBG/LineEdit
@onready var error_label: Label = $Label
@onready var otp_submit_bg: TextureRect = $OTPSubmitBG
@onready var email_submit_bg: TextureRect = $EmailSubmitBG
@onready var otp_bg: TextureRect = $OTPBG
@onready var email_bg: TextureRect = $EmailBG
@onready var line_submit_otp: LineEdit = $OTPBG/LineSubmitOTP
@onready var submit_otp: Button = $OTPSubmitBG/SubmitOTP

var http_request: HTTPRequest
var verify_request: HTTPRequest


func _on_send_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response.errorCode)
	if response.errorCode == "INVALID_DOMAIN":
		error_label.text = "Invalid email address,\n use your college email."
		error_label.add_theme_color_override("font_color", Color.ORANGE_RED)
		return
	if response.success:
		error_label.text = "Email sent!\nPlease enter your OTP below"
		error_label.add_theme_color_override("font_color", Color.LIME_GREEN)
		email_bg.visible = false
		email_submit_bg.visible = false
		otp_bg.visible = true
		otp_submit_bg.visible = true
	else:
		error_label.text = "Email failed to send!\nPlease try again."
		error_label.add_theme_color_override("font_color", Color.ORANGE_RED)

func _on_verify_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response)
	if response.success:
		error_label.text = "Email Verified!"
		error_label.add_theme_color_override("font_color", Color.LIME_GREEN)
		submit_otp.disabled = true
	else:
		error_label.text = "Invaild OTP, try again!\nYou have %s attempts remaining." % int(response.attemptsRemaining)
		error_label.add_theme_color_override("font_color", Color.ORANGE_RED)

func _ready():
	http_request = HTTPRequest.new()
	verify_request = HTTPRequest.new()
	add_child(http_request)
	add_child(verify_request)
	
	http_request.request_completed.connect(_on_send_response)
	verify_request.request_completed.connect(_on_verify_response)

func send_otp(email: String):
	var url = "http://localhost:3000/send-otp"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"email": email})
	http_request.request(url, headers, HTTPClient.METHOD_POST, body)

func verify_otp(email: String, otp: String):
	var url = "http://localhost:3000/verify-otp" 
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"email": email, "otp": otp})
	verify_request.request(url, headers, HTTPClient.METHOD_POST, body)


#validate email when send code button is pressed
func _on_send_code_pressed() -> void:
	send_otp(email.text)
	return;
	if email.text.strip_edges(true, true) == "":
		error_label.text = ("Invalid email please try again")
	elif email.text.ends_with("@student.furness.ac.uk"):
		send_otp(email.text)
	else:
		print("Data Is There So DW It Working")

#does the same if the text is submitted
func _on_line_edit_text_submitted(new_text: String) -> void:
	send_otp(email.text)
	return
	if email.text.strip_edges(true, true) == "":
		error_label.text = ("Invalid email please try again")
	elif email.text.ends_with("@student.furness.ac.uk"):
		send_otp(email.text)
	else:
		print("Data Is Ther So DW It Working")

func _on_submit_otp_pressed() -> void:
	verify_otp(email.text, line_submit_otp.text)

func _on_line_submit_otp_text_submitted(new_text: String) -> void:
	verify_otp(email.text, new_text)
