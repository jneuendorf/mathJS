import sys


argv = sys.argv
argc = len(argv)

if argc < 3:
    print("Usage: python3", argv[0], "<file_to_process> <macro_definitions_file> [<iterations>]")
    print("Macro definitions are paired strings, each pair in 2 lines. In between the pairs new lines are allowed.")
    print("Iterations are the number of replacements turns. So 2 iterations mean that macros can be nested once: M -> M1 -> M11.")
    sys.exit()

source_file = open(argv[1], "r")
source = source_file.read()
source_file.close()


macro_file = open(argv[2], "r")
macros = macro_file.read().split("\n")
macro_file.close()

macro_defs = []

i = 0
while i < len(macros):
    line = macros[i]
    # ignore # and // comments
    if len(line) > 0 and line[0] != "#" and line[0] != "/" and len(line) > 1 and line[1] != "/":
        macro_defs.append(line)
        i += 1
        macro_defs.append(macros[i])
    i += 1

# print(macro_defs)

if argc >= 4:
    iterations = argv[3]
else:
    iterations = 1

for i in range(0, iterations):
    for j in range(0, len(macro_defs) - 1, 2):
        source = source.replace(macro_defs[j], macro_defs[j + 1])

source_file = open(argv[1], "w")
source_file.write(source)
source_file.close()
