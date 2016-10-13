if [[ -f convert ]]; then
	cat $1 | ./convert 90
else
	echo "You should compile the go script"
	echo "Use go build convert.go"
fi
