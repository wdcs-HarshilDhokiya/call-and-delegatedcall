// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Target {
    uint public value;
    address public sender;
    string public _msg="Hi";

    event massage(string _massage);

    constructor(uint _value) {
        value = _value;
    }

    function setValue(uint _value) public returns (uint256) {
        value = _value;
        sender = msg.sender;
        emit massage(_msg);
        return value;
    }
}


contract Caller {
    uint public value;
    address public sender;
    string  public _msg="Hello";

    address public targetAddress;

    event Response(bool success, bytes data);

    constructor(address _address)  {
        targetAddress = _address;
    }
    
    function saveValueByCall(uint _value) public payable returns (uint256) {
        (bool success, bytes memory data) = targetAddress.call{value:msg.value}(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        emit Response(success, data);
        return abi.decode(data, (uint256));
    }


    function saveValueByDelegateCall(uint _value) public payable returns (uint256) {
        (bool success, bytes memory data) = targetAddress.delegatecall(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        emit Response(success, data);
        return abi.decode(data, (uint256));
    }

}