// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
contract OurERC721 is ERC721URIStorage {
address erc20;
uint256  public maxSupply;
uint256 public  totalminted;
mapping(address => uint256) private totalAssetsOwned;
/// @dev Constructor to initialize state variables
constructor(uint256 _maxSupply) ERC721("Bloom Tech","BLT")
{
maxSupply= _maxSupply;
totalminted=0;
}


function totalSupply() public view returns(uint256)
{
    return maxSupply;
}
/// @dev Allows anyone to mint NFT  
function mintNFT(string memory metadata) public {
require(totalminted<=maxSupply-1,"No NFT left now");
_mint(msg.sender,totalminted);
_setTokenURI(totalminted, metadata);
totalAssetsOwned[msg.sender]++;
totalminted++;
}
/// @dev Allows owner of NFT to transfer it some other address 
function transferNFT(address to, uint256 assetId) public 
{
      
        require(_exists(assetId), " Asset not Available");
        require(ownerOf(assetId) != to, " Asset already owned by address");
        totalAssetsOwned[to]++;
        totalAssetsOwned[msg.sender]--;
        _transfer(msg.sender,to, assetId);
        emit Transfer(msg.sender, to , assetId);
    }
}























