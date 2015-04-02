rm -f -r davmail.properties
while read line
do
if [ "$line" = "davmail.caldavPort=" ]
then
echo "davmail.caldavPort=$PORT\n" >> "davmail.properties"
else
echo "$line\n" >> "davmail.properties"
fi
done <davmail.default.properties
echo "Port is '$PORT'."