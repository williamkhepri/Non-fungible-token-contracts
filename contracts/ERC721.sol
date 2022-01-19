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
* @notice 

*/
}
