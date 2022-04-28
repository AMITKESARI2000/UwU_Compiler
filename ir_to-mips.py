import random
import re

ir_file = open('./output.uwuir', 'r')
output_mips = open('./output.asm', 'w')

code_parsed = []
data_block = []
code_block = []

# [is_free, var name, data]
registers = {
    't0': [True, None, 0],
    't1': [True, None, 0],
    't2': [True, None, 0],
    't3': [True, None, 0],
    't4': [True, None, 0],
    't5': [True, None, 0],
    't6': [True, None, 0],
    't7': [True, None, 0],
    't8': [True, None, 0],
    't9': [True, None, 0],
    's0': [True, None, 0],
    's1': [True, None, 0],
    's2': [True, None, 0],
    's3': [True, None, 0],
    's4': [True, None, 0],
    's5': [True, None, 0],
    's6': [True, None, 0],
    's7': [True, None, 0],
}
special_registers = {
    'zero': [False, 0],
    'sp': [True, None, 0],
    'ra': [True, None, 0]
}

variables = {}


# free some register for use
def free_reg():
    reg = random.sample(registers.keys(), 1)[0]

    value = registers[reg]

    code_block.append("sw $"+reg + " " + str(value[1]))

    value = [True, None, 0]
    return reg


def free_all_reg():
    for key in registers.keys():
        if registers[key][0] == False:
            if "temp_" not in registers[key][1]:
              code_block.append("sw $"+key+" , " + registers[key][1])
            registers[key] = [True, None, 0]


# get a free register for computation
def get_free_reg(var_name):

    for key in registers.keys():
        if registers[key][1] == var_name.strip():
            return key

    for key in registers.keys():
        if registers[key][0] == True:
            registers[key] = [False, var_name, 0]
            return key

    # if no reg is free, empty a register by storing its value through sw
    return free_reg()

def get_asciiz_var(expr_var):
    for dataline in data_block:
        if expr_var in dataline:
            return dataline.split(":",1)[0]              

def get_var_type(variable_name):
    if "var_" not in variable_name:
        variable_name = "var_" + variable_name
    for dataline in data_block:
        if variable_name in dataline:
            if "word" in dataline:
                return "word"
            elif "asciiz" in dataline:
                return "asciiz"
            elif "space" in dataline:
                return "space"


# parse the labels and the data section
for each in ir_file:
    if("_i" in each):
        new_line = each
        new_line = new_line[new_line.find("_i"):]
        new_line = new_line.replace("_i", "")
        vals = new_line.strip().split("=")
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

        variables[final_statement[0]] = [types, final_statement[1]]
        final_statement[0] = "var_" + final_statement[0]
        data_block.append(
            final_statement[0] + ":    " + types + str(final_statement[1]))

    if "Label_" in each:
        code_parsed.append(each[:each.find(":")+1].strip())
        code_parsed.append(each[each.find(":")+1:].strip())
    else:
        code_parsed.append(each.strip())

