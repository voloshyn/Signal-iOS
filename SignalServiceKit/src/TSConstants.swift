//
//  Copyright (c) 2021 Open Whisper Systems. All rights reserved.
//

private protocol TSConstantsProtocol: AnyObject {
    var mainServiceWebSocketAPI_identified: String { get }
    var mainServiceWebSocketAPI_unidentified: String { get }
    var mainServiceURL: String { get }
    var textSecureCDN0ServerURL: String { get }
    var textSecureCDN2ServerURL: String { get }
    var contactDiscoveryURL: String { get }
    var keyBackupURL: String { get }
    var storageServiceURL: String { get }
    var sfuURL: String { get }
    var sfuTestURL: String { get }
    var kUDTrustRoot: String { get }

    var censorshipReflectorHost: String { get }

    var serviceCensorshipPrefix: String { get }
    var cdn0CensorshipPrefix: String { get }
    var cdn2CensorshipPrefix: String { get }
    var contactDiscoveryCensorshipPrefix: String { get }
    var keyBackupCensorshipPrefix: String { get }
    var storageServiceCensorshipPrefix: String { get }

    var contactDiscoveryEnclaveName: String { get }
    var contactDiscoveryMrEnclave: String { get }

    var keyBackupEnclave: KeyBackupEnclave { get }
    var keyBackupPreviousEnclaves: [KeyBackupEnclave] { get }

    var applicationGroup: String { get }

    var serverPublicParamsBase64: String { get }
}

public struct KeyBackupEnclave: Equatable {
    let name: String
    let mrenclave: String
    let serviceId: String
}

// MARK: -

@objc
public class TSConstants: NSObject {

    @objc
    public static let EnvironmentDidChange = Notification.Name("EnvironmentDidChange")

    // Never instantiate this class.
    private override init() {}

    @objc
    public static var mainServiceWebSocketAPI_identified: String { shared.mainServiceWebSocketAPI_identified }
    @objc
    public static var mainServiceWebSocketAPI_unidentified: String { shared.mainServiceWebSocketAPI_unidentified }
    @objc
    public static var mainServiceURL: String { shared.mainServiceURL }
    @objc
    public static var textSecureCDN0ServerURL: String { shared.textSecureCDN0ServerURL }
    @objc
    public static var textSecureCDN2ServerURL: String { shared.textSecureCDN2ServerURL }
    @objc
    public static var contactDiscoveryURL: String { shared.contactDiscoveryURL }
    @objc
    public static var keyBackupURL: String { shared.keyBackupURL }
    @objc
    public static var storageServiceURL: String { shared.storageServiceURL }
    @objc
    public static var sfuURL: String { shared.sfuURL }
    @objc
    public static var sfuTestURL: String { shared.sfuTestURL }
    @objc
    public static var kUDTrustRoot: String { shared.kUDTrustRoot }

    @objc
    public static var censorshipReflectorHost: String { shared.censorshipReflectorHost }

    @objc
    public static var serviceCensorshipPrefix: String { shared.serviceCensorshipPrefix }
    @objc
    public static var cdn0CensorshipPrefix: String { shared.cdn0CensorshipPrefix }
    @objc
    public static var cdn2CensorshipPrefix: String { shared.cdn2CensorshipPrefix }
    @objc
    public static var contactDiscoveryCensorshipPrefix: String { shared.contactDiscoveryCensorshipPrefix }
    @objc
    public static var keyBackupCensorshipPrefix: String { shared.keyBackupCensorshipPrefix }
    @objc
    public static var storageServiceCensorshipPrefix: String { shared.storageServiceCensorshipPrefix }

    @objc
    public static var contactDiscoveryEnclaveName: String { shared.contactDiscoveryEnclaveName }
    @objc
    public static var contactDiscoveryMrEnclave: String { shared.contactDiscoveryMrEnclave }

    static var keyBackupEnclave: KeyBackupEnclave { shared.keyBackupEnclave }
    static var keyBackupPreviousEnclaves: [KeyBackupEnclave] { shared.keyBackupPreviousEnclaves }

    @objc
    public static var applicationGroup: String { shared.applicationGroup }

    @objc
    public static var serverPublicParamsBase64: String { shared.serverPublicParamsBase64 }

    @objc
    public static var isUsingProductionService: Bool {
        return environment == .production
    }

    private enum Environment {
        case production, staging
    }

