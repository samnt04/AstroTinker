s = {
    0 :  [1],
    1 :  [29, 2, 0],
    2 :  [1, 3, 8],
    3 :  [2 , 4, 28],
    4 :  [3, 5 ,6],
    5 :  [4],
    6 :  [4 , 7],
    7 :  [6, 8],
    8 :  [2, 12, 9, 7],
    9 :  [8, 10, 11],
    10 : [9],
    11 : [9],
    12 : [8, 13, 19],
    13 : [12, 14],
    14 : [15, 13, 16],
    15 : [14],
    16 : [14, 17, 18],
    17 : [16],
    18 : [16, 19],
    19 : [18, 12, 20],
    20 : [21, 29, 19, 24],
    21 : [20, 22, 23],
    22 : [21],
    23 : [21],
    24 : [20, 25],
    25 : [24, 26],
    26 : [27, 25, 28],
    27 : [26],
    28 : [26, 29, 3],
    29 : [1, 28, 20]
}
s = [s[i] + [31] * (4 - len(s[i])) for i in range(len(s))]
print(s)
g = [(i[3] << 24 | i[2] << 16 | i[1] << 8 | i[0]) for i in s]
# g = []
# for i in s: g += i[::-1]
print(g)
# The following part is for generating output strings for file writing
s_graph = "/*INIT_GRAPH*/\n\t"
for i, val in enumerate(g):
    s_graph += f"p_graph[{i}] = {hex(val)}; "

# Assuming "/*INIT_GRAPH*/" is a placeholder in your source file
with open("t1b_path_planner_32bit.c", "r") as f:
    strout = f.read()

with open("t1b_path_planner_32bit.c", "w") as f:
    # Replace the placeholder with the generated strings
    f.write(strout.replace("/*INIT_GRAPH*/", s_graph))