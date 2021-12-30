import csv


files = ["node_normal.out", "node_ib0.out", "node_br0.out", "node_mlx5_0.out", "node_tcp.out", "core_normal.out", "core_tcp.out", "core_vader.out", "socket_normal.out", "socket_tcp.out", "socket_vader.out"]
data = []
for filee in files:
    with open(filee, 'r') as in_file:

        
        stripped = (line.strip() for line in in_file)
        spaced = (line.replace(" ",",") for line in stripped)

        lines = (line.split(",") for line in spaced if line)

        for i in lines:
            data.append(i)

        

        #print(data)
    
data = (' '.join(d).split() for d in data)
    
    
with open('test.csv', 'w') as out_file:
    writer = csv.writer(out_file)
    writer.writerows(data)