    private static let serialQueue = DispatchQueue(label: "TSConstants")
    private static var _forceEnvironment: Environment?
    private static var forceEnvironment: Environment? {
        get {
            return serialQueue.sync {
                return _forceEnvironment
            }
        }
        set {
            serialQueue.sync {
                _forceEnvironment = newValue
            }
        }
    }

    private static var environment: Environment {
        if let environment = forceEnvironment {
            return environment
        }
        return FeatureFlags.isUsingProductionService ? .production : .staging
    }

    @objc
    public class func forceStaging() {
        forceEnvironment = .staging
    }

    @objc
    public class func forceProduction() {
        forceEnvironment = .production
    }

    private static var shared: TSConstantsProtocol {
        switch environment {
        case .production:
            return TSConstantsProduction()
        case .staging:
            return TSConstantsStaging()
        }
    }
}

// MARK: -

private class TSConstantsProduction: TSConstantsProtocol {

    public var mainServiceWebSocketAPI_identified: String {
        FeatureFlags.newHostNames
            ? "wss://chat.signal.org/v1/websocket/"
            : "wss://textsecure-service.whispersystems.org/v1/websocket/"
    }
    public var mainServiceWebSocketAPI_unidentified: String {
        FeatureFlags.newHostNames
            ? "wss://ud-chat.signal.org/v1/websocket/"
            : "wss://textsecure-service.whispersystems.org/v1/websocket/"
    }
    public var mainServiceURL: String {
        FeatureFlags.newHostNames
            ? "https://chat.signal.org/"
            : "https://textsecure-service.whispersystems.org/"
    }
    public let textSecureCDN0ServerURL = "https://cdn.signal.org"
    public let textSecureCDN2ServerURL = "https://cdn2.signal.org"
    public let contactDiscoveryURL = "https://api.directory.signal.org"
    public let keyBackupURL = "https://api.backup.signal.org"
    public let storageServiceURL = "https://storage.signal.org"
    public let sfuURL = "https://sfu.voip.signal.org"
    public let sfuTestURL = "https://sfu.test.voip.signal.org"
    public let kUDTrustRoot = "BXu6QIKVz5MA8gstzfOgRQGqyLqOwNKHL6INkv3IHWMF"

    public let censorshipReflectorHost = "europe-west1-signal-cdn-reflector.cloudfunctions.net"

    public let serviceCensorshipPrefix = "service"
    public let cdn0CensorshipPrefix = "cdn"
    public let cdn2CensorshipPrefix = "cdn2"
    public let contactDiscoveryCensorshipPrefix = "directory"
    public let keyBackupCensorshipPrefix = "backup"
    public let storageServiceCensorshipPrefix = "storage"

    public let contactDiscoveryEnclaveName = "c98e00a4e3ff977a56afefe7362a27e4961e4f19e211febfbb19b897e6b80b15"
    public var contactDiscoveryMrEnclave: String {
        return contactDiscoveryEnclaveName
    }

    public let keyBackupEnclave = KeyBackupEnclave(
        name: "fe7c1bfae98f9b073d220366ea31163ee82f6d04bead774f71ca8e5c40847bfe",
        mrenclave: "a3baab19ef6ce6f34ab9ebb25ba722725ae44a8872dc0ff08ad6d83a9489de87",
        serviceId: "fe7c1bfae98f9b073d220366ea31163ee82f6d04bead774f71ca8e5c40847bfe"
    )

    // An array of previously used enclaves that we should try and restore
    // key material from during registration. These must be ordered from
    // newest to oldest, so we check the latest enclaves for backups before
    // checking earlier enclaves.
    public let keyBackupPreviousEnclaves = [KeyBackupEnclave]()

    public let applicationGroup = "group.com.mobilecoin.signal.group"

    // We need to discard all profile key credentials if these values ever change.
    // See: GroupsV2Impl.verifyServerPublicParams(...)
    public let serverPublicParamsBase64 = "AMhf5ywVwITZMsff/eCyudZx9JDmkkkbV6PInzG4p8x3VqVJSFiMvnvlEKWuRob/1eaIetR31IYeAbm0NdOuHH8Qi+Rexi1wLlpzIo1gstHWBfZzy1+qHRV5A4TqPp15YzBPm0WSggW6PbSn+F4lf57VCnHF7p8SvzAA2ZZJPYJURt8X7bbg+H3i+PEjH9DXItNEqs2sNcug37xZQDLm7X0=="
}

