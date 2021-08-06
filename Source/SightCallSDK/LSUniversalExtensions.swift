//
//  LSUniversalExtensions.swift
//  SightCallAlpha
//
//  Created by Jason Jobe on 3/15/21.
//

import LSUniversalSDK


extension LSACDStatus_t: CustomStringConvertible {
    public var description: String {
        switch self {
        case .acdStatus_invalid:
            return "acdStatus_invalid"
        case .acdStatus_ongoing:
            return "acdStatus_ongoing"
        case .acdStatus_serviceClosed:
            return "acdStatus_serviceClosed"
        case .acdStatus_serviceUnavailable:
            return "acdStatus_serviceUnavailable"
        case .acdStatus_agentUnavailable:
            return "acdStatus_agentUnavailable"
        @unknown default:
            return "acdStatus_\(self.rawValue)"
        }
    }
}

extension lsConnectionStatus_t: CustomStringConvertible {
    public var description: String {
        switch self {
        
        case .idle:
            return "idle"
        case .agentConnected:
            return "agentConnected"
        case .agentRegistering:
            return "agentRegistering"
        case .agentUnregistering:
            return "agentUnregistering"
        case .connecting:
            return "connecting"
        case .active:
            return "active"
        case .calling:
            return "calling"
        case .callActive:
            return "callActive"
        case .disconnecting:
            return "disconnecting"
        case .networkLoss:
            return "networkLoss"
        @unknown default:
            return "lsConnectionStatus_\(self.rawValue)"
        }
    }
}

extension lsConnectionError_t: CustomStringConvertible {
    
    public var description: String {
        switch self {
        
        case .networkError:
            return "networkError"
        case .badCredentials:
            return "badCredentials"
        case .unknown:
            return "unknown"
        @unknown default:
            return "default"
        }
    }
}
