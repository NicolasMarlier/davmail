
function get_app_git() {
while read line
do
	if [[ "$line" == "Git URL:"* ]]
		then
		echo "$line" | egrep -o '(http.+)'
		return
	fi
done <<<"$(heroku apps:info --app $1)"	
}




apps=()
function get_heroku_app_names() {
while read line
do
if [ "$line" = "=== My Apps" ] || [ "$line" = "" ]
then
	echo ""
else
	apps+=("$line")
fi
done <<<"$(heroku apps)"
}

function deploy() {

get_heroku_app_names

while read line
do
	while IFS='=' read -ra ADDR
	do
		
		app_exists=false
		for app_name in "${apps[@]}"
		do
			if [ "$app_name" = "jddv-proxy-${ADDR[0]}" ]
				then
				app_exists=true
				break
			fi
		done

		if [ "$app_exists" = "true" ]
			then
			echo "Proxy ${ADDR[0]} already exists.\n"
		else
			echo "Proxy ${ADDR[0]} does not exist, creating 'jddv-proxy-${ADDR[0]}'...\n"
			heroku create jddv-proxy-${ADDR[0]} --buildpack https://github.com/heroku/heroku-buildpack-jvm-common.git
		fi

		app_git=$(get_app_git jddv-proxy-${ADDR[0]})
		echo "App git is: $app_git"
		git push ${app_git} master:master

	done <<< "$line"
done < exchange_servers.properties
}

deploy