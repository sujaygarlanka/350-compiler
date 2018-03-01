from numpy import binary_repr

file1 = open('instructions.txt', 'r')
instructions = file1.readlines()
instructions = [x.strip() for x in instructions] 
file1.close()


outputFile = open('pc1.mif','w')
newLine = lambda: outputFile.write('\n')
outputFile.write('WIDTH=32;')
newLine()
outputFile.write('DEPTH=4096;')
newLine()
outputFile.write('ADDRESS_RADIX=UNS;')
newLine()
outputFile.write('DATA_RADIX=BIN;')
newLine()
outputFile.write('CONTENT BEGIN')
newLine()

counter = 0;
opcode = {'add':'00000','addi':'00101','sub':'00000','and':'00000','or':'00000','sll':'00000','sra':'00000','mul':'00000','div':'00000','sw':'00111','lw':'01000','j':'00001','bne':'00010','jal':'00011','jr':'00100','blt':'00110','bex':'10110','setx':'10101'}
for instrLine in instructions:
    instr = instrLine.split(' ')
    instr = [x.strip(',') for x in instr] 
    line = str(counter) + ' : '
    if instr[0] == 'add':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3][2:]),5))
        line += str(binary_repr(0,5))
        line += '00000'
        line += str(binary_repr(0,2))
        
        
    elif instr[0] == 'addi':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3]),17))
        
        
    elif instr[0] == 'sub':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3][2:]),5))
        line += str(binary_repr(0,5))
        line += '00001'
        line += str(binary_repr(0,2))
        
        
    elif instr[0] == 'and':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3][2:]),5))
        line += str(binary_repr(0,5))
        line += '00010'
        line += str(binary_repr(0,2))
        
        
    elif instr[0] == 'or':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3][2:]),5))
        line += str(binary_repr(0,5))
        line += '00011'
        line += str(binary_repr(0,2))
        
        
    elif instr[0] == 'sll':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(0,5))
        line += str(binary_repr(int(instr[3]),5))
        line += '00100'
        line += str(binary_repr(0,2))
        
    
    elif instr[0] == 'sra':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(0,5))
        line += str(binary_repr(int(instr[3]),5))
        line += '00101'
        line += str(binary_repr(0,2))
        
        
    elif instr[0] == 'mul':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3][2:]),5))
        line += str(binary_repr(0,5))
        line += '00110'
        line += str(binary_repr(0,2))
       
        
    elif instr[0] == 'div':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3][2:]),5))
        line += str(binary_repr(0,5))
        line += '00111'
        line += str(binary_repr(0,2))
        
        
    elif instr[0] == 'sw' or instr[0] == 'lw':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][4]),5))
        line += str(binary_repr(int(instr[2][0]),17))
        
    elif instr[0] =='j':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1]),27))
        
    elif instr[0] == 'bne':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3]),17))
        
    elif instr[0] =='jal':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1]),27))
        
    elif instr[0] =='jr':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(0,22))
        
    elif instr[0] == 'blt':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1][2:]),5))
        line += str(binary_repr(int(instr[2][2:]),5))
        line += str(binary_repr(int(instr[3]),17))
        
    elif instr[0] =='bex':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1]),27))
        
    elif instr[0] =='setx':
        line += opcode[instr[0]]
        line += str(binary_repr(int(instr[1]),27))
        
    line += ';'    
    outputFile.write(line)
    newLine()
    counter += 1
        
if counter <= 4096:
    line = '[' + str(counter) + '..' + '4095]' + ':' + str(binary_repr(0,32)) + ';'
    outputFile.write(line)
    newLine()

outputFile.write('END;')





