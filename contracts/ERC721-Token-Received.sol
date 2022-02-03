// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev ERC-721 interface for accepting safe transfers.
 * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
 */
interface ERC721TokenReceiver
{

  /**
   * @notice La dirección del contrato es siempre la del remitente del mensaje. Una aplicación de cartera/corredor/subasta
   * DEBE implementar la interfaz de billetera si acepta transferencias seguras.
   * @dev Manejar la recepción de un NFT. El contrato inteligente ERC721 llama a estar función en el  
   * destinatario después de una 'transferencia'. Esta función se PUEDE lanzar para revertir y rechazar la transferencia.
   * Devuelve un valor distinto al mágico DEBE dar lugar a la reversión de la transacción.
   * Devuelve `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` a menos que se lance.
   * @param _operator La dirección que llamó a la función `safeTransferFrom`.
   * @param _from La dirección a la que pertenecía anteriormente en token.
   * @param _tokenId El identificador NFT que se transfiere.
   * @param _data Datos adicionales sin formato especificado.
   * @return Devuelve `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    returns(bytes4);

}
