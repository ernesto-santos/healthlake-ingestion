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
  
## Passo 2: Tomando nota do AWS HealthLake Data Store Endpoint
A partir do console do [Amazon HealthLake](https://us-east-1.console.aws.amazon.com/healthlake/home?region=us-east-1#/), abra o menu lateral esquerdo, e clique no "Data Store" que você acabou de criar:  
  
![Amazon HealthLake - Data Store End-point - Passo 2 - 1](/images/AmazonHealthLake_datastore_endpoint_1.png)  
  
A partir da tela de informações de seu "Data Store", copie a URL do Endpoint indicado pela seta na imagem abaixo, e reserve esta URL, pois a utilizaremos em nossos scripts.  
  
![Amazon HealthLake - Data Store End-point - Passo 2 - 2](/images/AmazonHealthLake_datastore_endpoint_2.png)