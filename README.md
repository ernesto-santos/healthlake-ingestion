# healthlake-ingestion
Este projeto pessoal de testes tem por objetivo auxiliar na configuração de um "datastore" de Amazon HealthLake, e popula-lo com uma massa de dados sintéticos criada a partir de um outro projeto open-source chamado [Synthea](https://github.com/synthetichealth/synthea).  
  
Para os passos abaixo, assumiremos que estamos utilizando a AWS Region: us-east-1.

## Passo 1: Criando um AWS HealthLake Data Store
A partir do console do [Amazon HealthLake](https://us-east-1.console.aws.amazon.com/healthlake/home?region=us-east-1#/), clique em "Create a Data Store":  
  
![Amazon HealthLake - Create Data Store - Passo 1 - 1](/images/AmazonHealthLake_create_datastore_1.png)  
  
Escolha um nome para o seu "Data Store":  
  
![Amazon HealthLake - Create Data Store - Passo 1 - 2](/images/AmazonHealthLake_create_datastore_2.png)  
  
Clique em "Create Data Store":  
  
![Amazon HealthLake - Create Data Store - Passo 1 - 3](/images/AmazonHealthLake_create_datastore_3.png)  
  
???