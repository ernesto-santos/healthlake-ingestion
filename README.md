# healthlake-ingestion
Este projeto pessoal de testes tem por objetivo auxiliar na configuração de um "datastore" de Amazon HealthLake, e popula-lo com uma massa de dados sintéticos criada a partir de um outro projeto open-source chamado [Synthea](https://github.com/synthetichealth/synthea).  
  
Para os passos abaixo, assumiremos que estamos utilizando a AWS Region: us-east-1.

## Passo 1: Criando um AWS HealthLake Data Store
A partir do console do [Amazon HealthLake](https://us-east-1.console.aws.amazon.com/healthlake/home?region=us-east-1#/), clique em "Create a Data Store":  
  
<kbd>![Amazon HealthLake - Create Data Store - Passo 1 - 1](/images/AmazonHealthLake_create_datastore_1.png)</kbd>
  
Escolha um nome para o seu "Data Store":  
  
<kbd>![Amazon HealthLake - Create Data Store - Passo 1 - 2](/images/AmazonHealthLake_create_datastore_2.png)</kbd>
  
Clique em "Create Data Store":  
  
<kbd>![Amazon HealthLake - Create Data Store - Passo 1 - 3](/images/AmazonHealthLake_create_datastore_3.png)</kbd>
  
## Passo 2: Tomando nota do AWS HealthLake Data Store Endpoint
A partir do console do [Amazon HealthLake](https://us-east-1.console.aws.amazon.com/healthlake/home?region=us-east-1#/), abra o menu lateral esquerdo, e clique no "Data Store" que você acabou de criar:  
  
<kbd>![Amazon HealthLake - Data Store End-point - Passo 2 - 1](/images/AmazonHealthLake_datastore_endpoint_1.png)</kbd>
  
A partir da tela de informações de seu "Data Store", copie a URL do Endpoint indicado pela seta na imagem abaixo, e reserve esta URL, pois a utilizaremos em nossos scripts.  
  
<kbd>![Amazon HealthLake - Data Store End-point - Passo 2 - 2](/images/AmazonHealthLake_datastore_endpoint_2.png)</kbd>
  
## Passo 3: Criando uma AW IAM Role, para ser usada na instancia EC2 que rodará os scripts de ingestão:
A partir do console do [AWS IAM](https://us-east-1.console.aws.amazon.com/iamv2), iremos criar uma AWS IAM Role conforme a abaixo.  
  
<kbd>![Amazon HealthLake - AWS IAM Role - Passo 3 - 1](/images/AmazonHealthLake_iam_role_1.png)</kbd>
  
Esta AWS IAM Role terá a configuração conforme a figura abaixo.  

<kbd>![Amazon HealthLake - AWS IAM Role - Passo 3 - 2](/images/AmazonHealthLake_iam_role_2.png)</kbd>

## Passo 4: Criando uma instancia EC2 para a execução dos scripts de carga:
Para a criação da instancia EC2, deve-se atender aos passos abaixo:  
1. Criar uma AWS VPC
2. Criar SubNets Públicas e Privadas abaixo da AWS VPC criada
3. Criar uma "Key Pair", para ser usada no acesso SSH à instancia EC2 que será criada
4. Criar uma instancia EC2 abaixo de uma das SubNets públicas criadas acima
    1. Esta instancia utilizará como sistema operacional o Amazon Linux
    2. Esta instancia precisará ter o tamanho (tipo) necessário para atender a volumetria de ingestão relizada 
    3. Esta instancia utilizará um IP válido (para que seja possível o acesso à mesma via SSH)
    4. Esta instancia deve estar associada a um AWS Security Group que permita acesso SSH somente a partir do seu IP atual de saída para a Internet
    5. Esta instancia necessitará possuir espaço em disco suficiente para abrigar a massa de dados a qual se planeja trabalhar

## Passo 5: Associação da AWS IAM Role à instancia EC2 recém criada:
A partir da tela de detalhes da instancia, utilizando-se do botão "Actions", iremos seguir a sequencia de escolha conforme a imagem abaixo.  
  
<kbd>![Amazon HealthLake - AWS IAM Role - Passo 5 - 1](/images/AmazonHealthLake_ec2_profile_1.png)</kbd>
  
Na tela de "Modify IAM Role", escolhemos a AWS IAM Role que criamos no passo 3, e clicaremos no botão "Update IAM Role".  
  
<kbd>![Amazon HealthLake - AWS IAM Role - Passo 5 - 1](/images/AmazonHealthLake_ec2_profile_2.png)</kbd>
  
## Passo 6: Instalando o projeto Synthea na instancia EC2 recém criada:
A partir de um acesso à instancia EC2 via SSH, iremos instalar o projeto Synthea, o qual utilizaremos para genar nossa massa de dados de pacientes sintéticos no formato FHIR.  
  
Inicialmente instalaremos o JDK java e o cliente do git.
  
```
sudo yum install java-11-amazon-corretto-devel.x86_64 git
```
  
Baixar então o repositório do projeto Synthea, e efetuaremos a instalação do mesmo na instancia.  
  
```
cd /home/ec2-user
git clone https://github.com/synthetichealth/synthea.git
cd synthea
./gradlew build check test
```

Baixaremos este nosso repositório na instancia que estamos utilizando.
  
```
cd /home/ec2-user
git clone https://github.com/ernesto-santos/healthlake-ingestion.git
```

Substituiremos o arquivo original "synthea.properties" por um customizado para as nossas necessidades, o qual temos em nosso repositório.
  
```
mv /home/ec2-user/healthlake-ingestion/synthea_exemplo.properties /home/ec2-user/synthea/src/main/resources/synthea.properties
```
  
Agora estamos prontos para iniciar a geração de massa de pacientes sintéticos.  
Para isso iremos executar o "run_synthea" para a operação de criação dos arquivos, onde ???? refere-se a quantidade de pacientes que iremos criar.  

```
cd /home/ec2-user/synthea
./run_synthea -s 9999 -p ????
``` 
  


