//===----------------------------------------------------------------------===//
//
// This source file is part of the DeviceKit project
//
// Copyright © 2015 - 2016 Dennis Weissmann and all project contributors
//
//===----------------------------------------------------------------------===//

public let currentDevice: Device = Phone() ?? Pad() ?? TV()!

@available(iOS 8.0, tvOS 9.0, watchOS 2.0, OSX 10.9, *)
public protocol Device: CustomStringConvertible, _DeviceInternals, _DeviceMappable {

  var name: String { get }
  var operatingSystem: OperatingSystem { get }
  var battery: Battery? { get }

}

extension Device {

  public var name: String { return "Unimplemented" }
  public var operatingSystem: OperatingSystem { return OperatingSystem() }
  public var battery: Battery? { return Battery() }

}

extension Device {

  fileprivate init?() {
    if let device = Self.mapIdentifierToDevice(identifier: Self.deviceIdentifier) as? Self {
      self = device
    } else {
      return nil
    }
  }

}
