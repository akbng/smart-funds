// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Array {
    function includes(uint256[] storage _array, uint256 value)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _array.length; i++) {
            if (_array[i] == value) return true;
        }
        return false;
    }

    function includes(address[] storage _array, address value)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _array.length; i++) {
            if (_array[i] == value) return true;
        }
        return false;
    }
}
