# https://stackoverflow.com/questions/17140886/how-to-search-and-replace-text-in-a-file
import sys

# Read in the file
path = str(sys.argv[1])
f = open(path, 'r')
data = f.readlines()
f.close()

# Write the file out again
f = open(path, 'w')

lineNo = str(sys.argv[2])
# Replace the target string
for line in data:
    if line.find('<tr>  <td class="numLineCover">&nbsp;' + lineNo + '<') != -1:
        line = line.replace('</pre>', '<span style="color:orange;">      <--Mutated</span></pre>')
    f.write(line)

f.close()
