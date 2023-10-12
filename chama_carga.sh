#!/bin/bash

# Exemplos de origens: /home/ec2-user/synthea/output/fhir , /home/ec2-user/synthea/output/fhir2 , ...
# Exemplos de destinos: /home/ec2-user/healthlake-ingestion/output_carregados

dir_origem=${1}
dir_destino=${2}

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
