"""A Simple To-Do List"""

walker TodoManager {
    has action: str;
    has task: str;

    can start with `root entry;
    can manage_task with task_node entry;
}

node task_node {
    has task_name: str;
    has completed: bool = False;
}

# Will run when in CLI mode
with entry:__main__ {
    root spawn TodoManager("add", "Buy groceries");
    root spawn TodoManager("add", "Walk the dog");
    root spawn TodoManager("complete", "Buy groceries");
    root spawn TodoManager("list", "");
}

impl TodoManager.start {
    if self.action == "add" {
        root ++> task_node(self.task);
        print(f"Added task: {self.task}");
    } elif self.action == "list" {
        tasks = [root --> (`?task_node)];
        if tasks {
            print("Your tasks:");
            for task in tasks {
                status = "✓" if task.completed else "○";
                print(f"{status} {task.task_name}");
            }
        } else {
            print("No tasks found.");
        }
    } elif self.action == "complete" {
        for task in [root --> (`?task_node)] {
            if task.task_name == self.task {
                task.completed = True;
                print(f"Completed: {self.task}");
                break;
            }
        }
    }
}

impl TodoManager.manage_task {
    # Task management logic handled in start
}