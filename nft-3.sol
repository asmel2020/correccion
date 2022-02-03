// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SpaceWorms is Ownable, ERC721Pausable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
  
    uint256 private price;
    uint256 private maxNFTAmount;
    uint256 private maxNFTPerUser;
    IERC20 private immutable BUSDAddress;

    constructor(address _tokenAddress, uint256 _price) ERC721("SpaceWorms", "SW") {
        price = _price;
        maxNFTAmount = 10;
        BUSDAddress = IERC20(_tokenAddress);
        maxNFTPerUser = 2;
    }

    function setMaxNFT(uint256 _max) external onlyOwner() {
        maxNFTAmount = _max;
    }

    function setNFTPrice(uint256 _price) external onlyOwner() {
        price = _price;
    }

    function _baseURI() internal pure override returns(string memory) {
        return "https://negociosytecnologias.net/erc721/";
    }
        //@dev agregar pausabilidad a la funcion de de venta de nft
    function mint(uint256 _amount) external returns(uint256) {
        //@dev !ERROR FATAL! por favor comprar el _amount con price de manera exacta ejemplo (_amount==price)
        require(_amount < price, "Not enough BUSD");
        require(_tokenIdCounter.current() < maxNFTAmount, "All NFTs have been minted");
        require(balanceOf(msg.sender) <= maxNFTPerUser, "Each address can only have up to 2 NFT");

        BUSDAddress.transferFrom(msg.sender, address(this), _amount);

        _tokenIdCounter.increment();
        _safeMint(msg.sender, _tokenIdCounter.current());
        return _tokenIdCounter.current();

    }

    function withdraw() external onlyOwner {

        uint256 balance = BUSDAddress.balanceOf(address(this));
        BUSDAddress.transfer(msg.sender, balance);
        
    }

    function getCurrentBalance() external view returns(uint256) {
        uint256 balance = address(this).balance;
        return balance;
    }

    function tokenId() external view returns(uint256) {
        return _tokenIdCounter.current();
    }
}
