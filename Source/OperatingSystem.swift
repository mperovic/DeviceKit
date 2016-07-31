//===----------------------------------------------------------------------===//
//
// This source file is part of the DeviceKit project
//
// Copyright © 2015 - 2016 Dennis Weissmann and all project contributors
//
//===----------------------------------------------------------------------===//

import class Foundation.ProcessInfo
import struct Foundation.OperatingSystemVersion
import var Darwin.sys.sysctl.CTL_KERN
import var Darwin.sys.sysctl.KERN_OSVERSION

/**
 This enum provides information about the operating system the app is running
 on. It is not bound to a specific device which means that possible future
 combinations like macOS on an iPad or Linux on an iPhone can be represented.

 - iOS:     The operating system is iOS
 - watchOS: The operating system is watchOS
 - tvOS:    The operating system is tvOS
 - macOS:   The operating system is macOS
 - linux:   The operating system is Linux
 - android: The operating system is Android
 - freeBSD: The operating system is FreeBSD
 */
public enum OperatingSystem: CustomStringConvertible {

  case iOS(version: OperatingSystemVersion)
  case watchOS(version: OperatingSystemVersion)
  case tvOS(version: OperatingSystemVersion)
  case macOS(version: OperatingSystemVersion)
  case linux(version: OperatingSystemVersion)
  case android(version: OperatingSystemVersion)
  case freeBSD(version: OperatingSystemVersion)

  public init() {
    let version = ProcessInfo.processInfo.operatingSystemVersion
    #if os(iOS)
      self = .iOS(version: version)
    #elseif os(watchOS)
      self = .watchOS(version: version)
    #elseif os(tvOS)
      self = .tvOS(version: version)
    #elseif os(OSX)
      self = .macOS(version: version)
    #elseif os(Linux)
      self = .linux(version: version)
    #elseif os(Android)
      self = android(version: version)
    #elseif os(FreeBSD)

    #endif
  }

  public var description: String {
    switch self {
    case .iOS: return "iOS"
    case .watchOS: return "watchOS"
    case .tvOS: return "tvOS"
    case .macOS: return "macOS"
    case .linux: return "Linux"
    case .android: return "Android"
    case .freeBSD: return "FreeBSD"
    }
  }

}

extension OperatingSystemVersion {

  private static func buildNumber() -> String? {
    return sysctl(identifier: [CTL_KERN, KERN_OSVERSION])
  }

}
