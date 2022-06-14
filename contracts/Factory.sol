// SPDX-License-Identifier: MIT
pragma solidity >0.4.23 <0.9.0;
import "./Hackathon.sol";
// import "@optionality.io/clone-factory/contracts/CloneFactory.sol";
// import "zeppelin-solidity/contracts/ownership/Ownable.sol";

import "hardhat/console.sol";

contract Factory {
  address[] public _hackathons;
  event HackathonCreated(Hackathon hackathon);
  function createHackathon(
        uint _max_team_size,
        uint _num_tracks,
        uint[] memory _prizes,
        address[] memory _judges,
        uint _judgeDate,
        uint _endDate
        ) public payable{
    // uint tmp = 0;
    // for(uint i = 0; i < _prizes.length; i++){
    //     tmp += _prizes[i];
    // }
    // require(tmp <= msg.value);
    // require(_max_team_size > 0 && _num_tracks > 0);
    // require(_judgeDate > block.timestamp && _endDate > _judgeDate);
    Hackathon hackathon = new Hackathon(
        _max_team_size,
        _num_tracks,
        _prizes,
        _judges,
        _judgeDate,
        _endDate
    );

    address hackathonAddress = address(hackathon);
    _hackathons.push(hackathonAddress);
    console.log(hackathonAddress);
    emit HackathonCreated(hackathon);
  }

  function getLatestHackathon() public view returns(address){
    return _hackathons[_hackathons.length - 1];
  }
}