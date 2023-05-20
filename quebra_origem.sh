#!/bin/bash

for count_dirs in `seq ${1} ${2}`; do
	echo ${count_dirs}
	counter=0

	for files in `ls /home/ec2-user/synthea/output/fhir`; do
		mv /home/ec2-user/synthea/output/fhir/${files} /home/ec2-user/synthea/output/fhir${count_dirs}

		echo ${files}

		if [ ${counter} -ge ${3} ]; then
			break
		fi

		let counter=counter+1
	done

	echo "=-=-=-=-=-=-=-=-=-=-=-=-="
	sleep 2
done