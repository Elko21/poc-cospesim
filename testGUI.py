import tkinter as tk

class EventGenerator:
    def __init__(self, event_receiver):
        self.event_receiver = event_receiver

    def generate_event(self, event_type):
        self.event_receiver.receive_event(event_type)

class EventReceiver:
    def __init__(self, root):
        self.root = root

        self.label1 = tk.Label(self.root, text="Indicator 1: OFF")
        self.label2 = tk.Label(self.root, text="Indicator 2: OFF")

        self.label1.pack()
        self.label2.pack()

    def receive_event(self, event_type):
        if event_type == 1:
            self.label1.config(text="Indicator 1: ON")
        elif event_type == 2:
            self.label2.config(text="Indicator 2: ON")

def button1_click(generator):
    generator.generate_event(1)

def button2_click(generator):
    generator.generate_event(2)

def main():
    root = tk.Tk()
    root.title("GUI")

    receiver = EventReceiver(root)
    generator = EventGenerator(receiver)

    button1 = tk.Button(root, text="Button 1", command=lambda: button1_click(generator))
    button2 = tk.Button(root, text="Button 2", command=lambda: button2_click(generator))

    button1.pack()
    button2.pack()

    root.mainloop()

if __name__ == "__main__":
    main()
