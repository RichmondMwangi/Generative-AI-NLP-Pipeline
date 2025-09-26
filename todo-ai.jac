"""An AI-Enhanced To-Do List"""

import from byllm.llm { Model }

glob llm = Model(model_name="gemini/gemini-2.0-flash", api_key="AIzaSyBM_TTDQ4f66PMe9RtI-JLVRlCzUJzNMtQ", verbose=False);

"""Generate a motivational message for completing a task"""
def get_motivation(task: str) -> str by llm();

"""Suggest priority level for a task"""
def suggest_priority(task: str) -> str by llm();

walker TodoManager {
    has action: str;
    has task: str;

    can start with `root entry;
    can manage_task with task_node entry;
}

node task_node {
    has task_name: str;
    has completed: bool = False;
    has priority: str = "medium";
}

# Will run when in CLI mode
with entry:__main__ {
    root spawn TodoManager("add", "Buy groceries");
    root spawn TodoManager("add", "Exercise for 30 minutes");
    root spawn TodoManager("complete", "Buy groceries");
    root spawn TodoManager("list", "");
}

impl TodoManager.start {
    if self.action == "add" {
        priority = suggest_priority(self.task);
        new_task = root ++> task_node(self.task, False, priority);
        print(f"Added task: {self.task} (Priority: {priority})");
    } elif self.action == "list" {
        tasks = [root --> (`?task_node)];
        if tasks {
            print("Your tasks:");
            for task in tasks {
                status = "✓" if task.completed else "○";
                print(f"{status} {task.task_name} [Priority: {task.priority}]");
            }
        } else {
            print("No tasks found.");
        }
    } elif self.action == "complete" {
        for task in [root --> (`?task_node)] {
            if task.task_name == self.task {
                task.completed = True;
                motivation = get_motivation(self.task);
                print(f"Completed: {self.task}");
                print(f"🎉 {motivation}");
                break;
            }
        }
    }
}

impl TodoManager.manage_task {
    # Task management logic handled in start
}