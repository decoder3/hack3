// SPDX-License-Identifier: MIT
pragma solidity >0.4.23 <0.9.0;
import "./Hackathon.sol";
// import "@optionality.io/clone-factory/contracts/CloneFactory.sol";
// import "zeppelin-solidity/contracts/ownership/Ownable.sol";

import "hardhat/console.sol";

contract Factory {
  Hackathon[] public _hackathons;
  event HackathonCreated(Hackathon hackathon);
  function createHackathon(
        uint _max_team_size,
        uint _num_tracks,
        uint[] memory _prizes,
        address[] memory _judges,
        uint _judgeDate,
        uint _endDate
        ) public returns(address){
    Hackathon hackathon = new Hackathon(
        _max_team_size,
        _num_tracks,
        _prizes,
        _judges,
        _judgeDate,
        _endDate
    );
    _hackathons.push(hackathon);
    address hackathonAddress = address(hackathon);
    console.log(hackathonAddress);
    return hackathonAddress;
    // emit HackathonCreated(hackathon);
  }
}