## Integração Contínua e Deploy Contínuo

## Introdução
 
A integração contínua (CI) e o deploy contínuo (CD) são práticas de desenvolvimento de software que visam automatizar o processo de construção, teste e implantação de código. A CI envolve a integração frequente de código em um repositório compartilhado, enquanto o CD envolve a implantação automatizada de código em um ambiente de produção.


### Importância do CI/CD

A importância do CI/CD no desenvolvimento de software é inegável. Ele permite que as equipes de desenvolvimento automatizem tarefas repetitivas, reduzam erros humanos e acelerem o ciclo de desenvolvimento. Com o CI/CD, as equipes podem entregar software de alta qualidade de forma rápida e eficiente.

## Visão Geral

O pipeline do projeto é composto pelos quatro pipelines, sendo eles: Backend, Frontend, API Wallet e API Consultor. Cada pipeline é responsável por automatizar o processo de construção, teste e implantação de um componente específico do sistema.

## Pipeline CI/CD do Backend

### Job: tests

Este job roda testes e faz análise de cobertura de código para garantir a qualidade do código antes de prosseguir para a construção:

1. **Checkout code**: Faz o checkout do código do repositório.
2. **Setup Node**: Configura o Node.js na versão 18.
3. **Configure AWS credentials**: Configura as credenciais da AWS a partir de segredos armazenados no GitHub Secrets.
4. **Pull Firebase Credentials**: Baixa credenciais do Firebase de um bucket S3.
5. **Install Dependencies**: Instala `make`.
6. **Get Coverage**: Instala `jest` e roda os testes para gerar cobertura de código.
7. **Setup SonarQube**: Configura o SonarQube scanner.
8. **Upload coverage to SonarCloud**: Faz upload da cobertura de código para o SonarCloud.

### Job: build

Este job faz a construção da aplicação e cria uma imagem Docker:

1. **Checkout code**: Faz o checkout do código do repositório.
2. **Install Dependencies**: Instala `make`.
3. **Set up Terraform**: Configura o Terraform.
4. **Configure AWS credentials**: Configura as credenciais da AWS.
5. **Pull Firebase Credentials**: Baixa credenciais do Firebase de um bucket S3.
6. **Login to Amazon ECR**: Faz login no Amazon ECR (Elastic Container Registry).
7. **Build, tag, and push docker image to Amazon ECR**: Constrói a imagem Docker e a envia para o ECR.
8. **Deploy Infrastructure**: Inicializa e aplica configurações do Terraform para provisionar a infraestrutura.

### Job: update

Este job atualiza arquivos no servidor VPS:

1. **Checkout code**: Faz o checkout do código do repositório.
2. **Update Compose**: Usa `scp` para copiar arquivos `docker-compose-prod.yaml`, `Makefile`, e `Caddyfile.prod` para o servidor VPS.

### Job: deploy

Este job realiza a implantação no servidor:

1. **Configure AWS credentials**: Configura as credenciais da AWS.
2. **Login to Amazon ECR**: Faz login no Amazon ECR.
3. **Deploying Server**: Usa `ssh` para executar comandos no servidor, parando o container Docker antigo, removendo imagens antigas, e rodando o novo container a partir da imagem Docker atualizada.

## Pipeline CI/CD do Frontend

### Evento Disparador

O pipeline é acionado manualmente (`workflow_dispatch`) ou por pushes no branch `main`.

### Job: deploy

Este job realiza o deploy do frontend no Vercel. Ele consiste nos seguintes passos:

1. **Checkout code**: Faz o checkout do código do repositório utilizando a ação `actions/checkout@v3`.
    ```yaml
    - name: Checkout code
      uses: actions/checkout@v3
    ```

2. **Set up Node.js**: Configura o Node.js na versão 18.17.0 e utiliza o arquivo `package-lock.json` do diretório `frontend` para cache de dependências.
    ```yaml
    - name: Set up Node.js
      uses: actions/setup-node@v4
      with:
        node-version: 18.17.0
        cache-dependency-path: frontend/package-lock.json
    ```

3. **Update lock file**: Atualiza o arquivo `package-lock.json` no diretório `frontend`.
    ```yaml
    - name: Update lock file
      run: cd frontend && npm install --package-lock
    ```

4. **Install dependencies**: Instala as dependências do projeto no diretório `frontend` utilizando `npm ci`.
    ```yaml
    - name: Install dependencies
      run: cd frontend && npm ci
    ```

5. **Build**: Constrói o projeto no diretório `frontend` utilizando o comando `npm run build`.
    ```yaml
    - name: Build
      run: cd frontend && npm run build
    ```

