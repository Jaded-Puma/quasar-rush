# This script takes a lua project and makes a single lua file
# requires a main.lua to be the only lua source file at root folder
# where the script is located then looks for source folders
# and collects lua files then outputs a single game.lua file.

import os
import glob
import re

dir_dict = {}
files: str = []

main_path = "./main.lua"
out_path  = "./game.lua"

# Make sure to set the entry line properly to avoid issues.
# I'll make this an automatic proccess at some point.
entry_line = 8

start_code = """
do
    local searchers = package.searchers or package.loaders
    local origin_seacher = searchers[2]
    searchers[2] = function(path)
        local files =
        {

"""

end_code = """
        }

        if files[path] then
            return files[path]
        else
            return origin_seacher(path)
        end
    end
end
"""

def main():
	for filename in glob.iglob('./**/*', recursive=True):
		dir_name = os.path.dirname(filename)
		base_name = os.path.basename(filename)
		ext = base_name[base_name.find(".")+1:]

		if dir_name == ".": continue

		if os.path.isdir(filename):
			dir_dict[f"{dir_name}/{base_name}"] = True
			# print("DIR: ", dir_name, base_name, ext)
		elif ext == "lua":
			files.append(f"{dir_name}/{base_name}")
			# print("LUA: ", dir_name, base_name, ext)
		else:
			#print("FILE: ", dir_name, base_name, ext)
			pass

	with open(main_path, 'r') as main_file:
		with open(out_path, 'w') as out_file:
			for i, line in enumerate(main_file):
				if i == entry_line:
					out_file.write("--- GEN CODE ---\n")
					out_file.write(start_code)
					for lua_path in files:
						module = re.match(r"\.\/(.+)\.lua",lua_path).group(1)
						module = module.replace("/", ".")
						# print(lua_path, module)
						with open(lua_path, 'r') as lua_file:
							out_file.write(f"[\"{module}\"] = function()\n")
							out_file.writelines(lua_file.readlines())
							out_file.write("\nend,\n\n")
					out_file.write(end_code)
					out_file.write("\n--- GEN CODE ---")
				out_file.write(line)
				
if __name__ == '__main__':
	print("STICHING LUA FILES...")
	main()
	print("DONE")
