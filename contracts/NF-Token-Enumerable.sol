// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NF-Token.sol";
import "./ERC721-Enumerable.sol";

/**
 * @dev Implementación de enumeración opcional para el estándard de Token no fungible ERC-721.
 */
contract NFTokenEnumerable is
  NFToken,
  ERC721Enumerable
{

  /**
   * @dev Lista de códigos de mensajes de reversión. La implementación de dApp debería manejar mostrar el mensaje correcto.
   * Basado en códigos de error del Framework 0xcert.
   */
  string constant INVALID_INDEX = "005007";

  /**
   * @dev Array de todas las IDs de NFT.
   */
  uint256[] internal tokens;

  /**
   * @dev Mapeo de la ID del Token a su índice en el Array de indices globales.
   */
  mapping(uint256 => uint256) internal idToIndex;

  /**
   * @dev Asignación del propietario a la lista de ID de NFT de propiedad.
   */
  mapping(address => uint256[]) internal ownerToIds;

  /**
   * @dev Mapeo de NFT ID a su índice en la lista de tokens de propietario.
   */
  mapping(uint256 => uint256) internal idToOwnerIndex;

  /**
   * @dev Constructor del contrato.
   */
  constructor()
  {
    supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
  }

  /**
   * @dev Devuelve el recuento de todos los NFToken existentes.
   * @return Oferta total de NFTs.
   */
  function totalSupply()
    external
    override
    view
    returns (uint256)
  {
    return tokens.length;
  }

  /**
   * @dev Devuelve ID de NFT por su índice.
   * @param _index Un contador menor que `totalSupply()`.
   * @return id del Token.
   */
  function tokenByIndex(
    uint256 _index
  )
    external
    override
    view
    returns (uint256)
  {
    require(_index < tokens.length, INVALID_INDEX);
    return tokens[_index];
  }

  /**
   * @dev devuelve el n-ésimo ID de NFT de una lista de tokens del propietario.
   * @param _owner Dirección del propietario del Token.
   * @param _index Número de índice que representa el token n en la lista de tokens del propietario.
   * @return Id del Token.
   */
  function tokenOfOwnerByIndex(
    address _owner,
    uint256 _index
  )
    external
    override
    view
    returns (uint256)
  {
    require(_index < ownerToIds[_owner].length, INVALID_INDEX);
    return ownerToIds[_owner][_index];
  }

  /**
   * @notice Esta es una función interna que debe llamarse desde una función externa implementada por el usuario. 
   * mint function. Su propósito es mostrar e inicializar adecuadamente las estructuras de datos al usar esta
   * implementación.
   * @dev Acuña un nuevo NFT.
   * @param _to La dirección que poseerá el NFT acuñado.
   * @param _tokenId del NFT a ser acuñado por el msg.sender.
   */
  function _mint(
    address _to,
    uint256 _tokenId
  )
    internal
    override
    virtual
  {
    super._mint(_to, _tokenId);
    tokens.push(_tokenId);
    idToIndex[_tokenId] = tokens.length - 1;
  }

  /**
   * @notice Esta es una función interna que debe llamarse desde una función externa implementada por el usuario.
   * Función de grabación. Su propósito es mostrar e inicializar adecuadamente las estructuras de datos al usar esta
   * implementación. Además, tenga en cuenta que esta implementación de quemado le permite al minter volver a acuñar un NFT.
   * @dev Quema un NFT.
   * @param _tokenId ID del NFT a grabar.
   */
  function _burn(
    uint256 _tokenId
  )
    internal
    override
    virtual
  {
    super._burn(_tokenId);

    uint256 tokenIndex = idToIndex[_tokenId];
    uint256 lastTokenIndex = tokens.length - 1;
    uint256 lastToken = tokens[lastTokenIndex];

    tokens[tokenIndex] = lastToken;

    tokens.pop();
    // Esto desperdicia gasolina si está quemando la última ficha, pero ahorra un poco de galina si no lo está.
    idToIndex[lastToken] = tokenIndex;
    idToIndex[_tokenId] = 0;
  }

  /**
   * @notice Use y anule esta función con precaución. Un mal uso puede tener graves consecuencias.
   * @dev Elimina un NFT de una dirección.
   * @param _from Dirección de la que queremos quitar el NFT.
   * @param _tokenId Qué NFT queremos eliminar.
   */
  function _removeNFToken(
    address _from,
    uint256 _tokenId
  )
    internal
    override
    virtual
  {
    require(idToOwner[_tokenId] == _from, NOT_OWNER);
    delete idToOwner[_tokenId];

    uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
    uint256 lastTokenIndex = ownerToIds[_from].length - 1;

    if (lastTokenIndex != tokenToRemoveIndex)
    {
      uint256 lastToken = ownerToIds[_from][lastTokenIndex];
      ownerToIds[_from][tokenToRemoveIndex] = lastToken;
      idToOwnerIndex[lastToken] = tokenToRemoveIndex;
    }

    ownerToIds[_from].pop();
  }

  /**
   * @notice Use y anule esta función con precaución. Un mal uso puede tener graves consecuencias
   * @dev Asigna un nuevo NFT a una dirección.
   * @param _to Dirección a la que queremos añadir el NFT.
   * @param _tokenId Qué NFT queremos agregar.
   */
  function _addNFToken(
    address _to,
    uint256 _tokenId
  )
    internal
    override
    virtual
  {
    require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
    idToOwner[_tokenId] = _to;

    ownerToIds[_to].push(_tokenId);
    idToOwnerIndex[_tokenId] = ownerToIds[_to].length - 1;
  }

  /**
   * @dev Helper que obtiene el recuento de NFT del propietario. Esto es necesario para anular extensión enumerable para eliminar el sobre almacenamiento
   * (optimización del gas) del recuento de NFT del propietario.
   * @param _owner Dirección para la que consultar el recuento.
   * @return Número de NFT del propietario.
   */
  function _getOwnerNFTCount(
    address _owner
  )
    internal
    override
    virtual
    view
    returns (uint256)
  {
    return ownerToIds[_owner].length;
  }
}
