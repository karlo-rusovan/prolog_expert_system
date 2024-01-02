# prolog_expert_system

Prolog expert system for troubleshooting issues with I/O devices and Internet connection for Windows operating system.
Graphical interface is made with python GUI tkinter. Libraries needed are tkinter and subprocess.
Subprocess is used for communication with Prolog, where Prolog is called as a subprocess and communication is flowing
through stdin/stdout streams. 
The system is made with expandability in mind. Expansion with new solution for known issues should be made by 
declaring a solution with solution name and set of conditions that have to be met. If those conditions are met,
the system will recommend the defined solution. The only other thing that needs to be done is make a 
troubleshoot_solution(solution_name) predicate where you define what's the output of the solution and where 
you call the search for next solution. 

The current flowchart for troubleshooting is provided with the code in form of .drawio file which you can open
using platform diagrams.net

how to run: <br>
the system uses subprocess and tkinter Python libraries that should be installed with Python<br>
download swi-prolog from the following link: https://www.swi-prolog.org/download/stable and add swipl to path<br>
run with: python main.py<br>
