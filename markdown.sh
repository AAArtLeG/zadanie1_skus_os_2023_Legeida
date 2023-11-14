#!/bin/bash
cat << THE_END
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
THE_END
COUNTER=0
while IFS= read LINE
do
	if echo "$LINE" | grep '^# ' >/dev/null
	then
		LINE=$(echo "$LINE" | sed -r  's@^# (.*)$@<h1>\1</h1>@')
		echo "$LINE"
	elif echo "$LINE" | grep '^## ' >/dev/null
	then
		LINE=$(echo "$LINE" | sed -r 's@^## (.*)$@<h2>\1</h2>@')
		echo "$LINE"
	elif echo "$LINE" | grep '__.*__' >/dev/null
	then
		LINE=$(echo "$LINE" | sed -r 's@__([^_]+)__@<strong>\1</strong>@g')
		echo "$LINE"
	elif echo "$LINE" | grep '_.*_' >/dev/null
	then
		LINE=$(echo "$LINE" | sed -r 's@_([^_]+)_@<em>\1</em>@g')
		echo "$LINE"
	elif echo "$LINE" | grep '<https://.*>' >/dev/null
	then
		LINE=$(echo "$LINE" | sed -r 's@<(https://[^<]+)>@<a href="\1">\1</a>@g')
		echo "$LINE"
	elif echo "$LINE" | grep '^ - .*' >/dev/null
	then
		if [ $COUNTER = 0 ]
		then
			echo "<ul>"
			let COUNTER=COUNTER+1
		fi
		LINE=$(echo "$LINE" | sed -r 's@^ - (.*$)@<li>\1</li>@')
                echo "$LINE"
	elif [ $COUNTER = 1 ] &&  echo "$LINE" |  grep -v ' - .*' >/dev/null
	then
		echo "</ul>"
		let COUNTER=0
		echo "$LINE"
	elif echo "$LINE" | grep '^\s*$' >/dev/null
	then
		echo "<p>"
	else
		echo "$LINE"
	fi
done
echo "</body>"
echo "</html>"
