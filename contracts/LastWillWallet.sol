pragma solidity ^0.4.21;

import "./Ownable.sol";
import "./SafeMath.sol";

contract LastWill is Ownable {
    using SafeMath for uint256;
    
    struct Heir
    {
        uint shares;
        uint relationship; // 0 : Child 1: Spouse 2: Other
    }
  mapping(address => Heir) public heirs_;
  
  uint256 private totalShares_;

  // Time window the owner has to notify they are alive.
  uint256 private heartbeatTimeout_;

  // Timestamp of the owner's death, as pronounced by a heir.
  uint256 private timeOfDeath_;

  event HeirAdded(address indexed newHeir);
  event OwnerHeartbeated(address indexed owner);
  event OwnerProclaimedDead(address indexed owner, address indexed heir, uint256 timeOfDeath);
  event fundsReclaimed(address indexed heir, uint indexed shares);


  /**
   * @dev Throw an exception if called by any account other than the heir's.
   */
  modifier onlyHeir() {
    require(heirs_[msg.sender].shares > 0);
    _;
  }

  function LastWill(uint256 _heartbeatTimeout) public {
    setHeartbeatTimeout(_heartbeatTimeout);
  }

  function addHeir(address _newHeir, uint _relationship,uint _shares) public onlyOwner {
    require(_newHeir != owner);
    //require(heirs_(_newHeir).shares == 0);
    heartbeat();
    heirs_[_newHeir].relationship = _relationship;
    heirs_[_newHeir].shares = _shares;
    totalShares_ += _shares;
    
    emit HeirAdded(_newHeir);
  }

//  function heir(address _heir) public view returns(Heir) {
 //   return heirs_[_heir];
 // }

  function totalShares() public view returns(uint) {
    return totalShares_;
  }
  
  function heartbeatTimeout() public view returns(uint256) {
    return heartbeatTimeout_;
  }
  
  function timeOfDeath() public view returns(uint256) {
    return timeOfDeath_;
  }

  //function editHeir() public onlyOwner {
    //todo
  //}

  /**
   * @dev Heir can pronounce the owners death. To claim the ownership, they will
   * have to wait for `heartbeatTimeout` seconds.
   */
  function proclaimDeath() public onlyHeir {
    require(ownerLives());
    emit OwnerProclaimedDead(owner, msg.sender, timeOfDeath_);
    timeOfDeath_ = block.timestamp;
  }

  /**
   * @dev Owner can send a heartbeat if they were mistakenly pronounced dead.
   */
  function heartbeat() public onlyOwner {
    emit OwnerHeartbeated(owner);
    timeOfDeath_ = 0;
  }

  /**
   * @dev Allows heir to transfer ownership only if heartbeat has timed out.
   */
  function reclaimFunds() public onlyHeir {
    require(!ownerLives());
    require(block.timestamp >= timeOfDeath_ + heartbeatTimeout_);
    emit OwnershipTransferred(owner, 0);
    emit fundsReclaimed(msg.sender, heirs_[msg.sender].shares);
    owner = 0;
    uint _coeff = heirs_[msg.sender].shares.div(totalShares_);
    require(_coeff<=1&&_coeff>0);
    msg.sender.transfer(address(this).balance.mul(_coeff));
    totalShares_ -= heirs_[msg.sender].shares;
    heirs_[msg.sender].shares = 0;
  }

  function setHeartbeatTimeout(uint256 newHeartbeatTimeout) internal onlyOwner {
    require(ownerLives());
    heartbeatTimeout_ = newHeartbeatTimeout;
  }

  function ownerLives() internal view returns (bool) {
    return timeOfDeath_ == 0;
  }
}

contract LastWillWallet is LastWill {

  event Sent(address indexed payee, uint256 amount, uint256 balance);
  event Received(address indexed payer, uint256 amount, uint256 balance);


  function LastWillWallet(uint256 _heartbeatTimeout) LastWill(_heartbeatTimeout) public {}

  function () public payable {
    emit Received(msg.sender, msg.value, address(this).balance);
  }

  function sendTo(address payee, uint256 amount) public onlyOwner {
    require(payee != 0 && payee != address(this));
    require(amount > 0);
    payee.transfer(amount);
    emit Sent(payee, amount, address(this).balance);
  }
}