# ERC721
> EIP-721: Non-Fungible Token Standard

Esta es la implementación de referencia completa del estándar de token no fungible [ERC-721](https://github-com.translate.goog/ethereum/EIPs/blob/master/EIPS/eip-721.md?_x_tr_sl=auto&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=wapp) para las cadenas de bloques Ethereum y Wanchain. También es compatible con otras cadenas compatibles con EVM como Binance Smart Chain (BSC), Avalanche (AVAX), etc. Este es un proyecto de código abierto, completo con pruebas [Hardhat](https://hardhat.org/).

El propósito de esta implementación es proporcionar un buen punto de partida para cualquier persona que quiera usar y desarrollar tokens no fungibles en las cadenas de bloques Ethereum y Wanchain. En lugar de volver a implementar el ERC-721 usted mismo, puede usar este código que ha pasado por múltiples auditorías y esperamos que la comunidad lo use ampliamente en el futuro. Tenga en cuenta que esta implementación es más restrictiva que el estándar ERC-721, ya que no admite llamadas a  la función <payable>. Sin embargo, eres libre de agregarlo tú mismo.
  
Si estás buscando una implmenetación de ERC-721 más rica en funciones y avanzada, consulta el [0xcer Framework](https://github.com/0xcert/framework).
  
## Estructura
  
Todos los contratos y pruebas están en la carpeta [src](#). Hay múltiples implementaciones y puedes seleccionar entre:
- [`nf-token.sol`](src/contracts/tokens/nf-token.sol):Esta es la implementación básica del token ERC-721 (con soporte para ERC-165).
- [`nf-token-metadata.sol`](src/contracts/tokens/nf-token-metadata.sol):Este implementa funciones de metadatos ERC-721 opcionales para el contrato de token. Implementa un nombre de token, un símbolo y un URI distinto que apunta a un archivo de metadatos JSON ERC-721 expuesto publicamente.
- [`nf-token.enumerable.sol`](src/contracts/tokens/nf-token-enumerable.sol): Este implementa el soporte ERC-721 opcional para la enumeración. Es util si quieres saber la oferta total de tokens, consultar un token por índice, etc.
  
Otros archivos en los directorios [token](#) o [utils](#) nombrados `erc*.sol` son interfaces y definen los estándares respectivos.
  
Los contratos simulados que muestran el uso básico del contrato están disponibles en la carpeta [simulacros](src/contracts/mocks).
  
También hay simulacros de pruebas que se pueden ver aquí. Estos estan hechos específicamente para probar diferentes casos y comportamientos extremos y NO deben usarse como referencia para la implementación.

## Requisitos
  - NodeJS 12+ compatible
  - Windows, Linux o MacOS
 
## Instalación
  ### nmp
  *Éste es el método de instalación recomendado si se desea utilizar el paquete en un proyecto Javascript.*
  
  Este proyecto se publica como un [módulo nmp](https://www.npmjs.com/package/@nibbstack/erc721). Debes instalarlo utilizando el comando `nmp`:
  
  ```
  $ nmp install @nibbstack/erc721@2.6.1
  ```
  
  ### Fuente
  *Este es el método de instalación recomendado si desea mejorar el  proyecto `nibbstack/erc721`
  
  Clone este repositorio e instale las dependencias `nmp` requeridas:
  
  ```
  $ git clone git@github.com:nibbstack/erc721.git
  $ cd ethereum-erc721
  $ nmp install
  ```
  Asegúrate de que todo se ha configurado correctamente:
  
  ```
  $ nmp run test
  ```
  
  ## Uso
  
  ### nmp
  
  Para interactuar con los contratos de este paquete dentro del código JavaScript, simplemente necesita solicitar los archivos ``` .json ``` de este paquete:
  
  ```js
  const contract = require("@nibbstack/erc721/abi/NFTokenEnumerable.json");
  console.log(contract);
  ```
  
  ### Remix IDE (Ethereum only)
  
  Puede implementar rápidamente un contrato con esta biblioteca utilizando [Remix IDE](https://remix.ethereum.org/). Aquí hay un ejemplo.
  
  Has creado y posees obras de arte únicas de vidrio soplado (cada una con un número de serie/lote) que le gustaría vender utilizando la red principal de Ethereum o 
  Wanchain. Venderás tokens no fungibles y los compradores podrán intercambiarlos por otras personas. Una ficha por obra de arte. Te comprometes con cualquiera que 
  tenga estos tokens a que puedan canjearlos y tomar posesión física de la obra.
  
  Para ello, simplemente pega el código a continuación en Remix e implementa el contrato inteligente.
  "Acuñarás" una ficha por cada nueva obra de arte que quieras ver. Luego, "quemarás" esa ficha cuando entregues la posesión física de esa pieza.
  
  
  [follow here](https://github.com/nibbstack/erc721)
  
