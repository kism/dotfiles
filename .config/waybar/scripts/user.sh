STRING="${USER}@${HOSTNAME}"

UPTIME=$(uptime -p | sed -e 's/up //g')

STRING="{\"text\":\"${STRING}\",\"tooltip\":\"Uptime: ${UPTIME}\"}"

echo $STRING