# parse the TAC to MIPS
for each in code_parsed:
    print(each)
    if "=" in each and "==" not in each:
        var = each.split("=")
        var[0] = var[0].replace("_i", "").strip()
        var[1] = var[1].strip()

        isArray = False
        arr_size = 0

        if "[" in var[0]:
            arr_size = var[0][var[0].find("[")+1:var[0].find("]")]
            var[0] = var[0][:var[0].find("[")].strip()
            isArray = True

        output_reg = ""
        expr_reg = []

        var[0] = var[0].strip()
        if var[0] in variables.keys() and not isArray:
            output_reg = get_free_reg("var_"+var[0])
            
            var_type = get_var_type(var[0])
            if var_type == "asciiz":
                code_block.append("la $"+output_reg+" , "+"var_"+var[0])
            else:
                code_block.append("lw $"+output_reg+" , "+"var_"+var[0])
        else:
            output_reg = get_free_reg("temp_"+var[0])

        
        expr_var = var[1].split('+',1)

        if len(expr_var) > 1:

            for exp in expr_var:
              if "*" in exp:
                # for t = t1 + t2*m type of statement (parsing t2*m)
                new_exp = exp.split("*")
                expr_reg1=[]
                for exp_ in new_exp:
                  if exp_ in variables.keys() and not isArray:
                      expr_reg__ = get_free_reg("var_"+exp_.strip())
                      code_block.append("lw $"+expr_reg__+" , "+"var_"+exp_)
                  elif not isArray:
                      expr_reg__ = get_free_reg("temp_"+exp_.strip())
                      
                      if "_" not in exp_:
                        code_block.append("li $"+expr_reg__+" , "+exp_)
                  expr_reg1.append(expr_reg__)
                
                code_block.append("mul $"+expr_reg__+" , $" +
                                  expr_reg1[0] + " , $" + expr_reg1[1])
                
                expr_reg.append(expr_reg__)
              else:
                # normal addition expression
                exp = exp.strip()
                if exp in variables.keys():
                    expr_reg_ = get_free_reg("var_"+exp.strip())
                    code_block.append("lw $"+expr_reg_+" , "+"var_"+exp)
                else:
                    expr_reg_ = get_free_reg("temp_"+exp.strip())
                    if "_" not in exp:
                        code_block.append("li $"+expr_reg_+" , "+exp)
                expr_reg.append(expr_reg_)
            
            var_type1 = get_var_type(registers[expr_reg[0]][1])
            var_type2 = get_var_type(registers[expr_reg[1]][1])
            if var_type1 == "asciiz" or var_type2 == "asciiz":
              #   convert data block type of var_c
              asciiz_var = registers[output_reg][1]
              for i in range(len(data_block)):
                if asciiz_var in data_block[i] and "word" in data_block[i]:
                  convert_to_str = re.split(r" +", data_block[i])[-1].strip()
                  
                  data_block[i] = data_block[i].split(".word")[0]
                  data_block[i] += ".asciiz \"" + convert_to_str + "\""
              #  use concat string
              code_block.append("la $a0 , " + registers[expr_reg[0]][1])
              code_block.append("la $a1 , " + registers[expr_reg[1]][1])
              code_block.append("la $a2 , " + registers[output_reg][1])
              strcat = """
concat:
    lb $t0, 0($a0)          
    beq $t0, $0, string2    
    sb $t0, 0($a2)          
    addi $a0, $a0, 1        
    addi $a2, $a2, 1        
    j concat     

string2:
    lb $t0, 0($a1)          
    beq $t0, $0, done       
    sb $t0, 0($a2)          
    addi $a1, $a1, 1        
    addi $a2, $a2, 1        
    j string2    

done:
    sb $0, 0($a2)

                """
              code_block.append(strcat)
              

            
            else:
              code_block.append("add $"+output_reg+" , $" +
                              expr_reg[0] + " , $" + expr_reg[1])
        else:
          exp = expr_var[0]
          if "*" in exp:
            # normal multiplication expression
              new_exp = exp.split("*")
              expr_reg1 = []
              for exp_ in new_exp:
                  if exp_ in variables.keys() and not isArray:
                      expr_reg__ = get_free_reg("var_"+exp_.strip())
                      code_block.append("lw $"+expr_reg__+" , "+"var_"+exp_)
                  elif not isArray:
                      expr_reg__ = get_free_reg("temp_"+exp_.strip())
                      if "_" not in exp_:
                        code_block.append("li $"+expr_reg__+" , "+exp_)
                  expr_reg1.append(expr_reg__)
              
              code_block.append("mul $"+expr_reg1[0]+" , $" +
                                  expr_reg1[0] + " , $" + expr_reg1[1])

              expr_reg.append(expr_reg__)
          else:
            # normal assignment operation
            if expr_var[0] in variables.keys() and not isArray:
              expr_reg_ = get_free_reg("var_"+expr_var[0].strip())
              code_block.append("lw $"+expr_reg_+" , "+"var_"+expr_var[0])
              expr_reg.append(expr_reg_)
              code_block.append("add $"+output_reg+" , $" +
                              expr_reg[0] + " , $zero")
            elif not isArray:
              if '"' in expr_var[0]:
                #   if its a string don't do li
                print()
                # expr_reg_ = get_free_reg("temp_"+expr_var[0].strip())
                # asciiz_var = get_asciiz_var(expr_var[0])
                # code_block.append("la $"+expr_reg_+" , "+asciiz_var)
                # expr_reg.append(expr_reg_)
                
              else:
                expr_reg_ = get_free_reg("temp_"+expr_var[0].strip())
                code_block.append("li $"+expr_reg_+" , "+expr_var[0])
                expr_reg.append(expr_reg_)
                code_block.append("add $"+output_reg+" , $" +
                              expr_reg[0] + " , $zero")

        if isArray:
          arr_size = get_free_reg("temp_"+arr_size.strip())
          code_block.append("sw $"+output_reg+" , "+var[0] + "($"+arr_size+")")
        
        
        if not ("t_1" in var[0] or "t_0" in var[0]):
          free_all_reg()
    elif "Label_" in each:
        code_block.append(each)




# generate and write into the .asm file
output_mips.write(".data \n")
for d in data_block:
    print(d)
    output_mips.write(d+"\n")

output_mips.write(".text \n.globl main\nmain:\nj Label_main\n")
for d in code_block:
    print(d)
    output_mips.write(d+"\n")


# close fd
ir_file.close()
output_mips.close()
