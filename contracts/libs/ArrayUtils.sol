// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeCast.sol";

library ArrayUtils {
  using SafeCast for uint256;
  using SafeCast for int256;

  function includes(uint256[] storage _array, uint256 _value)
    internal
    view
    returns (bool)
  {
    for (uint256 i = 0; i < _array.length; i++) {
      if (_array[i] == _value) return true;
    }
    return false;
  }

  function map(
    uint256[] memory _array,
    function(uint256) pure returns (uint256) _f
  ) internal pure returns (uint256[] memory r) {
    r = new uint256[](_array.length);
    for (uint256 i = 0; i < _array.length; i++) {
      r[i] = _f(_array[i]);
    }
  }

  function reduce(
    uint256[] memory _array,
    function(uint256, uint256) pure returns (uint256) _f
  ) internal pure returns (uint256 r) {
    r = _array[0];
    for (uint256 i = 1; i < _array.length; i++) {
      r = _f(r, _array[i]);
    }
  }

  function includes(address[] storage _array, address _value)
    internal
    view
    returns (bool)
  {
    for (uint256 i = 0; i < _array.length; i++) {
      if (_array[i] == _value) return true;
    }
    return false;
  }

  function findIndex(address[] storage _array, address _value)
    internal
    view
    returns (int256)
  {
    for (uint256 i = 0; i < _array.length; i++) {
      if (_array[i] == _value) return i.toInt256();
    }
    return -1;
  }

  function remove(address[] storage _array, uint256 _index) internal {
    _array[_index] = _array[_array.length - 1];
    _array.pop();
  }

  function at(address[] storage _array, int256 _index)
    internal
    view
    returns (address)
  {
    uint256 index = _index < 0
      ? _array.length - _index.toUint256()
      : _index.toUint256();
    return _array[index];
  }

  function map(
    address[] memory _array,
    function(address) pure returns (address) _f
  ) internal pure returns (address[] memory r) {
    r = new address[](_array.length);
    for (uint256 i = 0; i < _array.length; i++) {
      r[i] = _f(_array[i]);
    }
  }
}
