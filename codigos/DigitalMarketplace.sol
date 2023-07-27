// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DigitalMarketplace {
    struct Product {
        uint id;
        address payable owner;
        uint price;
        bool purchased;
        string ipfsHash; // hash do IPFS do produto digital
    }

    mapping(uint => Product) public products;
    uint public productCount = 0;

    event ProductCreated(
        uint id,
        address payable owner,
        uint price,
        bool purchased,
        string ipfsHash
    );

    event ProductPurchased(
        uint id,
        address payable owner,
        address payable buyer,
        uint price,
        bool purchased,
        string ipfsHash
    );

    function createProduct(uint _price, string memory _ipfsHash) public {
        require(_price > 0, "Price must be greater than 0");
        productCount ++;
        products[productCount] = Product(productCount, payable(msg.sender), _price, false, _ipfsHash);
        emit ProductCreated(productCount, payable(msg.sender), _price, false, _ipfsHash);
    }

    function purchaseProduct(uint _id) public payable {
        Product memory _product = products[_id];
        address payable _seller = _product.owner;
        require(_product.id > 0 && _product.id <= productCount, "Product does not exist");
        require(msg.value >= _product.price, "Not enough Ether sent");
        require(!_product.purchased, "Product already purchased");
        require(_seller != msg.sender, "Cannot buy your own product");
        _product.owner = payable(msg.sender);
        _product.purchased = true;
        products[_id] = _product;
        _seller.transfer(msg.value);
        emit ProductPurchased(productCount, _seller, payable(msg.sender), _product.price, true, _product.ipfsHash);
    }
}