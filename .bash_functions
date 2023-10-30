cl() {
	local dir="$1"
	local dir="${dir:=$HOME}"
	if [[ -d "$dir" ]]; then
		cd "$dir" >/dev/null
		ls
	else
		echo "bash: cl: $dir: Directory not found"
	fi
}

note() {
	if [[ "$1" == "-h" ]]; then
		echo "Usage: note [options] [arguments]"
		echo "Options:"
		echo "  -c  clear file"
		echo "  -h  show this help"
		echo "Arguments:"
		echo "  no arguments  print file"
		echo "  arguments     add all arguments to file"
		return
	fi

	# if file doesn't exist, create it
	if [[ ! -f $HOME/.notes ]]; then
		touch "$HOME/.notes"
	fi

	if ! (($#)); then
		# no arguments, print file
		cat "$HOME/.notes"
	elif [[ "$1" == "-c" ]]; then
		# clear file
		printf "%s" >"$HOME/.notes"
	else
		# add all arguments to file
		printf "%s\n" "$*" >>"$HOME/.notes"
	fi
}

todo() {
	if [[ "$1" == "-h" ]]; then
		echo "Usage: todo [options] [arguments]"
		echo "Options:"
		echo "  -l  list all todo items"
		echo "  -c  clear file"
		echo "  -r  remove item"
		echo "  -h  show this help"
		echo "Arguments:"
		echo "  no arguments  print file"
		echo "  arguments     add all arguments to file"
		return
	fi

	if [[ ! -f $HOME/.todo ]]; then
		touch "$HOME/.todo"
	fi

	if ! (($#)); then
		cat "$HOME/.todo"
	elif [[ "$1" == "-l" ]]; then
		nl -b a "$HOME/.todo"
	elif [[ "$1" == "-c" ]]; then
		>$HOME/.todo
	elif [[ "$1" == "-r" ]]; then
		nl -b a "$HOME/.todo"
		eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}
		echo
		read -p "Type a number to remove: " number
		sed -i ${number}d $HOME/.todo "$HOME/.todo"
	else
		printf "%s\n" "$*" >>"$HOME/.todo"
	fi
}

calc() {
	echo "scale=3;$@" | bc -l
}

ipif() {
	if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<<"$1"; then
		curl ipinfo.io/"$1"
	else
		ipawk=($(host "$1" | awk '/address/ { print $NF }'))
		curl ipinfo.io/${ipawk[1]}
	fi
	echo
}

#dirsize - finds directory sizes and lists them for the current directory
dirsize() {
	du -shx * .[a-zA-Z0-9_]* 2>/dev/null |
		egrep '^ *[0-9.]*[MG]' | sort -n >/tmp/list
	egrep '^ *[0-9.]*M' /tmp/list
	egrep '^ *[0-9.]*G' /tmp/list
	rm /tmp/list
}
