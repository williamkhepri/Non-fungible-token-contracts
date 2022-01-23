// SPDK-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
* @dev ERC-721 non-fungible token standard.
* ver https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
* implementar desde https://github.com/nibbstack/erc721/blob/master/src/contracts/tokens/erc721.sol
*/
interface ERC721
{
/*
* Se emite cuando la propiedad de cualquier NFT cambia por cualquier mecanismo. Éste evento se emite cuando los NFT son creados.
* ('from' == 0) y destruidos ('to' == 0). Excepción: durante la creación del contrato, cualquiera puede crear y asignar una cantidad
* de NFT sin emitir Transferencia. En el momento de cualquier transferencia, la dirección aprobada para ese NFT (si corresponde) se restablece a ninguno.
*/
event Transfer(
address indexed _from, 
address indexed _to,
uint256 indexed _tokenId
);

/**
* @dev Esto se emite cuando se cambia o reafirma la dirección aprobada para un NFT. 
* La dirección cero indica que no existe una dirección aprobada. Cuando se emite un evento Transfer, 
* también indica que la dirección aprobada para ese NFT (si corresponde) se reestablece a ninguna.
*/
event Approval(
address indexed _owner, 
address indexed _operator, 
bool _approved
);
/**
* @notice Lanza a menos que 'msg.sender' sea el propietario actual, un operador autorizado o la
* dirección aprobada para este NFT. Lanza si '_from' no es propietario actual. Lanza si '_to' es
* la dirección cero. Lanza si '_tokenId' no es un NFT válido. Cuando se completa la transferencia, esta
* función comprueba si '_to' es un contrato inteligente (tamaño de código > 0). Si es así, llama a 
* 'onERC721Recived' en '_to' y lanza si el valor devuelto no es
* 'bytes4(keccak256("onERC721Recived(dirección, uint256, bytes)"))'.
* @dev Transfiere la propiedad de un NFT de una dirección a otra dirección. Esta función puede ser
* cambiada a pagadero.
* @param _from El propietario actual del NFT.
* @param _to El nuevo dueño.
* @param _tokenId El NFT a transferir.
* @param _data Datos adicionales sin formato especificado, enviados en llamada a '_to'.
*/
function safeTransferFrom(
address _from, 
address _to, 
uint256 _tokenId, 
bytes calldata _data
)
external;

/**
* @notice Esta funciona de manera idéntica a la otra función con un parámetro de datos adicional, excepto que esta función 
* establece los datos a "".
* @dev Transfiere la propiedad de un NFT de una dirección a otra. Esta función puede cambiarse a pagadero.
* @param _from El propietario actual del NFT.
* @param _to El nuevo dueño.
* @param _tokenId El NFT a transferir.
* @param _data Datos adicionales sin formato especificado , enviados en la llamada a '_to'.
*/
function safeTransferFrom(
  address _from, 
  address _to,
  uint256 _tokenId
 )
  external;

/**
 * @notice La persona que llama es responsable de confirmar que '_to' es capaz de recibir NFTs o de lo contrario
 * puede perderse permanentemente.
 * @dev Lanza a menos que 'msg.sender' sea el propietario actual, un operador autorizado o la dirección 
 * aprobada para este NFT. Lanza si '_from' no es el propietario actual. Lanza si '_to' es el cero
 * habla a. Lanza si '_tokenId' no es un NFT válido. Esta función se puede cambiar por la de pago.
 * @param _from El propietario actual del NFT.
 * @param _to El nuevo dueño.
 * @param _tokenId El NFT a transferir.
 */
 function transferFrom(
  address _from, 
  address _to, 
  uint256 _tokenId
 )
  external;
  
 /**
  * @notice La dirección cero indica que no hay ninguna dirección aprobada.
  * Lanza a menos que 'msg.sender' sea el propietario actual del NFT, o un operador autorizado, 
  * o el propietario actual.
  * @param _approved El nuevo controlador NFT aprobado.
  * @dev Establecer o reafirmar la dirección aprobada para un NFT. Esta función puede ser modificada
  * para que sea pagable.
  * @param _tokenId El NFT a aprobar.
  */
   function approve(
    address _approved, 
    uint256 _tokenId
  )
    external;
  
  /**
   * @notice El contrato DEBE permitir múltiples operadores por propietario.
   * @dev Activa o desactiva la aprobación para que un tercero ("operador") gestione todos los
   * `msg.sender`'s assets. También emite el evento ApprovalForAll.
   * @param _operator Dirección a añadir al conjunto de operadores autorizados.
   * @pamam _approved Verdadero si el operador está aprobado, falso para revocar la aprobación.
   */
   function setApprovalForAll(
    address _operator, 
    bool _approved
  )
    external;
   /**
   * @dev Devuelve el número de NFTs propiedad de '_owner'. Los NFTs asignados a la dirección cero son 
   * considerados inválidos, y esta función lanza para consultas sobre la dirección cero.
   * @notice Cuenta todos los NFTs asignados a un propietario.
   * @param _owner Dirección para la que se va a consultar el saldo.
   * @return Saldo del propietario.
   */
   function balanceOf(
    address _owner
   )
      external
      view
      return (uint256);
    
    /**
     * @notice Encuentra el propietario de un NFT.
     * @dev Devuelve la dirección del propietario del NFT. Los NFTs asignados a la dirección cero
     * se consideran inválidos, y las consultas sobre ellos lanzan.
     * @param _tokenId El identificador de un NFT.
     * @return Dirección del propietario de _tokenId.
     */
    function ownerOf(
      uiunt256 _tokenId
    )
      external
      view
      return (address);
   
   /**
    * @notice Lanza si '_tokenId' no es un NFT válido.
    * @dev Obtiene la dirección aprobada para un solo NFT.
    * @param _tokenId El NFT para el que se busca la dirección aprobada.
    * @return Dirección para la que está aprobado _tokenId.
    */
    function getApproved(
      uint256 _tokenId
    )
     external
     view
     return (address);
   
   /** 
    * @notice Consulta si una dirección es un operador autorizado para otra dirección.
    * @dev Devuelve true si '_operator' es un operador autorizado para '_owner', y falso en caso contrario.
    * @param _operator La dirección que actúa en nombre del propietario.
    * @return True si está aprobado para todos, false en caso contrario.
    */
    function isApprovedForAll(
      address _owner, 
      address _operator
    )
     external
     view
     returns (bool);
     
 }
