# healthlake-ingestion
Este projeto pessoal de testes tem por objetivo auxiliar na configuração de um "datastore" de Amazon HealthLake, e popula-lo com uma massa de dados sintéticos criada a partir de um outro projeto open-source chamado [Synthea](https://github.com/synthetichealth/synthea).  
  
Para os passos abaixo, assumiremos que estamos utilizando a AWS Region: us-east-1.

## Passo 1: Criando um AWS HealthLake Data Store
A partir do console do [Amazon HealthLake](https://us-east-1.console.aws.amazon.com/healthlake/home?region=us-east-1#/), clique em "Create a Data Store".  
  
![Amazon HealthLake - Create Data Store](/images/AmazonHealthLake_create_datastore_1.png)  
  
???