// MARK: -

private class TSConstantsStaging: TSConstantsProtocol {

    public var mainServiceWebSocketAPI_identified: String {
        FeatureFlags.newHostNames
            ? "wss://chat.staging.signal.org/v1/websocket/"
            : "wss://textsecure-service-staging.whispersystems.org/v1/websocket/"
    }
    public var mainServiceWebSocketAPI_unidentified: String {
        FeatureFlags.newHostNames
            ? "wss://ud-chat.staging.signal.org/v1/websocket/"
            : "wss://textsecure-service-staging.whispersystems.org/v1/websocket/"
    }
    public var mainServiceURL: String {
        FeatureFlags.newHostNames
            ? "https://chat.staging.signal.org/"
            : "https://textsecure-service-staging.whispersystems.org/"
    }
    public let textSecureCDN0ServerURL = "https://cdn-staging.signal.org"
    public let textSecureCDN2ServerURL = "https://cdn2-staging.signal.org"
    public let contactDiscoveryURL = "https://api-staging.directory.signal.org"
    public let keyBackupURL = "https://api-staging.backup.signal.org"
    public let storageServiceURL = "https://storage-staging.signal.org"
    public let sfuURL = "https://sfu.staging.voip.signal.org"
    // There's no separate test SFU for staging.
    public let sfuTestURL = "https://sfu.test.voip.signal.org"
    public let kUDTrustRoot = "BbqY1DzohE4NUZoVF+L18oUPrK3kILllLEJh2UnPSsEx"

    public let censorshipReflectorHost = "europe-west1-signal-cdn-reflector.cloudfunctions.net"

    public let serviceCensorshipPrefix = "service-staging"
    public let cdn0CensorshipPrefix = "cdn-staging"
    public let cdn2CensorshipPrefix = "cdn2-staging"
    public let contactDiscoveryCensorshipPrefix = "directory-staging"
    public let keyBackupCensorshipPrefix = "backup-staging"
    public let storageServiceCensorshipPrefix = "storage-staging"

    // CDS uses the same EnclaveName and MrEnclave
    public let contactDiscoveryEnclaveName = "c98e00a4e3ff977a56afefe7362a27e4961e4f19e211febfbb19b897e6b80b15"
    public var contactDiscoveryMrEnclave: String {
        return contactDiscoveryEnclaveName
    }

    public let keyBackupEnclave = KeyBackupEnclave(
        name: "dcd2f0b7b581068569f19e9ccb6a7ab1a96912d09dde12ed1464e832c63fa948",
        mrenclave: "9db0568656c53ad65bb1c4e1b54ee09198828699419ec0f63cf326e79827ab23",
        serviceId: "446a6e51956e0eed502c6d9626476cea5b7278829098c34ca0cdce329753a8ee"
    )

    // An array of previously used enclaves that we should try and restore
    // key material from during registration. These must be ordered from
    // newest to oldest, so we check the latest enclaves for backups before
    // checking earlier enclaves.
    public let keyBackupPreviousEnclaves = [
        KeyBackupEnclave(
            name: "823a3b2c037ff0cbe305cc48928cfcc97c9ed4a8ca6d49af6f7d6981fb60a4e9",
            mrenclave: "a3baab19ef6ce6f34ab9ebb25ba722725ae44a8872dc0ff08ad6d83a9489de87",
            serviceId: "16b94ac6d2b7f7b9d72928f36d798dbb35ed32e7bb14c42b4301ad0344b46f29"
        )
    ]

    public let applicationGroup = "group.com.mobilecoin.signal.staging.group"

    // We need to discard all profile key credentials if these values ever change.
    // See: GroupsV2Impl.verifyServerPublicParams(...)
    public let serverPublicParamsBase64 = "ABSY21VckQcbSXVNCGRYJcfWHiAMZmpTtTELcDmxgdFbtp/bWsSxZdMKzfCp8rvIs8ocCU3B37fT3r4Mi5qAemeGeR2X+/YmOGR5ofui7tD5mDQfstAI9i+4WpMtIe8KC3wU5w3Inq3uNWVmoGtpKndsNfwJrCg0Hd9zmObhypUnSkfYn2ooMOOnBpfdanRtrvetZUayDMSC5iSRcXKpdls=="
}
