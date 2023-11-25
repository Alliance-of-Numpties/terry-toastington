extends Control

signal resume
signal quit

func _on_resume_pressed():
	resume.emit()


func _on_exit_to_menu_pressed():
	quit.emit()
