import tkinter as tk
import subprocess
from tkinter import ttk

prolog_process = subprocess.Popen(["swipl", "-s", "baza.pl", "--quiet"], 
                                    stdin=subprocess.PIPE, 
                                    stdout=subprocess.PIPE, 
                                    stderr=subprocess.PIPE, 
                                    text=True)

global list_of_answers
list_of_answers = ["start troubleshooting"]

def on_submit():
    text = entry2.get() 
    text = str.lower(text)
    text = str.strip(text)
    
    entry2.delete(0,tk.END)
    if text in list_of_answers:  
        list_of_answers.clear()
        text = "_".join(text.split())
        prolog_process.stdin.write(text + ".\n")
        prolog_process.stdin.flush()
        stdout_line = prolog_process.stdout.readline().strip()
        print("Prolog Output:", stdout_line) 
        
        lines = stdout_line.split("|")
        entry1.delete(1.0, tk.END)
        answers_start = False
        for line in lines: 
            if answers_start:
                list_of_answers.append(line)
            entry1.insert(tk.END,line + "\n")                 
            if line == "Available answers:":
                answers_start = True
    else:
        entry1.delete(1.0,tk.END)
        entry1.insert(tk.END,"please provide one of the following answers:\n")
        for answer in list_of_answers:
            entry1.insert(tk.END,answer + "\n")
    
    entry2.focus() 

root = tk.Tk()
root.title("Windows help expert system")
root.geometry("750x480")

def on_enter_press (event):
    on_submit()
root.bind('<Return>', on_enter_press)

def on_esc_press (event):
    root.quit()
root.bind('<Escape>', on_esc_press)

entry1 = tk.Text(root,width=90,bg='#333333', fg='white', insertbackground='white')
entry1.grid(row=0, column=1, padx=10, pady=5)

entry2 = tk.Entry(root, width=50, bg='#333333', fg='white', insertbackground='white')
entry2.grid(row=1, column=1, padx=10, pady=5)

submit_button = tk.Button(root, text="Submit",command=on_submit)
submit_button.grid(row=2, column=0, columnspan=2, pady=10)

root.tk_setPalette(background='#1e1e1e', foreground='#ffffff')
style = ttk.Style()
style.configure('TButton', background='#4CAF50', foreground='white', padding=(10, 5), font=('Helvetica', 10, 'bold'))  
style.configure('TLabel', background='#1e1e1e', foreground='#ffffff')  

entry1.insert(1.0,"Click on the submit button to start using the system\n\nYou can press Enter instead of clicking submit\n\nPress Escape to exit the program\n\nAlways provide an answer from the list of available answers\n\nQueries are not case sensitive")
entry2.insert(0,"start troubleshooting") 
entry2.focus()
root.mainloop()       