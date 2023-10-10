#!/bin/bash

# exemplos de origens: /home/ec2-user/synthea/output/fhir , /home/ec2-user/synthea/output/fhir2 , etc
dir_origem=${1}
dir_destino="/home/ec2-user/synthea/output_carregado"

for arquivo in `ls ${dir_origem} `; do
	echo "Abrindo: ${dir_origem}/${arquivo}"
	echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

	python3 /home/ec2-user/json_import_thiago/healthlake-request.py ${dir_origem}/${arquivo}

	if [ $? -ne 0 ]; then
		echo "Erro !!!"
	else
		echo "Movendo arquivo de: ${dir_origem}/${arquivo} -->> ${dir_destino}/${arquivo}"
		echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

		mv ${dir_origem}/${arquivo} ${dir_destino}/${arquivo}
	fi
done