6. **Set Environment Variables**: Configura as variáveis de ambiente no Vercel utilizando a ação `dkershner6/vercel-set-env-action@v3`. As variáveis de ambiente são obtidas dos segredos armazenados no GitHub Secrets.
    ```yaml
    - name: Set Environment Variables
      uses: dkershner6/vercel-set-env-action@v3
      with:
        token: ${{ secrets.VERCEL_TOKEN }}
        teamId: ${{ secrets.VERCEL_ORG_ID }}
        projectName: crypto-frontend
        envVariableKeys: VITE_API_HOST
      env:
        VITE_API_HOST: ${{ secrets.VITE_API_HOST }}
        TARGET_VITE_API_HOST: production # comma delimited, one of [production, preview, development]
        TYPE_VITE_API_HOST: encrypted # one of [plain, encrypted]
    ```

7. **Deploy to Vercel**: Realiza o deploy do projeto no Vercel utilizando a ação `amondnet/vercel-action@v25`.
    ```yaml
    - name: Deploy to Vercel
      uses: amondnet/vercel-action@v25
      with:
        path: './frontend'
        vercel-token: ${{ secrets.VERCEL_TOKEN }}
        vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
        vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
        vercel-args: --prod
    ```

## Pipeline CI/CD da API Wallet

### Evento Disparador

O pipeline é acionado manualmente (`workflow_dispatch`) ou por pushes no branch `main`.

### Job: tests

Este job realiza testes e análise de cobertura do código. Ele consiste nos seguintes passos:

1. **Checkout code**: Faz o checkout do código do repositório utilizando a ação `actions/checkout@v3`.
    ```yaml
    - name: Checkout code
      uses: actions/checkout@v3
    ```

2. **Install Dependencies**: Instala o `make` utilizando `apt-get`.
    ```yaml
    - name: Install Dependencies
      run: |
        sudo apt-get update
        sudo apt-get -y install make
    ```

3. **Get Coverage**: Executa a análise de cobertura de código utilizando o comando `make coverage`.
    ```yaml
    - name: Get Coverage
      run: make coverage
    ```

4. **Setup SonarQube**: Configura o SonarQube Scanner utilizando a ação `warchant/setup-sonar-scanner@v7`.
    ```yaml
    - name: Setup SonarQube
      uses: warchant/setup-sonar-scanner@v7
    ```

5. **Upload coverage to SonarCloud**: Faz o upload da cobertura de código para o SonarCloud utilizando os segredos armazenados no GitHub Secrets.
    ```yaml
    - name: Upload coverage to SonarCloud
      env:
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        SONAR_PROJECT_KEY: ${{ secrets.SONAR_PROJECT_KEY }}
        SONAR_ORGANIZATION: ${{ secrets.SONAR_ORGANIZATION }}
      run: make sonar
    ```

### Job: deploy

Este job realiza o deploy da API do Wallet. Ele depende do job `tests` ser concluído com sucesso e consiste nos seguintes passos:

1. **Checkout code**: Faz o checkout do código do repositório utilizando a ação `actions/checkout@v3`.
    ```yaml
    - name: Checkout code
      uses: actions/checkout@v3
    ```

2. **Install Dependencies**: Instala o `make` utilizando `apt-get`.
    ```yaml
    - name: Install Dependencies
      run: |
        sudo apt-get update
        sudo apt-get -y install make
    ```

3. **Set up Terraform**: Configura o Terraform utilizando a ação `hashicorp/setup-terraform@v2`.
    ```yaml
    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v2
    ```

4. **Configure AWS credentials**: Configura as credenciais AWS utilizando a ação `aws-actions/configure-aws-credentials@v2`.
    ```yaml
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ vars.AWS_DEFAULT_REGION }}
    ```

5. **Setup Python 3.8**: Configura o Python 3.8 utilizando a ação `actions/setup-python@v5`.
    ```yaml
    - name: Setup Python 3.8
      uses: actions/setup-python@v5
      with:
        python-version: '3.8'
    ```

6. **Build project for production**: Constrói o projeto para produção utilizando o comando `make prod-build-deps`.
    ```yaml
    - name: Build project for production
      run: make prod-build-deps
    ```

7. **Zip project for lambda**: Compacta o projeto para ser utilizado no AWS Lambda utilizando o comando `make zip`.
    ```yaml
    - name: Zip project for lambda
      run: make zip
    ```

8. **Deploy**: Realiza o deploy da infraestrutura utilizando Terraform. As variáveis de ambiente necessárias são obtidas dos segredos armazenados no GitHub Secrets.
    ```yaml
    - name: Deploy
      env:
        TF_VAR_MONGO_URI: ${{ secrets.MONGO_URI }}
        TF_VAR_environment: prod
        TF_VAR_PG_HOST: ${{ secrets.PG_HOST }}
        TF_VAR_PG_USER: ${{ secrets.PG_USER }}
        TF_VAR_PG_PASS: ${{ secrets.PG_PASS }}
        TF_VAR_PG_DB: ${{ secrets.PG_DB }}
        TF_VAR_PG_SSL: True
      run: |
        make tf-init
        make tf-apply
    ```

## Pipeline CI/CD do Frontend da API Consultor

### Evento Disparador

