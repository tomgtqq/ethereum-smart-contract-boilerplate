//Define a Supply Chain Contract "LemonadeStand"
pragma solidity >= 0.4.24;

contract LemonadeStand {
    
//Variable:'Owner'
  address  owner;

//Variable:'skuCount'
  uint skuCount;

//Event:'State' with value 'ForSale'
  enum State { ForSale, Sold , shipped }

//Struct: 'Item' with the following fields: name, sku, price, state, seller, buyer
  struct Item {
      string name;
      uint sku;
      uint price;
      State state;
      address payable seller;
      address payable buyer;
  }

//Define mapping 'items' that maps the SKU(a number) to an Item.
  mapping (uint => Item) items;

//Event ForSale
  event ForSale(uint skuCount);

//Event Sold
  event Sold(uint sku);
  
//Event Shipped
  event Shipped(uint sku);

//Modifier: Only Owner
modifier onlyOwner() {
    require(msg.sender== owner);
    _;
}

//Modifier: Verify Caller
modifier verifyCaller(address _address){
    require(msg.sender == _address);
    _;
}

//Modifier: Paid Enough
modifier paidEnough(uint _price) {
    require(msg.value >= _price);
    _;
}

//Modifier: For Sale 
modifier forSale(uint _sku) {
    require(items[_sku].state == State.ForSale);
    _;
}

//Modifier: Sold
modifier sold(uint _sku) {
    require(items[_sku].state == State.Sold);
    _;
}

//modifier: Checks the price and refunds the remaining balance
modifier checkValue(uint _sku){
    _;
    uint _price = items[_sku].price;
    uint amoutToRefund = msg.value - _price;
    items[_sku].buyer.transfer(amoutToRefund);
}

//Function: Constructor to set some initial values
constructor () public {
    owner = msg.sender;
    skuCount = 0;
}

// Function that allows you to convert an address into a payable address
    // function _make_payable(address x) internal pure returns (address payable) {
    //     return address(uint160(x));
    // }

//Function: Add Item
function addItem(string memory _name, uint _price) onlyOwner public {
    // Increment sku
    skuCount = skuCount + 1;
    
    // Emit the appropriate event
    emit ForSale(skuCount);
    
    // Add the new item into inventory and mark it for sale
    items[skuCount] = Item({name: _name, sku: skuCount, price:_price,state:State.ForSale,seller:msg.sender,buyer:address(0)});
}

//Function: Buy Item
function buyItem(uint sku) forSale(sku) paidEnough(items[sku].price) checkValue(sku) public payable {
    address payable buyer = msg.sender;
    
    uint price = items[sku].price;
    //Update buyer
    items[sku].buyer = buyer;
    //Update State
    items[sku].state = State.Sold;
    //Transfer money to seller
    items[sku].seller.transfer(price);

    //emit the appropriate event
    emit Sold(sku);
    
}

//Function: Fetch Item
function fetchItem(uint _sku) public view returns (string memory name, uint sku, uint price, string memory stateIs, address seller, address buyer){
uint state;
name = items[_sku].name;
sku = items[_sku].sku;
price = items[_sku].price;
state = uint(items[_sku].state);
     if( state == 0 ) {
         stateIs = "For sale";
     } 
     if( state == 1 ) {
         stateIs = "Sold";
     }
     if( state == 1 ) {
          stateIs = "Shipped";
     }
    seller = items[_sku].seller;
    buyer = items[_sku].buyer;
}

// Ship an item that has been sold.
function shipItem(uint sku) public sold(sku) verifyCaller(items[sku].seller){
    //Update state
    items[sku].state = State.shipped;
    // Emit the appropriate event
    emit Shipped(sku);
}
    
}