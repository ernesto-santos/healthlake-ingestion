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
  
Baixaremos então o repositório do projeto Synthea, e efetuaremos a instalação do mesmo.  
  
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
  
Após a geração dos pacientes sintéticos, veremos os arquivos gerados no diretório "/home/ec2-user/synthea/output/fhir", como podemos verificar neste exemplo abaixo, onde geramos 10 pacientes.
  
```  
ls -la /home/ec2-user/synthea/output/fhir/
total 17660
drwxr-xr-x. 2 ec2-user ec2-user   16384 May 20 21:24 .
drwxr-xr-x. 4 ec2-user ec2-user      34 May 20 19:14 ..
-rw-r--r--. 1 ec2-user ec2-user  770257 May 20 21:24 Bertie593_Jacobson885_daa832b2-a84c-6dec-87a0-4f50b97771db.json
-rw-r--r--. 1 ec2-user ec2-user  626270 May 20 21:24 Bethel526_Kling921_f4e0b2b0-01cb-5b36-666d-4e7da70f90e2.json
-rw-r--r--. 1 ec2-user ec2-user 1027383 May 20 21:24 Efrain317_Gusikowski974_f2097a8f-9d4a-41f0-c6c4-3bc70abd2e74.json
-rw-r--r--. 1 ec2-user ec2-user 1032788 May 20 21:24 Evangeline16_Lowe577_935bad98-c3b4-5756-44be-12bf55adb976.json
-rw-r--r--. 1 ec2-user ec2-user 6428479 May 20 21:24 Jana258_Bernier607_60e0a3e1-586f-8dda-21ba-9671af83e390.json
-rw-r--r--. 1 ec2-user ec2-user  457753 May 20 21:24 Mark765_Klein929_68e74ffd-81a0-fd6b-722c-2a130734964b.json
-rw-r--r--. 1 ec2-user ec2-user 2022285 May 20 21:24 Nadia817_Sipes176_6892ce66-5ca5-47b3-2a70-4e49ed121343.json
-rw-r--r--. 1 ec2-user ec2-user 2703401 May 20 21:24 Noreen211_Roob72_5df2881a-f46f-0729-c519-f0440302e382.json
-rw-r--r--. 1 ec2-user ec2-user  880148 May 20 21:24 Paz9_Pfannerstill264_02efd55e-02fa-09d0-924d-5e7ba6be14b6.json
-rw-r--r--. 1 ec2-user ec2-user  696862 May 20 21:24 Sadie426_Dicki44_367c89fd-259c-105d-5951-da5f1ce8b6cf.json
-rw-r--r--. 1 ec2-user ec2-user  726697 May 20 21:24 Shawn523_Heidenreich818_7bce2dd4-a795-ad80-a338-0e51bacb464c.json
-rw-r--r--. 1 ec2-user ec2-user  363643 May 20 21:24 Terresa418_Towne435_f0bfa360-a7b8-a4ff-1ba4-1dc9952c2e05.json
-rw-r--r--. 1 ec2-user ec2-user  148352 May 20 21:24 hospitalInformation1684617874405.json
-rw-r--r--. 1 ec2-user ec2-user  155126 May 20 21:24 practitionerInformation1684617874405.json
```
  
Afim de distribuir estes arquivos em 5 grupos, iremos criar 4 outros diretórios na mesma estrutura de "output" do Synthea.  
Para isso podemos executar a linha abaixo.  
  
```
for a in `seq 2 5`; do mkdir /home/ec2-user/synthea/output/fhir${a}; done
``` 
  
Agora temos os diretórios "../fhir2" a "../fhir5".
  
```
ls -la /home/ec2-user/synthea/output/
total 48
drwxr-xr-x.  8 ec2-user ec2-user    86 May 20 21:30 .
drwxr-xr-x. 11 ec2-user ec2-user 16384 May 20 19:14 ..
drwxr-xr-x.  2 ec2-user ec2-user 16384 May 20 21:24 fhir
drwxr-xr-x.  2 ec2-user ec2-user     6 May 20 21:30 fhir2
drwxr-xr-x.  2 ec2-user ec2-user     6 May 20 21:30 fhir3
drwxr-xr-x.  2 ec2-user ec2-user     6 May 20 21:30 fhir4
drwxr-xr-x.  2 ec2-user ec2-user     6 May 20 21:30 fhir5
drwxr-xr-x.  2 ec2-user ec2-user 16384 May 20 21:24 metadata
```
  
Com isso iremos executar um dos script de nosso repositório, afim de reagrupar os arquivos gerados através dos novos diretórios criados.  
O script abaixo espera 3 parametros:  
Parametro 1: numeral do primeiro novo diretório criado (neste exemplo 2).  
Parametro 2: numeral do último novo diretório criado (neste exemplo 5).  
Parametro 3: quantos arquivos devem ser movidos para os novos diretórios (neste exemplo 2).  
  
```
