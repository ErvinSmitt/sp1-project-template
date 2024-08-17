// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ISP1Verifier} from "@sp1-contracts/ISP1Verifier.sol";

struct PublicValuesStruct {
    uint32 n; // The position of the Fibonacci number in the sequence
    uint32 a; // The (n-1)th Fibonacci number
    uint32 b; // The nth Fibonacci number
}

/// @title Fibonacci Verifier
/// @author Succinct Labs
/// @notice This contract verifies the proof of computing a Fibonacci number.
contract Fibonacci {
    /// @notice Address of the SP1 verifier contract.
    /// @dev This could be a specific SP1Verifier or SP1VerifierGateway.
    address public verifier;

    /// @notice The verification key for the Fibonacci program.
    bytes32 public fibonacciProgramVKey;

    /// @param _verifier Address of the SP1 verifier contract.
    /// @param _fibonacciProgramVKey Verification key for the Fibonacci program.
    constructor(address _verifier, bytes32 _fibonacciProgramVKey) {
        verifier = _verifier;
        fibonacciProgramVKey = _fibonacciProgramVKey;
    }

    /// @notice Verifies the proof of a Fibonacci number calculation.
    /// @param _proofBytes Encoded proof data.
    /// @param _publicValues Encoded public values containing the Fibonacci sequence details.
    /// @return n The position of the Fibonacci number.
    /// @return a The (n-1)th Fibonacci number.
    /// @return b The nth Fibonacci number.
    function verifyFibonacciProof(bytes calldata _publicValues, bytes calldata _proofBytes)
        public
        view
        returns (uint32 n, uint32 a, uint32 b)
    {
        // Verify the proof using the SP1 verifier contract
        ISP1Verifier(verifier).verifyProof(fibonacciProgramVKey, _publicValues, _proofBytes);

        // Decode the public values to retrieve the Fibonacci sequence details
        PublicValuesStruct memory publicValues = abi.decode(_publicValues, (PublicValuesStruct));

        // Return the decoded Fibonacci sequence values
        return (publicValues.n, publicValues.a, publicValues.b);
    }
}
