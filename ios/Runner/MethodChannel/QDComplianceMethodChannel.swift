//
//  QDComplianceMethodChannel.swift
//  Runner
//
//  Created by saminos on 04/03/22.
//

import Foundation
import QcmpSDK

class QDComplianceMethodChannel: FlutterMethodChannel {
    private static let compliance = Compliance.shared
    private static let channel = "io.quadrant.compliance"
    
    @discardableResult
    static func setup(_ binaryMessenger: FlutterBinaryMessenger, integrationKey: String) -> QDComplianceMethodChannel {
        
        let methodChannel = QDComplianceMethodChannel(name: Self.channel, binaryMessenger: binaryMessenger)
        compliance.setup(integrationKey)
        methodChannel.setup()
        return methodChannel
    }
    
    private func setup() {
        setMethodCallHandler(Self.handler(call:result:))
    }
    
    private static func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openConsentFormIfNeeded":
            compliance.openConsentFormIfNeeded { (consentResult) in
                switch consentResult {
                case .success(let choosenConsent):
                    result(choosenConsent.rawValue)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            
        case "openConsentForm":
            guard let arguments = call.arguments as? [String: Any],
                  let complianceTypeRaw = arguments["complianceType"] as? Int,
                  let type = ComplianceType(rawValue: complianceTypeRaw)
            else { return }
            
            compliance.openConsentForm(complianceType: type) { consentResult in
                switch consentResult {
                case .success(let choosenConsent):
                    result(choosenConsent.rawValue)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            case "optOut":
            compliance.requestCompliance(requestType: .REQUEST_OPTOUT) { requestResult in
                switch requestResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            case "doNotSell":
            compliance.requestCompliance(requestType: .REQUEST_DO_NOT_SELL) { requestResult in
                switch requestResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            case "deleteMyData":
            compliance.requestCompliance(requestType: .REQUEST_DELETE_DATA) { requestResult in
                switch requestResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            case "requestMyData":
            compliance.requestCompliance(requestType: .REQUEST_ACCESS_DATA) { requestResult in
                switch requestResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            
        default: break;
        }
    }
}
