# Specify the file name
file_name = "hello_world.txt"

# Open the file in write mode and save "hello world"
with open(file_name, "w") as file:
    file.write("hello world")

print(f'"hello world" has been written to {file_name}')