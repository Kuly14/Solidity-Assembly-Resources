// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Credit goes to these two answeres on ethereum stack exchange
// 1. https://ethereum.stackexchange.com/questions/130072/return-bytes-from-inline-assembly
// 2. https://ethereum.stackexchange.com/questions/60563/why-is-the-returndata-of-a-function-returning-bytes-formatted-in-a-weird-way/60570#60570

contract AbiEncode {

        // @notice abi encoding in inline assembly isn't as straightforward as one may think. The problem is that you have to encode the data with a lot of additional data
    // because bytes memory is a dynamically sized type.abi

    // To abi.encode() in inline assembly, we will need to prepend 2 32-long bytes of information.
    // 1. Return data offset - This is an offset to the start of the data.
    // 2. Length of the data - If we want to return, let's say, two whole words, so 64 bytes we will have to tell evm that we want to return 64 bytes. 
    // so we prepend the lengthof the data
    // 3. Your data

    function encode() public view returns(bytes memory) {
        assembly {
            let res := 0x00                     // Take memory location
            mstore(res, 0x20)                   // return data offset
            mstore(add(res, 0x20), 0x40)        // length: 64 bytes
            mstore(add(res, 0x40), caller())    // first 32 bytes
            mstore(add(res, 0x60), address())   // second 32 bytes
            return (res, 0x80)                  // return all 128 bytes
        }
    }
}
