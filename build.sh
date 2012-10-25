
function clean {
	rm -Rf ./out/
}

function build {
	mkdir out
	for file in src/*.lua; do
		echo "Building $file";
		lua utils/LuaSrcDiet/LuaSrcDiet.lua $file -o ${file/src/out} >> build.log
	done
	echo "RasMoon lib is ready to use at ./out/"
}

if [ "$1" == "help" ] ; then
	echo "build"
elif [ "$1" == "build" ] ; then
	clean
	build
else
	echo "Type help for usage"
fi


