
import sys

file_name=sys.argv[1]
	
in_file = open(file_name)

cool_line = ""

i = 0
for line in in_file:

	if line.find("MLU")>=0:
		cool_line = line.rstrip()
		cool_line = cool_line[-13:]
		break
	
	i = i+1


nodes = file_name.strip("thin_core")
nodes = file_name.strip("thin_socket")
nodes = nodes.replace("_",",")

print (nodes[:-3] + "," + cool_line)
	
