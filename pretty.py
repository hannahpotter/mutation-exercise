# https://stackoverflow.com/questions/17140886/how-to-search-and-replace-text-in-a-file
import sys

# Read in the file
path = str(sys.argv[1])
f = open(path, 'r')
filedata = f.read()
f.close()

lineNo = str(sys.argv[2])
# Replace the target string
newdata = filedata.replace('<tr>  <td class="numLineCover">&nbsp;' + lineNo + '<', '<tr style="background-color:blue">  <td class="numLineCover">&nbsp;' + lineNo + '<')

# Write the file out again
f = open(path, 'w')
f.write(newdata)
f.close()
