//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract nftKunya is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 price;
    mapping(uint256 => uint256) sales;
    uint _all;

    constructor() ERC721("KUNYANFT", "KUN") {
        _tokenIdCounter.increment();

    }

    function mint(address _to, uint256 _tokenId, string calldata _uri) external onlyOwner {
        _mint(_to, _tokenId);
        _setTokenURI(_tokenId, _uri);
    }

    //createItem() - создание нового предмета, обращается к контракту NFT и вызывает функцию mint.

    function createItem(address to) external {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= _all, "There is no extra data to mint");
        _tokenIdCounter.increment();
       _safeMint(to, tokenId);
    }
    //listItem() - выставление предмета на продажу.
    function listItem(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You do not have permission to sale");
        require(sales[tokenId] == 0, "No NFT to sale");
        sales[tokenId] = price;
}
    //buyItem() - покупка предмета.
    function buyItem(uint256 tokenId) public payable {
        require(sales[tokenId] != 0, "NFT is on sale");
        require(msg.value == sales[tokenId], "Not enough money to this transaction");
        payable(ownerOf(tokenId)).transfer(msg.value);
        _approve(msg.sender, tokenId);
        _transfer(ownerOf(tokenId), msg.sender, tokenId);
        sales[tokenId] = 0;
    }

    //cancel() - отмена продажи выставленного предмета
    function cancel(uint256 itemId) public {
        require(ownerOf(itemId) == msg.sender, "You do not have permission to cancel sale");
        require(sales[itemId] != 0, "No NFT to cancel");
        sales[itemId] = 0;
}
}