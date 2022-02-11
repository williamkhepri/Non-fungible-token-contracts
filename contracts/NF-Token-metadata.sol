// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./nf-token.sol";
import "./erc721-metadata.sol";

/**
 * @dev Implementación de metadatos opcionales para el estándard de token no fungible ERC-721.
 */
contract NFTokenMetadata is
  NFToken,
  ERC721Metadata
{

  /**
   * @dev Un nombre descriptivo para la colección de NFT.
   */
  string internal nftName;

  /**
   * @dev Un nombre abreviado para NFTokens.
   */
  string internal nftSymbol;

  /**
   * @dev Mapeo de NFT ID a metadatos uri.
   */
  mapping (uint256 => string) internal idToUri;

  /**
   * @notice Al implementar este contrato, no olvide configurar nftName y nftSymbol.
   * @dev Constructor del contrato.
   */
  constructor()
  {
    supportedInterfaces[0x5b5e139f] = true; // ERC721Metadatos
  }

  /**
   * @dev Devuelve un nombre descriptivo para una colección de NFTokens.
   * @return _name Representing name.
   */
  function name()
    external
    override
    view
    returns (string memory _name)
  {
    _name = nftName;
  }

  /**
   * @dev Devuelve un nombre abreviado para NFToken.
   * @return _symbol Simbolo que representa.
   */
  function symbol()
    external
    override
    view
    returns (string memory _symbol)
  {
    _symbol = nftSymbol;
  }

  /**
   * @dev Un URI distinto (RFC 3986) para un NFT dado.
   * @param _tokenId Id para el que queremos la uri.
   * @return URI del _tokenId.
   */
  function tokenURI(
    uint256 _tokenId
  )
    external
    override
    view
    validNFToken(_tokenId)
    returns (string memory)
  {
    return _tokenURI(_tokenId);
  }

  /**
   * @notice Esta es una función interna que se puede anular si se desea implementar una forma diferente
   * de generar un token URI.
   * @param _tokenId Id para el que queremos URI.
   * @return URI del _tokenId.
   */
  function _tokenURI(
    uint256 _tokenId
  )
    internal
    virtual
    view
    returns (string memory)
  {
    return idToUri[_tokenId];
  }

  /**
   * @notice Esta es una función interna que debe llamarse desde una función externa implementada por el usuario.
   * función de grabación. Su propósito es monstrar e inicializar adecuadamente las estrucuras de datos al usar esta
   * implementación. Además, tenga en cuenta que esta implementación de quemado le permite al minter volver a acuñar un quemado NFT.
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

    delete idToUri[_tokenId];
  }

  /**
   * @notice Esta esuna función interna que debe llamarse desde una función externa implementada por el usuario.
   * Fucnión. Su propósito es mostrar e inicializar adecuadamente las estructuras de datos al usar esta implementación.
   * @dev Establece un URI distinto (RFC 3986) para un ID de NFT dado.
   * @param _tokenId Id para el que queremos URI.
   * @param _uri String que representa RFC 3986 URI.
   */
  function _setTokenUri(
    uint256 _tokenId,
    string memory _uri
  )
    internal
    validNFToken(_tokenId)
  {
    idToUri[_tokenId] = _uri;
  }

}
