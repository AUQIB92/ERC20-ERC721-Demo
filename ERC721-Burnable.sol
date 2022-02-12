// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract OurERC721_Burnable is ERC721URIStorage {
       /**
Functions that need to be implemented for creating ERC721 compliant tokens
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
**/
    uint256 public maxSupply;
    uint256 public totalminted;
    address public owner;
    mapping(address => uint256) private totalAssetsOwned;

 
    /// @dev Constructor to initialize state variables
    constructor(uint256 _maxSupply) ERC721("Bloom-Web3-NFT", "BLT") {
        maxSupply = _maxSupply;
        totalminted = 0;
        owner = msg.sender;
    }

    function totalSupply() public view returns (uint256) {
        return maxSupply;
    }

    /// @dev Allows owner  to mint NFT
    function mintNFT(string memory metadata) public {
        require(msg.sender==owner,"Only Owner");
        require(totalminted <= maxSupply - 1, "No NFT left now");
        _mint(msg.sender, totalminted);
        _setTokenURI(totalminted, metadata);
        totalAssetsOwned[msg.sender]++;
        totalminted++;
    }
    /// @dev Allows owner of NFT to transfer it to some other address
    function transferNFT(address to, uint256 assetId) public {
        require(_exists(assetId), " Asset not Available");
        require(ownerOf(assetId) != to, " Asset already owned by address");
        totalAssetsOwned[to]++;
        totalAssetsOwned[msg.sender]--;
        _transfer(msg.sender, to, assetId);
        emit Transfer(msg.sender, to, assetId);
    }
/// @dev Allows owner to delagate transfer ownership
    function approveAddress(address spender, uint256 assetId) public {
        approve(spender, assetId);
        Approval(msg.sender, spender, assetId);
    }
/// @dev Allows spender to ransfer on behalf of real owner
    function transferFromNFT(
        address _owner,
        address to,
        uint256 assetId
    ) public {
        transferFrom(_owner, to, assetId);
        emit Transfer(_owner, to, assetId);
    }
/// @dev Allows owner to burn his nft
    function ourBurn(uint256 assetId) public returns (bool) {
        _burn(assetId);
        emit Transfer(msg.sender, address(0),assetId);
        return true;
    }
}
