// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./libs/ArrayUtils.sol";

contract Projects {
  using SafeCast for uint256;
  using SafeCast for int256;
  using Address for address payable;
  using ArrayUtils for address[];

  struct Milestone {
    bytes32 name;
    bytes description;
    bool reached;
    bytes proof; // hash returned from IPFS or swarm
    uint64 expected_date;
  }

  struct Project {
    bytes32 name;
    bytes description;
    bytes main_video;
    bytes pitch_deck;
    uint32 target_fund;
    uint32 raised_funds;
    uint32 disbursted_funds;
    address payable fund_address;
    uint64 deadline;
    address owner;
    address[] backers;
    Milestone[] milestones;
  }

  struct Funds {
    bytes32 project_name;
    uint32 invested_funds;
    uint32 available_funds;
    bool opt_returns;
    bool returns_received;
  }

  struct User {
    Funds[] funds;
  }

  Project[] projects;

  mapping(bytes32 => uint256) public projectIndex;
  mapping(address => User) internal users;

  modifier onlyProjectOwner(bytes32 _projectName) {
    require(
      isProjectOwner(_projectName, msg.sender),
      "Only the Project members are allowed"
    );
    _;
  }

  function updateDescription(bytes32 _projectName, bytes memory _newLink)
    public
    onlyProjectOwner(_projectName)
  {
    Project storage project = fetchProject(_projectName);
    project.description = _newLink;
  }

  function updateVideo(bytes32 _projectName, bytes memory _newLink)
    public
    onlyProjectOwner(_projectName)
  {
    Project storage project = fetchProject(_projectName);
    project.main_video = _newLink;
  }

  function extendDeadline(bytes32 _projectName, uint256 _newTime)
    public
    onlyProjectOwner(_projectName)
  {
    Project storage project = fetchProject(_projectName);
    project.deadline = _newTime.toUint64();
  }

  function fundProject(bytes32 _projectName, bool _optedForReturns)
    public
    payable
  {
    require(msg.value > 0, "Can not fund 0 ethers");
    require(isValidProject(_projectName), "Project name provided is not valid");
    Project storage project = fetchProject(_projectName);
    uint32 funds = uint256(msg.value).toUint32();
    users[msg.sender].funds.push(
      Funds(_projectName, funds, funds, _optedForReturns, false)
    );
    project.raised_funds = funds;
    project.backers.push(msg.sender);
  }

  function getAllInvestments() public view returns (Funds[] memory) {
    return users[msg.sender].funds;
  }

  function revokeFundsFromProject(uint256 _fundIndex) public {
    Funds storage fund = users[msg.sender].funds[_fundIndex];
    require(fund.available_funds > 0, "User don't have enough funds to refund");
    require(
      address(this).balance > fund.available_funds,
      "Funds not available in the contract"
    );
    require(
      getProjectAvailableFunds(fund.project_name) > fund.available_funds,
      "Project has no available funds"
    );
    Project storage project = fetchProject(fund.project_name);
    int256 backerIndex = project.backers.findIndex(msg.sender);
    require(
      backerIndex != -1,
      "User is not present in the project's backers list"
    );
    payable(msg.sender).sendValue(fund.available_funds);
    project.raised_funds -= fund.available_funds;
    project.backers.remove(backerIndex.toUint256());
    fund.available_funds = 0;
  }

  function getProjectAvailableFunds(bytes32 _projectName)
    public
    view
    returns (uint32)
  {
    Project memory project = getProject(_projectName);
    return project.raised_funds - project.disbursted_funds;
  }

  function isProjectOwner(bytes32 _projectName, address _user)
    public
    view
    returns (bool)
  {
    return getProject(_projectName).owner == _user;
  }

  /// @dev checks if the Project Name provided is a valid Project or not
  /// @param _projectName which is the bytes32 representation of the name of the Project
  /// @return projectValidity of type bool. Returns true if the project is valid, false otherwise
  function isValidProject(bytes32 _projectName) public view returns (bool) {
    return getHash(getProject(_projectName).name) == getHash(_projectName);
  }

  /// @dev getter function to get Project from the provided bytes32 Project name
  /// @param _projectName which is the bytes32 representation of the name of a Project
  /// @return project of type Project
  function getProject(bytes32 _projectName)
    internal
    view
    returns (Project memory)
  {
    bytes32 hash = getHash(_projectName);
    return projects[projectIndex[hash]];
  }

  function fetchProject(bytes32 _projectName)
    internal
    view
    returns (Project storage)
  {
    bytes32 hash = getHash(_projectName);
    return projects[projectIndex[hash]];
  }

  function getHash(bytes32 _name) internal pure returns (bytes32) {
    return sha256(abi.encode(_name));
  }
}
