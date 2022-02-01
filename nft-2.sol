// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SpaceWorms is Ownable, ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
  
    bool private paused;
    uint256 private price;	
    uint256 private maxNFTAmount;
    uint256 private maxNFTPerUser;
    
    IERC20 private BUSDAddress;

    //@dev el parametro _price no esta 
    constructor(address _busdAddress, uint256 _price) ERC721("SpaceWorms", "SW") {

        //@dev este monto no representa 100 BUSD - utilizar la unidad de ether para representar cantidades
        price = 100; // 100 BUSD

        maxNFTAmount = 10;
        paused = false;                      //@dev este contrato no corresponde al busd de la red de bsc maint
        BUSDAddress = IERC20(_busdAddress); //BUSD Address on BSC mainnet is `0x4Fabb145d64652a948d72533023f6E7A623C7C53`
        maxNFTPerUser = 2;

    }

    function setPaused(bool _paused) public onlyOwner {
        paused = _paused;
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

    //@dev esta funcion aceptara busd para el minteo el payable ya no es necesario
    // 
    function mint() payable external returns(uint256) {
        /*
        @dev la cantidad de busd no se captura por la variable global msg.value
        ese valor tiene que enviarse mediante parametro
        */
        require(msg.value == price, "Not enough BUSD");

        require(_tokenIdCounter.current() < maxNFTAmount, "All NFTs have been minted");
        require(balanceOf(msg.sender) <= maxNFTPerUser, "Each address can only have up to 2 NFT");

        BUSDAddress.transferFrom(msg.sender, address(this), msg.value);
        _tokenIdCounter.increment();
        _safeMint(msg.sender, _tokenIdCounter.current());
        return _tokenIdCounter.current();
        
    }

    function withdraw() external onlyOwner {
        //@dev estas consultando el balance en bnb del contraton deberia consultar si almacena busd
        uint256 balance = address(this).balance;

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
