// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Corregir imports 
/*Falta traducir todo el código */

import "./erc721.sol";
import "./erc721-token-receiver.sol";
import "../utils/supports-interface.sol";
import "../utils/address-utils.sol";

/**
 * @dev Implementación del estándar de Token no fungible ERC-721.
 */
contract NFToken is
  ERC721,
  SupportsInterface
{
  using AddressUtils for address;

  /**
   * @dev Lista de códigos de mensajes de reversión. La dApp implementadora debe encargarse de mostrar el mensaje correcto.
 * Basado en los códigos de error del framework 0xcert.
   */
  string constant ZERO_ADDRESS = "003001";
  string constant NOT_VALID_NFT = "003002";
  string constant NOT_OWNER_OR_OPERATOR = "003003";
  string constant NOT_OWNER_APPROVED_OR_OPERATOR = "003004";
  string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
  string constant NFT_ALREADY_EXISTS = "003006";
  string constant NOT_OWNER = "003007";
  string constant IS_OWNER = "003008";

  /**
   * @dev Valor mágico de un contrato inteligente que puede recibir NFT.
   * Igual a: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
   */
  bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;

  /**
   * @dev Un mapeo del ID de NFT a la dirección que lo posee.
   */
  mapping (uint256 => address) internal idToOwner;

  /**
   * @dev Mapeo desde el ID de NFT a la dirección autorizada.
   */
  mapping (uint256 => address) internal idToApproval;

   /**
   * @dev Mapeo desde la dirección del propietario hasta el recurso de sus tokens.
   */
  mapping (address => uint256) private ownerToNFTokenCount;

  /**
   * @dev Mapeo desde la dirección del propietario hasta el mapeo de las direcciones del operador.
   */
  mapping (address => mapping (address => bool)) internal ownerToOperators;

  /**
   * @dev Garantiza que el remitente del msg es un propietario u operador del NFT dado.
   * @param _tokenId ID del NFT a validar.
   */
  modifier canOperate(
    uint256 _tokenId
  )
  {
    address tokenOwner = idToOwner[_tokenId];
    require(
      tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
      NOT_OWNER_OR_OPERATOR
    );
    _;
  }

  /**
   * @dev Garantiza que el remitente del mensaje (msg.sender) está autorizado a transferir NFT.
   * @param _tokenId ID del NFT a transferir.
   */
  modifier canTransfer(
    uint256 _tokenId
  )
  {
    address tokenOwner = idToOwner[_tokenId];
    require(
      tokenOwner == msg.sender
      || idToApproval[_tokenId] == msg.sender
      || ownerToOperators[tokenOwner][msg.sender],
      NOT_OWNER_APPROVED_OR_OPERATOR
    );
    _;
  }

  /**
   * @dev Garantiza que _tokenId es un token válido.
   * @param _tokenId ID del NFT a validar.
   */
  modifier validNFToken(
    uint256 _tokenId
  )
  {
    require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
    _;
  }

  /**
   * @dev Constructor del contrato.
   */
  constructor()
  {
    supportedInterfaces[0x80ac58cd] = true; // ERC721
  }

  /**
   * @notice Lanza a menos que un 'msg.sender' sea el propietario actual, un operador
   * autorizado, o la dirección aprobada para este NFT. Lanza si '_from' no es el propietario actual. Lanza si '_to' es
   * la dirección cero. Lanza si `_tokenId` no es un NFT válido. Cuando se completa la transferencia, esta
   * comprueba si `_to` es un smart contract (code size > 0). Si lo es, llama a 
   * `onERC721Received` on `_to` y lanza si el valor de retorno no es
   * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
   * @dev Transfiere la propiedad de un NFT de una dirección a otra dirección. Esta función puede
   * ser modificada para que sea pagable.
   * @param _from El propietario actual del NFT.
   * @param _to El nuevo propietario.
   * @param _tokenId El NFT a tranferir.
   * @param _data Datos adicionlaes sin formato especificado, enviados en la llamada a `_to`.
   */
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    override
  {
    _safeTransferFrom(_from, _to, _tokenId, _data);
  }

  /**
   * @notice Esto funciona de forma idéntica a la otra función con un parámetro de datos extra, excepto que esta
   * envía datos a "".
   * @dev Transfiere la propiedad de un NFT de una dirección a otra. Esta función puede
   * cambiarse a pagable.
   * @param _from El propietario actual del NFT.
   * @param _to El nuevo propietario.
   * @param _tokenId El NFT a tranferir.
   */
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    override
  {
    _safeTransferFrom(_from, _to, _tokenId, "");
  }

  /**
   * @notice La persona que llama es responsable de confirmar que '_to' es capaz de recibir NFTs o de lo contrario
   * pueden perderse permanentemente.
   * @dev Lanza a menos que `msg.sender` sea el propietario actual, un operador autorizado, o la dirección aprobada
   * para este NFT. Lanza si `_from` no es el propietario actual. Lanza si `_to` es la dirección cero.
   * Lanza si `_tokenId` no es un NFT válido. Esta función puede ser modificada para que sea pagable.
   * @param _from El propietario actual del NFT.
   * @param _to El nuevo propietario.
   * @param _tokenId El NFT a transferir.
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    override
    canTransfer(_tokenId)
    validNFToken(_tokenId)
  {
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == _from, NOT_OWNER);
    require(_to != address(0), ZERO_ADDRESS);

    _transfer(_to, _tokenId);
  }

  /**
   * @notice La dirección cero indica que no hay ninguna dirección aprobada.
   * Lanza a menos que 'msg.sender' sea el propietario actual del NFT, o un operador autorizado del propietario actual.
   * @dev Establece o reafirma la dirección aprobada para un NFT. Esta función puede ser modificada para que sea pagable.
   * @param _approved Dirección a aprobar para el ID de NFT dado.
   * @param _tokenId ID del token a aprobar.
   */
  function approve(
    address _approved,
    uint256 _tokenId
  )
    external
    override
    canOperate(_tokenId)
    validNFToken(_tokenId)
  {
    address tokenOwner = idToOwner[_tokenId];
    require(_approved != tokenOwner, IS_OWNER);

    idToApproval[_tokenId] = _approved;
    emit Approval(tokenOwner, _approved, _tokenId);
  }

  /**
   * @notice Funciona incluso si el remitente no posee ningún token en ese momento.
   * @dev Activa o desactiva la aprobación para que un tercero ("operador") gestione todos los
   * `msg.sender`'s assets. También emite el evento ApprovalForAll.
   * @param _operator Dirección a añadir al conjunto de operadores autorizados.
   * @param _approved Verdadero si el operador esta aprobado, falso para revocar la aprobación.
   */
  function setApprovalForAll(
    address _operator,
    bool _approved
  )
    external
    override
  {
    ownerToOperators[msg.sender][_operator] = _approved;
    emit ApprovalForAll(msg.sender, _operator, _approved);
  }

  /**
   * @dev Devuelve el número de NFTs propiedad de '_owner'. Los NFTs asignados a la dirección cero se consideran inválidos,
   * and this function throws for queries about the zero address.
   * @param _owner Address for whom to query the balance.
   * @return Balance of _owner.
   */
  function balanceOf(
    address _owner
  )
    external
    override
    view
    returns (uint256)
  {
    require(_owner != address(0), ZERO_ADDRESS);
    return _getOwnerNFTCount(_owner);
  }

  /**
   * @dev Returns the address of the owner of the NFT. NFTs assigned to the zero address are
   * considered invalid, and queries about them do throw.
   * @param _tokenId The identifier for an NFT.
   * @return _owner Address of _tokenId owner.
   */
  function ownerOf(
    uint256 _tokenId
  )
    external
    override
    view
    returns (address _owner)
  {
    _owner = idToOwner[_tokenId];
    require(_owner != address(0), NOT_VALID_NFT);
  }

  /**
   * @notice Throws if `_tokenId` is not a valid NFT.
   * @dev Get the approved address for a single NFT.
   * @param _tokenId ID of the NFT to query the approval of.
   * @return Address that _tokenId is approved for.
   */
  function getApproved(
    uint256 _tokenId
  )
    external
    override
    view
    validNFToken(_tokenId)
    returns (address)
  {
    return idToApproval[_tokenId];
  }

  /**
   * @dev Checks if `_operator` is an approved operator for `_owner`.
   * @param _owner The address that owns the NFTs.
   * @param _operator The address that acts on behalf of the owner.
   * @return True if approved for all, false otherwise.
   */
  function isApprovedForAll(
    address _owner,
    address _operator
  )
    external
    override
    view
    returns (bool)
  {
    return ownerToOperators[_owner][_operator];
  }

  /**
   * @notice Does NO checks.
   * @dev Actually performs the transfer.
   * @param _to Address of a new owner.
   * @param _tokenId The NFT that is being transferred.
   */
  function _transfer(
    address _to,
    uint256 _tokenId
  )
    internal
    virtual
  {
    address from = idToOwner[_tokenId];
    _clearApproval(_tokenId);

    _removeNFToken(from, _tokenId);
    _addNFToken(_to, _tokenId);

    emit Transfer(from, _to, _tokenId);
  }

  /**
   * @notice This is an internal function which should be called from user-implemented external
   * mint function. Its purpose is to show and properly initialize data structures when using this
   * implementation.
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   * @param _tokenId of the NFT to be minted by the msg.sender.
   */
  function _mint(
    address _to,
    uint256 _tokenId
  )
    internal
    virtual
  {
    require(_to != address(0), ZERO_ADDRESS);
    require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);

    _addNFToken(_to, _tokenId);

    emit Transfer(address(0), _to, _tokenId);
  }

  /**
   * @notice This is an internal function which should be called from user-implemented external burn
   * function. Its purpose is to show and properly initialize data structures when using this
   * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
   * NFT.
   * @dev Burns a NFT.
   * @param _tokenId ID of the NFT to be burned.
   */
  function _burn(
    uint256 _tokenId
  )
    internal
    virtual
    validNFToken(_tokenId)
  {
    address tokenOwner = idToOwner[_tokenId];
    _clearApproval(_tokenId);
    _removeNFToken(tokenOwner, _tokenId);
    emit Transfer(tokenOwner, address(0), _tokenId);
  }

  /**
   * @notice Use and override this function with caution. Wrong usage can have serious consequences.
   * @dev Removes a NFT from owner.
   * @param _from Address from which we want to remove the NFT.
   * @param _tokenId Which NFT we want to remove.
   */
  function _removeNFToken(
    address _from,
    uint256 _tokenId
  )
    internal
    virtual
  {
    require(idToOwner[_tokenId] == _from, NOT_OWNER);
    ownerToNFTokenCount[_from] -= 1;
    delete idToOwner[_tokenId];
  }

  /**
   * @notice Use and override this function with caution. Wrong usage can have serious consequences.
   * @dev Assigns a new NFT to owner.
   * @param _to Address to which we want to add the NFT.
   * @param _tokenId Which NFT we want to add.
   */
  function _addNFToken(
    address _to,
    uint256 _tokenId
  )
    internal
    virtual
  {
    require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);

    idToOwner[_tokenId] = _to;
    ownerToNFTokenCount[_to] += 1;
  }

  /**
   * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
   * extension to remove double storage (gas optimization) of owner NFT count.
   * @param _owner Address for whom to query the count.
   * @return Number of _owner NFTs.
   */
  function _getOwnerNFTCount(
    address _owner
  )
    internal
    virtual
    view
    returns (uint256)
  {
    return ownerToNFTokenCount[_owner];
  }

  /**
   * @dev Actually perform the safeTransferFrom.
   * @param _from The current owner of the NFT.
   * @param _to The new owner.
   * @param _tokenId The NFT to transfer.
   * @param _data Additional data with no specified format, sent in call to `_to`.
   */
  function _safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
  )
    private
    canTransfer(_tokenId)
    validNFToken(_tokenId)
  {
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == _from, NOT_OWNER);
    require(_to != address(0), ZERO_ADDRESS);

    _transfer(_to, _tokenId);

    if (_to.isContract())
    {
      bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
      require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
    }
  }

  /**
   * @dev Clears the current approval of a given NFT ID.
   * @param _tokenId ID of the NFT to be transferred.
   */
  function _clearApproval(
    uint256 _tokenId
  )
    private
  {
    delete idToApproval[_tokenId];
  }

}
