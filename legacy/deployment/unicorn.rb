##############################################
# Platan.us Sample Unicorn Configuration File
##############################################

home_dir = "/home/web/"
app_name = "platanus-nest"
app_path = File.join(home_dir, app_name)

working_directory app_path
pid app_path + "/tmp/pids/unicorn.pid"
stderr_path app_path + "/unicorn/err.log"
stdout_path app_path + "/unicorn/out.log"

listen "/tmp/unicorn." + app_name + ".socket"

worker_processes 2
timeout 60
