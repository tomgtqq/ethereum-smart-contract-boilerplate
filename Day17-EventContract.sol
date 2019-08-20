pragma solidity ^0.5.4;

contract EventContract {
  struct Event {
    address admin;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemaining;
  }
  mapping(uint => Event) public events;
  mapping(address => mapping(uint => uint)) public tickets;
  uint public nextId;

  function createEvent(
    string calldata name,
    uint date,
    uint price,
    uint ticketCount) 
    external {
    require(date > now, 'can only organize event at a future date');
    require(ticketCount > 0, 'can only organize event with at least 1 ticket');
    events[nextId] = Event(
      msg.sender, 
      name, 
      date, 
      price, 
      ticketCount,
      ticketCount
    );
    nextId++;
  }
  
  modifier eventExist(uint id) {
    require(events[id].date != 0, 'this event does not exist');
    _;
  }
  
  modifier eventActive(uint id) {
    require(now < events[id].date, 'event must be active');
    _;
  }

  function buyTicket(uint id, uint quantity) 
    eventExist(id) 
    eventActive(id)
    payable
    external {
    Event storage _event = events[id];
    require(msg.value == (_event.price * quantity), 'ether sent must be equal to total ticket cost'); 
    require(_event.ticketRemaining >= quantity, 'not enough ticket left');
    _event.ticketRemaining -= quantity;
    tickets[msg.sender][id] += quantity;
  }

  function transferTicket(uint eventId, uint quantity, address to) 
    eventExist(eventId)
    eventActive(eventId)
    external {
      require(tickets[msg.sender][eventId] >= quantity, 'not enough ticket');
      tickets[msg.sender][eventId] -= quantity;
      tickets[to][eventId] += quantity;
  }
}