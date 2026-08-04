// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract SupplychainTracker{

    enum ProductStatus {
        Manufactured,
        Shipped,
        AtDistributor,
        AtRetailStore,
        Sold,
        Delivered
    }

    struct Participant {
        string companyName;
        address wallet;
        uint registrationNumber;
        bool isRegistered;
    }

    struct Customer {
        string customerName;
        address wallet;
        bool isRegistered;
    }

    struct Product {
        string name;
        uint256 id;
        string description;
        string manufacturer;
        address currentOwner;
        ProductStatus status;
    }

    struct OwnershipRecord {
        address previousOwner;
        address newOwner; 
    }

    mapping(uint => Product) public listOfProducts;
    mapping(uint => OwnershipRecord[]) ownershipHistory;
    mapping(address => Participant) public manufacturers;
    mapping(address => Participant) public distributors;
    mapping(address => Participant) public retailers;
    mapping(address => Customer) public customers;


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

    //Registration of retailor
    function registerRetailer(string memory companyName, uint256 registrationNumber) public {
        require(!retailers[msg.sender].isRegistered, "Already registered");
        retailers[msg.sender] = Participant(companyName, msg.sender, registrationNumber, true);
    } 

    //Customer registration
    function registerCustomer(string memory customerName) public {
        require(!customers[msg.sender].isRegistered, "Already registered");
        customers[msg.sender] = Customer(customerName, msg.sender, true);
    }

    //Product creation only by manufacturers
    function createProduct(string memory name, uint256 id, string memory description, string memory manufacturer) public onlyManufacturer {
        listOfProducts[id] = Product(name, id, description, manufacturer, msg.sender, ProductStatus.Manufactured);
    }

    //Change of ownership of product
    function transferOfOwnership(uint id, address newOwner, ProductStatus newStatus) public {
        require(msg.sender == listOfProducts[id].currentOwner, "Not current owner");
        require(newOwner != msg.sender, "Already the owner");

        address oldOwner = listOfProducts[id].currentOwner;
        listOfProducts[id].currentOwner = newOwner;
        listOfProducts[id].status = newStatus;
   
        ownershipHistory[id].push(OwnershipRecord(oldOwner, newOwner));
    }

    //Product history check
    function retriveOwnershipHistory(uint id) public view returns (OwnershipRecord[] memory) {
        return ownershipHistory[id];
    }      
    
}