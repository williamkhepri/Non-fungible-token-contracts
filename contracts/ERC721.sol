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

}
