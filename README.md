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
  
  ```solidity
  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/nibbstack/erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/nibbstack/erc721/src/contracts/ownership/ownable.sol";

/**
 * @dev Este es un ejemplo de implementación de contrato de token NFT con extensión de metadatos.
 */
contract MyArtSale is
  NFTokenMetadata,
  Ownable
{

  /**
   * @dev Constructor del contrato. Establece la sesión de metadatos `nombre` y `símbolo`.
   */
  constructor()
  {
    nftName = "Frank's Art Sale";
    nftSymbol = "FAS";
  }

  /**
   * @dev Acuña un nuevo NFT.
   * @param _to La dirección que poseerá el NFT acuñado.
   * @param _tokenId del NFT a ser acuñado por el msg.sender.
   * @param _uri Cadena que representa RFC 3986 URI.
   */
  function mint(
    address _to,
    uint256 _tokenId,
    string calldata _uri
  )
    external
    onlyOwner
  {
    super._mint(_to, _tokenId);
    super._setTokenUri(_tokenId, _uri);
  }

}
  ```
  * Debes comunicarte con un abogado antes de realizar una subasta o vender cualquier cosa. Específicamente, las leyes para las subastas varían mucho según las 
  distintas jurisdiscciones. Esta aplicación se proporciona solo como un ejemplo de la tecnología y no es un cosejo legal.*
  ## Validación
  
  Puedes verificar la validez del contrato inteligente, la corrección de implementación y las funciones admitidas del contrato inteligente respectivo utilizando el 
  validador en línea: https://erc721validator.org/.

  ## Realización de Pruebas 
  
  ### Ethereum - red de prubas de Ropsten
  
  Ya implementamos algunos contratos en la red [Ropsten](https://ropsten.etherscan.io/). Puedes jugar con ellos AHORA MISMO. No es necesario instalar software. En 
  esta versión de prueba del contrato, cualquiera puede <mint> o <burn> tokens, así que no lo uses para nada importante.
  

| Contrato                                                     | Dirección del token | Hash de Transacción |
| ------------------------------------------------------------ | ------------- | ---------------- |
| [`nf-token.sol`](src/contracts/tokens/nf-token.sol)          | [0xd8bbf8ceb445de814fb47547436b3cfeecadd4ec](https://ropsten.etherscan.io/address/0xd8bbf8ceb445de814fb47547436b3cfeecadd4ec)          | [0xaac94c9ce15f5e437bd452eb1847a1d03a923730824743e1f37b471db0f16f0c](https://ropsten.etherscan.io/tx/0xaac94c9ce15f5e437bd452eb1847a1d03a923730824743e1f37b471db0f16f0c)             |
| [`nf-token-metadata.sol`](src/contracts/tokens/nf-token-metadata.sol) | [0x5c007a1d8051dfda60b3692008b9e10731b67fde](https://ropsten.etherscan.io/address/0x5c007a1d8051dfda60b3692008b9e10731b67fde)          | [0x1e702503aff40ea44aa4d77801464fd90a018b7b9bad670500a6e2b3cc281d3f](https://ropsten.etherscan.io/tx/0x1e702503aff40ea44aa4d77801464fd90a018b7b9bad670500a6e2b3cc281d3f)             |
| [`nf-token-enumerable.sol`](src/contracts/tokens/nf-token-enumerable.sol) | [0x130dc43898eb2a52c9d11043a581ce4414487ed0](https://ropsten.etherscan.io/address/0x130dc43898eb2a52c9d11043a581ce4414487ed0)          | [0x8df4c9b73d43c2b255a4038eec960ca12dae9ba62709894f0d85dc90d3938280](https://ropsten.etherscan.io/tx/0x8df4c9b73d43c2b255a4038eec960ca12dae9ba62709894f0d85dc90d3938280)             |
  
  ### Wanchain - testnet
  
  Ya hemos implementado algunos contratos en la red [testnet](http://testnet.wanscan.org/). Puedes jugar con ellos AHORA MISMO.No es necesario instalar software. En  
  esta versión de prueba del contrato, cualquiera puede <mint> o <burn> tokens, así que no los uses para nada importante. 
  
  | Contract                                                     | Token address | Transaction hash |
| ------------------------------------------------------------ | ------------- | ---------------- |
| [`nf-token.sol`](src/contracts/tokens/nf-token.sol)          | [0x6D0eb4304026116b2A7bff3f46E9D2f320df47D9](http://testnet.wanscan.org/address/0x6D0eb4304026116b2A7bff3f46E9D2f320df47D9)          | [0x9ba7a172a50fc70433e29cfdc4fba51c37d84c8a6766686a9cfb975125196c3d](http://testnet.wanscan.org/tx/0x9ba7a172a50fc70433e29cfdc4fba51c37d84c8a6766686a9cfb975125196c3d)             |
| [`nf-token-metadata.sol`](src/contracts/tokens/nf-token-metadata.sol) | [0xF0a3852BbFC67ba9936E661fE092C93804bf1c81](http://testnet.wanscan.org/address/0xF0a3852BbFC67ba9936E661fE092C93804bf1c81)          | [0x338ca779405d39c0e0f403b01679b22603c745828211b5b2ea319affbc3e181b](http://testnet.wanscan.org/tx/0x338ca779405d39c0e0f403b01679b22603c745828211b5b2ea319affbc3e181b)             |
| [`nf-token-enumerable.sol`](src/contracts/tokens/nf-token-enumerable.sol) | [0x539d2CcBDc3Fc5D709b9d0f77CaE6a82e2fec1F3](http://testnet.wanscan.org/address/0x539d2CcBDc3Fc5D709b9d0f77CaE6a82e2fec1F3)          | [0x755886c9a9a53189550be162410b2ae2de6fc62f6791bf38599a078daf265580](http://testnet.wanscan.org/tx/0x755886c9a9a53189550be162410b2ae2de6fc62f6791bf38599a078daf265580)             |

  ### Contribución
  
  Consulta [CONTRIBUIR.md](./contributing.md) para saber cómo contribuir.
  
  ## Recompensa de errores
  
  Usted es alguien que lee la documentación de los contratos inteligentes y comprende cómo funciona la implementación de referencia del token ERC-721. Así que tienes 
  habilidades únicas y tu tiempo es valioso. Le pagaremos por sus contribuciones a este proyecto en forma de informes de errores.
  
  Si tu proyecto depende de ERC-721 o si deseas ayudar a a mejorar la seguridad de este proyecto, puedes recibir una recompensa. Esto significa que se comprometerá a 
  pagar a los a los investigadores que demuestren un problema. Contacta con [bounty@nibbstack.com](mailto:bounty@nibbstack.com) si estás interesado.
  
  Lee el [programa de recompensas por errores](./BUG_BOUNTY.md) completo .
  
  [follow here](https://github.com/nibbstack/erc721)
  
  ## Licencia
  
  Consulta la [LICENCIA](./LICENCIA) para obtener más detalles.
  
