rm -f -r davmail.properties
while read line
do
if [ "$line" = "davmail.smtpPort=" ]
then
echo "davmail.smtpPort=$PORT\n" >> "davmail.properties"
else
echo "$line\n" >> "davmail.properties"
fi
done <davmail.default.properties
echo "Port is '$PORT'."