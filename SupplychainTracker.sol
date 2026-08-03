// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract SupplychainTracker{

    struct Participant {
        string companyName;
        address wallet;
        uint registrationNumber;
        bool isRegistered;
    }

    struct Product {
        string name;
        uint256 id;
        string description;
        string manufacturer;
    }

    Product[] public listOfProducts;

    mapping(address => Participant) public manufacturers;
    mapping(address => Participant) public distributors;


    //Only registered manufactures can create an product.
    modifier onlyManufacturer() {
        require(manufacturers[msg.sender].isRegistered, "Not a registered manufacturer");
        _;
    } 


    //Registration for manufacturures
    function registerManufacturer(string memory companyName, uint registrationNumber) public {
        require(!manufacturers[msg.sender].isRegistered, "Already registered");
        manufacturers[msg.sender] = Participant(companyName,  msg.sender, registrationNumber, true);

    }

    //Registration for distributor
    function registerDistributor(string memory companyName, uint256 registrationNumber) public {
        require(!distributors[msg.sender].isRegistered, "Already registered");
        distributors[msg.sender] = Participant(companyName, msg.sender, registrationNumber, true);
    }

    //Product creation only by manufacturers
    function createProduct(string memory name, uint256 id, string memory description, string memory manufacturer) public onlyManufacturer {
        listOfProducts.push(Product(name, id, description, manufacturer));
    }
        
    
}