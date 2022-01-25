// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Extensión de enumeración opcional para el estándar de token no fungible ERC-721.
 * Consulte https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
 */
interface ERC721Enumerable
{

  /**
   * @dev Devuelve un recuento de NFT válidos rastreados por este contrato, donde cada uno de ellos tiene 
   * un propietario y consultable distinto de la dirección cero.
   * @return Suministro total de NFT.
   */
  function totalSupply()
    external
    view
    returns (uint256);

  /**
   * @dev Devuelve el identificador del token para el '_index' NFT. No se especifica el orden de clasificación.
   * @param _index Un contador menor que `totalSupply()`.
   * @return Token id.
   */
  function tokenByIndex(
    uint256 _index
  )
    external
    view
    returns (uint256);

  /**
   * @dev Devuelve el identificador del token para el '_index' NFT asignado a '_owner'. orden de clasificación es
   * no especificado. Lanza si `_index` >= `balanceOf(_owner)` o si `_owner` es la dirección cero,
   * que representa NFT no válidos.
   * @param _owner Una dirección en la que estamos interesados en NFT de su propiedad.
   * @param _index Un contador menor que `balanceOf(_owner)`.
   * @return Token id.
   */
  function tokenOfOwnerByIndex(
    address _owner,
    uint256 _index
  )
    external
    view
    returns (uint256);

}
