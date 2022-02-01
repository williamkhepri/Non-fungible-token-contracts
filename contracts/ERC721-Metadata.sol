// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/**
 * @dev Extensión de metadatos opcional para el estándar de token no fungible ERC-721.
 * Consulte https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
 */
interface ERC721Metadata
{
/**
 * @dev Devuelve un nombre descriptivo para una colección de NFT en este contrato.
 * @return _name Nombre que representa.
 */

function name()
  external
  view
  returns (string memory _name);
   
/**
 * @dev Devuelve un nombre abreviado para una colección de NFT en este contrato.
 * @return _symbol Símbolo que representa.
 */

function symbol()
  external
  view
  returns (string memory _symbol);

/**
 * @dev Devuelve un identificador uniforme de recursos (URI) distinto para un activo determinado. Tira si
 * `_tokenId` no es un NFT válido. Los URI se definen en RFC3986. El URI puede apuntar a un archivo JSON
 * que se ajuste al "Esquema JSON de metadatos ERC721".
 * @return URI de _tokenId.
 */
   
function tokenURI(uint256 _tokenId)
  external
  view
  returns (string memory);
}
