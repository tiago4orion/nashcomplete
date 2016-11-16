# systemd related autocomplete

fn nash_complete_systemctlopt(parts, line, pos) {
	choice <= (
		echo "sucks enable disable start stop reload-daemon" |
		tr " " "\n" |
		-fzf --header "Systemd options:"
	)

	if $status != "0" {
		return ()
	}

	choice <= trim($choice)

	return ($choice+" " "0")
}

fn nash_complete_systemctl(parts, line, pos) {
	partsz <= len($parts)

	if $partsz == "1" {
		ret <= nash_complete_systemctlopt($parts, $line, $pos)

		return $ret
	}

	choice <= (
		-find /etc/systemd/
				 |
		-grep "service$"
				 |
		sed "s#/.*/##g" |
		sed "s/\\.service//g" |
		-fzf --header "select unit: "
					--reverse
					-m
	)

	if $status != "0" {
		return ()
	}

	choice <= trim($choice)

	return ($choice "0")
}
