#!/bin/sh
clear
echo "==================== JSON COMBINER ================================="
echo " Build date : 04/01/2027"
echo " Author : Anushka K R"
echo " Author URL : http://www.anushkar.com"
echo " Version 1.0.0"
echo "==================== JSON COMBINER ================================="
echo ""
nexturl="https://otx.alienvault.com:443/api/v1/pulses/subscribed?page=1"
echo "Your initial url is:"
echo "$nexturl"
echo "===================================================================="
echo "Do you want use it ? Y or N"
read usenexturl
if [[ "$usenexturl" = "N" || "$usenexturl" = "n" ]]; then
echo "===================================================================="
	echo "Please enter new url."
	read nexturl

fi
echo "===================================================================="
echo "Do you want to process untill the end ? Y or N"
read processend
echo "===================================================================="
if [[ "$processend" = "Y" || "$processend" = "y" ]]; then
echo "// Infinity Process started //"
counter=1;
echo "[" > final_result.json
	while [[ "$nexturl" != "null" ]]; do
	echo " // $counter //"
	echo " // url - $nexturl"
		curl "$nexturl" -H "X-OTX-API-KEY: a480af4d5c7fe66fe3f0b7f213e3fcc05ec7a3053cc5c063f06415edd8f57a53" > temp.json
		nexturl=($(jq -r ".next" temp.json))
		myresults=$(jq ".results" temp.json)
		tempresult=${myresults:1}
		tempresult2=${tempresult%?}
		echo "$tempresult2 ," >> final_result.json
		((counter++))
		echo " // //"
	done
echo "]" >> final_result.json
else
echo "============================= Number of request ========================="
numberofpages=10
echo "Default number of pages is \" $numberofpages \" "
echo "Do you want to change it ? Y or N"
read changeit
if [[ "$changeit" = "Y" || "$changeit" = "y" ]]; then
echo "===================================================================="
echo "Please enter how many times you will need to send the request"
read numberofpages;
echo "===================================================================="
fi 
echo "[" > final_result.json
	for ((i = 0; i < $numberofpages; i++)); do
	echo " // $((i+1)) // "
	echo " // url - $nexturl"
	curl "$nexturl" -H "X-OTX-API-KEY: a480af4d5c7fe66fe3f0b7f213e3fcc05ec7a3053cc5c063f06415edd8f57a53" > temp.json
	nexturl=($(jq -r ".next" temp.json))
	myresults=$(jq ".results" temp.json)
	tempresult=${myresults:1}
	tempresult2=${tempresult%?}
	echo "$tempresult2 ," >> final_result.json
	echo " ////// "
	done
echo "]" >> final_result.json

fi
echo "Merged json result file is saved as final_result.json"