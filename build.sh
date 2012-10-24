
mkdir out
for file in src/*.lua; do
	echo "Building $file";
	lua utils/LuaSrcDiet/LuaSrcDiet.lua $file -o ${file/src/out} >> build.log
done

echo "RasMoon lib is ready to use at ./out/"

