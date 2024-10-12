with open("/etc/frr/daemons", "r") as f:
  content = f.read()

content = content.replace("=no", "=yes")

with open("/etc/frr/daemons", "w") as f:
  f.write(content)
