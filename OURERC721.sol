// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract OurERC721 is ERC721URIStorage {
    address erc20;
    uint256 public maxSupply;
    uint256 public totalminted;

    constructor(address Erc20, uint256 _maxSupply) ERC721("Bloom Tech", "BLT") {
        maxSupply = _maxSupply;
        require(totalminted <= maxSupply, "No NFT left now");
        totalminted = 0;
        erc20 = Erc20;
    }

    function mintNFT(string memory metadata) public {
        require(totalminted <= maxSupply - 1, "No NFT left now");
        require(
            getERC20Bal() > 100000000,
            "Can't Mint Not having threshold ERC20 tokens"
        );
        _mint(msg.sender, totalminted);
        _setTokenURI(totalminted, metadata);
        totalminted++;
    }

    function getERC20Bal() public view returns (uint256) {
        OurERC20 myERC20 = OurERC20(erc20);
        return myERC20.balanceOf(msg.sender);
    }
}

interface OurERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}
