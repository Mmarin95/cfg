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

install() {
	# Function to get package details
	pkg_preview() {
		echo "$1" | xargs -I % apt-cache show %
	}

	export -f pkg_preview

	# Get a list of packages and pipe it into fzf with a preview window
	packages=$(apt-cache pkgnames | fzf --multi --preview 'pkg_preview {}')

	# Install selected packages
	if [ -n "$packages" ]; then
		echo "You selected: $packages"
		read -p "Do you want to install these packages? (y/N) " -n 1 -r
		echo # (optional) move to a new line
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			sudo apt install $packages
		fi
	fi
}

remove() {
	# Function to get package details
	pkg_preview() {
		echo "$1" | xargs -I % apt-cache show %
	}

	export -f pkg_preview

	# Get a list of installed packages and pipe it into fzf with a preview window
	packages=$(dpkg --get-selections | awk '{print $1}' | fzf --multi --preview 'pkg_preview {}')

	# Remove selected packages
	if [ -n "$packages" ]; then
		echo "You selected: $packages"
		read -p "Do you want to remove these packages? (y/N) " -n 1 -r
		echo # (optional) move to a new line
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			sudo apt remove $packages
		fi
	fi
}