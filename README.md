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
  
## Passo 3: Criando uma AW IAM Role, para ser usada na instancia EC2 que rodará os scripts de ingestão:
A partir do console do [AWS IAM](https://us-east-1.console.aws.amazon.com/iamv2), iremos criar uma AWS IAM Role conforme a abaixo.  
  
![Amazon HealthLake - AWS IAM Role - Passo 3 - 1](/images/AmazonHealthLake_iam_role_1.png)
  
Esta AWS IAM Role terá a configuração conforme a figura abaixo.  

![Amazon HealthLake - AWS IAM Role - Passo 3 - 2](/images/AmazonHealthLake_iam_role_2.png)

## Passo 4: Criando uma instancia EC2 para a execução dos scripts de carga:
Aqui executaremos alguns passos:  
1. Criaremos uma AWS VPC
2. Criaremos SubNets Públicas e Privadas abaixo da AWS VPC criada
3. Criaremos uma "Key Pair" para usarmos no acesso SSH à instancia EC2 a qual criaremos
4. Criaremos uma instancia EC2 sob uma das SubNets públicas
  1. Esta instancia utilizará como sistema operacional o Amazon Linux
  2. Esta instancia terá o tamanho necessário para atender a volumetria de ingestão a qual iremos realizar 
  3. Esta instancia utilizará um IP válido (para que possamos acessa-la via SSH)
  4. Esta instancia terá um AWS Security Group que permita somente acesso SSH a partir do seu IP atual de saída para a Internet
  5. Esta instancia necessitará possuir espaço em disco suficiente para abrigar a massa de dados com a qual iremos lidar
