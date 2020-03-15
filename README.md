# Roça - Roça o Insumo nela que ela Brota!
  Vindo do maravilhoso HackatonAgro da Faculdade LaSalle, evento de 54 horas para desenvolver uma solução para o agronegócio, nós somos a  equipe ROÇA!

# Inspiração e Problema
  A Troca de informações no campo é um problema que afeta diretamente o produtor, com baixa conectividade o tempo para se obter informações e controle se torna alto, assim como a correção de um possível problema.
  A Roça vem para otimizar a centralização da informação do campo, dando ao produtor, desde pequeno até grandes, a gestão das operações que acontecem no talhão, criando indicadores de produtividade.
  Também pensamos na operação direta na lavoura, com um APP que mostra ao operador quais operações ele precisa realizar, assim como informações adicionados coletadas, como velocidade média, tempo de operação e distância percorrida.
  
# Tecnologias Utilizadas

Quatro Aplicações foram desenvolvidas, sendo elas: Servidor de Autenticação, Servidor de Aplicação, Aplicação Mobile e Aplicação Web.

#### Servidor de Autenticação

- [RadStudio 10.3 Community Edition](https://www.embarcadero.com/br/products/delphi/starter/free-download).
- [FrameWork Horse - Hashload](https://github.com/HashLoad/horse).

#### Servidor de Aplicação

- [RadStudio 10.3 Community Edition](https://www.embarcadero.com/br/products/delphi/starter/free-download).
- [FrameWork Horse - Hashload](https://github.com/HashLoad/horse).
- [Firebird 2.5](https://firebirdsql.org/).

#### Aplicativo Mobile

- [Ionic](https://ionicframework.com/).
- [Angular](https://angularjs.org/).
- [Ionic Plugins](https://ionicframework.com/docs/native/) - GeoLocation, NativeStorage.
- [Cordova](https://cordova.apache.org/)

#### Aplicação WEB

- [Quazar](https://quasar.dev/).
- [Node.Js](https://www.npmjs.com/).
- [Vue.Js](https://vuejs.org/).

# Funcionalidades Cliente WEB
- Lançamento do Planejamento da Safra
- Lançamento das Atividades e Operações do Talhão - Receituário Agronômico
- Acompanhamento das atividades e histórico do Talhão

# Funcionalidades Cliente APP
- Lista das Operações executadas por operador
- Registro do Tempo, Distância e Velocidade Média

# Métodos Servidor
#### Servidor Aplicação
- *GET* cultura
- *GET* operacao
- *GET* insumos
- *GET* tarefa
- *GET* safra_atual

- *POST* variedade
- *POST* atividade
- *POST* sementes
- *POST* talhoes
- *POST* planejamento
- *POST* tarefa
- *POST* importado
- *POST* resumo_talhao
= *POST* detalhar_talhao

- *PUT* tarefa

#### Servidor Autenticação
- *POST* auth