O pipeline é acionado manualmente (`workflow_dispatch`) ou por pushes no branch `main`.

### Variáveis de Ambiente

As variáveis de ambiente são definidas no nível do pipeline e são utilizadas em diferentes etapas do job. Elas incluem as chaves de acesso da AWS, a região da AWS, as chaves e URLs da API CoinGecko e as informações do banco de dados.

```yaml
env:
  AWS_ACCESS_KEY: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  AWS_REGION: ${{ vars.AWS_DEFAULT_REGION }}
  COIN_GECKO_API_KEY: ${{ secrets.COIN_GECKO_API_KEY }}
  COIN_GECKO_API_URL: ${{ secrets.COIN_GECKO_API_URL }}
  DB_URL: ${{ secrets.DB_URL }}
  DB_SCHEMA: ${{ vars.DB_SCHEMA }}
```

### Job: deploy

Este job realiza o deploy da API do Consultor e consiste nos seguintes passos:

1. **Checkout code**: Faz o checkout do código do repositório utilizando a ação `actions/checkout@v3`.
    ```yaml
    - name: Checkout code
      uses: actions/checkout@v3
    ```

2. **Install Dependencies**: Instala o `make` utilizando `apt-get`.
    ```yaml
    - name: Install Dependencies
      run: |
        sudo apt-get update
        sudo apt-get -y install make
    ```

3. **Set up Terraform**: Configura o Terraform utilizando a ação `hashicorp/setup-terraform@v2`.
    ```yaml
    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v2
    ```

4. **Configure AWS credentials**: Configura as credenciais AWS utilizando a ação `aws-actions/configure-aws-credentials@v2` e as variáveis de ambiente definidas anteriormente.
    ```yaml
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ env.AWS_ACCESS_KEY }}
        aws-secret-access-key: ${{ env.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ env.AWS_REGION }}
    ```

5. **Setup Python 3.8**: Configura o Python 3.8 utilizando a ação `actions/setup-python@v5`.
    ```yaml
    - name: Setup Python 3.8
      uses: actions/setup-python@v5
      with:
        python-version: '3.8'
    ```

6. **Build project for production**: Constrói o projeto para produção utilizando o comando `make install-prod`.
    ```yaml
    - name: Build project for production
      run: make install-prod
    ```

7. **Zip project for lambda**: Compacta o projeto para ser utilizado no AWS Lambda utilizando o comando `make zip`.
    ```yaml
    - name: Zip project for lambda
      run: make zip
    ```

8. **Deploy**: Realiza o deploy da infraestrutura utilizando Terraform. As variáveis de ambiente necessárias são obtidas dos segredos armazenados no GitHub Secrets.
    ```yaml
    - name: Deploy
      env:
        TF_VAR_environment: prod
        TF_VAR_COIN_GECKO_API_KEY: ${{ env.COIN_GECKO_API_KEY }}
        TF_VAR_COIN_GECKO_API_URL: ${{ env.COIN_GECKO_API_URL }}
        TF_VAR_DB_URL: ${{ env.DB_URL }}
        TF_VAR_DB_SCHEMA: ${{ env.DB_SCHEMA }}
      run: |
        make tf-init
        make tf-apply
    ```

## Considerações Finais

A arquitetura do pipeline CI/CD é fundamental para o desenvolvimento de software eficiente e eficaz. Ela fornece uma visão geral do sistema e ajuda a orientar o desenvolvimento de software de forma estruturada e organizada. O documento de arquitetura apresentado neste documento descreve os principais componentes do pipeline e como eles se relacionam entre si para atender aos requisitos do sistema.

A arquitetura do pipeline CI/CD é flexível e escalável, permitindo que o sistema seja facilmente adaptado e expandido para atender às necessidades dos desenvolvedores. Com uma arquitetura bem definida, o pipeline CI/CD será capaz de fornecer uma experiência de desenvolvimento e implantação eficiente e eficaz para os desenvolvedores.

O desenvolvimento do pipeline CI/CD continuará a ser guiado pela arquitetura apresentada neste documento, garantindo que o sistema seja desenvolvido de acordo com as melhores práticas de engenharia de software e atenda aos requisitos dos desenvolvedores.

O SonarQube foi uma ferramenta importante para garantir a qualidade do código e a análise de cobertura de código. Ele fornece informações valiosas sobre a qualidade do código e ajuda a identificar possíveis problemas antes que eles se tornem um problema.

Sua análise é empregada em todos os repositórios do projeto e é uma parte essencial do pipeline CI/CD. O uso do SonarQube garante que o código seja mantido de acordo com os padrões de qualidade e ajuda a garantir que o software seja desenvolvido de acordo com as melhores práticas de engenharia de software.

## Histórico de versão

| Data | Versão | Modificação | Autor |
| :- | :- | :- | :- |
| 06/07/2024 | 0.1 | Criação do documento | [Victor Buendia](https://github.com/Victor-Buendia) |
