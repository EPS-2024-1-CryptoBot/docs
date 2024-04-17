# Como Contribuir?

**Siga as diretrizes abaixo.**

## 1. Código de conduta

&emsp;&emsp;Para contribuir em qualquer respositório desse projeto, siga o seguinte [código de conduta](./CODE_OF_CONDUCT.md).

## 2. Política de Branches

A partir das branches que serão resolvidas as issues e criados artefatos para serem adicionados ao projeto principal, após revisões.

Existem 3 tipos de branches, que, para projetos de menor escopo, como este, possui uma menor burocracia e maior eficácia no gerenciamento do projeto.

- São elas:
  - [Main](#main)
  - [Features](#features)
  - [Hotfix](#hotfix)
  - [Doc](#doc)

#### 2.1 Main

**Existe somente uma branch Main!** Essa branch contém o projeto em seu estado mais estável. É nessa branch que se deve ter todos os arquivos antes de alguma _release_. Quando alguma funcionalidade é implementada, deve ser feito um _pull request_ para essa branch, que será analisada pelo colaborador responsável.

#### 2.2 Features

Essa ramificação é criada sempre que uma issue endereça uma nova funcionalidade para o projeto. **Essa branch é criada a partir da [Main](#main) e é mesclada à mesma branch**. Para criar uma branch desse tipo, devemos executar os comandos:

```git
git branch feature/indice-nome-da-issue
git checkout indice-nome-da-issue
```

ou ainda

```git
git checkout -b feature/indice-nome-da-issue
```

#### 2.3 Hotfix

As branches hotfix devem ser criadas quando há uma issue apontando a necessidade de correção de bugs nas funcionalidades do projeto. **Essa branch é criada apartir da [Main](#main) e é mesclada à mesma branch**.

Para criar uma branch desse tipo, devemos executar os comandos:

```git
git branch hotfix/indice-nome-da-issue
git checkout hotfix/indice-nome-da-issue
```

ou ainda

```git
git checkout -b hotfix/indice-nome-da-issue
```

##### 2.4 Doc

As branches docs devem ser criadas quando há uma issue apontando a necessidade de criação de documentos. **Essa branch é criada a partir da [Main](#main) e é mesclada à mesma branch**. Após a primeira versão estável, correções podem ser feitas diretamente na branch Main.

Para criar uma branch desse tipo, devemos executar os comandos:

```git
git branch doc/indice-nome-da-issue
git checkout doc/indice-nome-da-issue
```

ou ainda

```git
git checkout -b doc/indice-nome-da-issue
```

## 3. Política de Commits

Os commits são essenciais para acompanharmos as alterações e adições ao projeto. 
Deve ser usado o modo imperativo (ações e ordens assertivas) para mencionar o que foi feito.

#### Princípios básicos

#####  1. Faça commits atômicos quando possível

Os commits atômicos são aqueles que gravam apenas uma única mudança – ainda que envolva vários arquivos – em um único commit. É claro que nem sempre dá para fazer, mas é uma prática excelente se conseguir fazer.

#####  2. Faça commits regulares e frequentes

Algumas pessoas esperam demais até gravar alguma alteração, às vezes ficam ali melhorando algo que já está funcionando, buscando algum tipo de perfeição antes de gravar. Ao gravar com frequência, você vai

 rastrear inclusive como você foi melhorando aquele código ao longo do seu processo e histórico de desenvolvimento.

#####  3. Escreva mensagens de commit claras

As mensagens precisam fazer sentido e ser úteis para todos do time.

##### 4. Faça commits pontuais e objetivos

Evite fazer um commit com dezenas de arquivos, em especial se esses arquivos trazem mais de uma mudança ou correção. Devemos evitar isso, pois fica difícil rastrear, entender e revisar o que foi feito no commit. Prefira fazer commits pequenos e pontuais de algo que está terminado, algo que funciona e que não traga muitas alterações de uma vez só.

#### Modelo do commit

##### Commit Simples

Caso o commit trate de uma questão simples, faça o commit da seguinte maneira:

```git
git commit -m "#IdIssue - Mensagem"
```

##### Commit Complexo

Devido à importância, caso o commit trate de algo mais complexo, use o seguinte template para padronização, substituindo o texto dos comentários '# não será lido no commit':

``` 
#Id-da-Issue - Título do commit: comece com  letra maiúscula, objetivo
#Não mais que 50 chars,Essa linha possui   50                   #
#Pular linha

# Corpo: Explique o quê e porque
# Não mais que 72 caracteres (essa linha possui)                                                                             #

#OPCIONAL: Caso haja, inclua essa linha de co-autores do seu commit para cada contribuidor.
#Pular 2 linhas


# Co-authored-by: nome1 <usuário1@users.noreply.github.com>
# Co-authored-by: nome2 <usuário2@users.noreply.github.com>
#Pular linha
```

## 4. Políticas de padronização dos arquivos

Todos os arquivos devem seguir o seguinte modelo e regras:

Modelo: texto1_politicas_organizacao.md

- Letra minúscula em todo nome do arquivo.
- A separação entre palavras deve ser feita através do underline. Ex.: "politicas_artefatos.md"
- Não há separação entre palavras e números. Ex.: "sprint1.md".

Obs.: Há exceções quanto a arquivos especiais que necessitarem de uma nomeclatura diferente. Ex.: "README.md".

## 5. Políticas de padronização das pastas

Todos as pastas devem seguir o seguinte modelo e regras:

Modelo: pasta1_politicas

- Se possível, dê preferência para nomear pastas com somente uma palavra (opcional).
- Para evitar repetição, escolha outro nome, caso já haja uma pasta com o mesmo.
- Letra minúscula em todo nome da pasta.
- A separação entre palavras deve ser feita através do underline. Ex.: "politicas_artefatos"
- Não há separação entre palavras e números. Ex.: "sprint1".

## 6. Organização do repositório

- Imagens na pasta assets, organizadas em subpastas com o nome do artefato em que está presente.
- Os artefatos devem estar cada um em sua subpasta na pasta de sua entrega, a subpasta do artefato deve ser o mesmo do artefato principal. Ex: O artefato tap deve ficar na subpasta tap na pasta base
- Adicionar os artefatos concluídos no arquivo sidebar.md para que estejam presentes no GitPages do projeto.
- Pastas, subpastas e arquivos relacionados as sprints só devem ser alterados com conteúdos condizentes a própria.
- Quadro de versionamento deve ser adicionado ao final do artefato. A versão será incrementada em "0.1" em cada alteração. Além disso, deve-se utilizar apenas o primeiro nome e um sobrenome.

## Referências

> VAMOS CUIDAR 2020-1. Políticas. Disponível em: <https://fga-eps-mds.github.io/2020.1-VC_Usuario/#/docs/Policies>

> CONVENTIONAL COMMITS. Conventional Commits. Disponível em: <https://www.conventionalcommits.org/en/v1.0.0/>

> EQUIPE ALECTRION 2023-1. Como contribuir. Disponível em: <https://fga-eps-mds.github.io/2023-1-Alectrion-DOC/documentacao/guiaDeContribuicao/>

> EQUIPE DNIT 2023-1. Guia de contribuição. Disponível em: <https://fga-eps-mds.github.io/2023-1-Dnit-DOC/GuiaDeContribuicao/guiaDeContribuicao/>
