pragma solidity 0.8.7;

// @author Kuly14

contract UpdatingFreeMemoryPointer {
    function updateMemoryPointer(address _addr) public view returns (bytes32) {
        // Start assembly block
        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)

            // Store the _addr to memory at memory address 0x80
            mstore(ptr, _addr)

            // Update the free memory pointer
            // Since we are using assembly we need to update the free memory pointer
            // ourselves. If we didn't then the addrArray would overwrite the _addr
            mstore(0x40, add(ptr, 32))
        }

        // Save addrArray to memory. Because we updated the free memory pointer
        // the addrArray will be saved to the next free slot and won't overwrite
        // _addr in memory
        address[] memory addrArray = new address[](3);

        // Save msg.sender to memory
        addrArray[0] = msg.sender;

        // Return the msg.sender address. It is stored at 0xc0 because:
        // 0x80 -> _addr || 0x80 + 32 bytes = 0xa0
        // 0xa0 -> Array Length || 0xa0 + 32 bytes = 0xc0
        // 0xc0 -> addrArray[0] in this case msg.sender
        assembly {
            return(0xc0, 32)
        }
    }
}
