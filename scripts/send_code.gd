extends Button

#nice little variables here :>
@onready var email: LineEdit = $"../../EmailBG/LineEdit"

@onready var errorlabel: Label = $"../../Label"



#validate email when send code button is pressed
func _on_pressed() -> void:
	if email.text == "":
		errorlabel.text = ("Invalid email please try again")
	elif "@student.furness.ac.uk" in email.text:
		send_email()
		print("Email Sent")
	else:
		print("Data Is There So DW It Working")
	
	

#does the same if the text is submitted
func _on_line_edit_text_submitted(new_text: String) -> void:
	if email.text == "":
		errorlabel.text = ("Invalid email please try again")
	elif "@student.furness.ac.uk" in email.text:
		send_email()
		print("Email Sent")
	else:
		print("Data Is Ther So DW It Working")
	


#Bailey do ur thing with api here
func send_email():
	pass
