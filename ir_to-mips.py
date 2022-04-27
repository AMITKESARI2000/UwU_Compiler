ir_file = open('./output.uwuir', 'r')
output_mips = open('./output.asm', 'w')

data_block = []
code_block = []

registers = {
    't0': 0,
    't1': 0,
    't2': 0,
    't3': 0,
    't4': 0,
    't5': 0,
    't6': 0,
    't7': 0,
    't8': 0,
    't9': 0,
    's0': 0,
    's1': 0,
    's2': 0,
    's3': 0,
    's4': 0,
    's5': 0,
    's6': 0,
    's7': 0,
    'zero': 0,
    'sp': 0,
    'ra': 0
}

for each in ir_file:
    if("_i" in each):
        each = each[each.find("_i"):]
        each = each.replace("_i", "")
        vals = each.strip().split("=")
        final_statement = []
        for i in vals:
            final_statement.append(i.strip())
        size_ele = 4
        types = ".word "

        if "[" in final_statement[0]:
            sub_size = final_statement[0][final_statement[0].find(
                "[") + 1:final_statement[0].find("]")]
            final_statement[0] = final_statement[0][0:final_statement[0].find(
                "[")]
            print(sub_size)
            final_statement.append((int(sub_size) * size_ele))
            types = ".space "
        elif '"' in final_statement[1]:
            types = ".asciiz "
        else:
            final_statement[1] = "0"

        final_statement[0] = "var_" + final_statement[0]
        data_block.append(
            final_statement[0] + ":    " + types + str(final_statement[1]))




output_mips.write(".data \n")

for d in data_block:
    print(d)
    output_mips.write(d+"\n")


output_mips.write(".text \n.globl main\nmain:")
