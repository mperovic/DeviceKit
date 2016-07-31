//===----------------------------------------------------------------------===//
//
// This source file is part of the DeviceKit project
//
// Copyright © 2015 - 2016 Dennis Weissmann and all project contributors
//
//===----------------------------------------------------------------------===//

import struct Darwin.sys.utsname
import func Darwin.sys.uname
import func Darwin.sys.getenv

public protocol _DeviceInternals {
  static var deviceIdentifier: String { get }
}

extension _DeviceInternals {

  public static var deviceIdentifier: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let mirror = Mirror(reflecting: systemInfo.machine)
    return mirror.children.reduce("") { identifier, element in
      if let scalar = element.value as? Int8, scalar != 0 {
        return identifier + String(UnicodeScalar(UInt8(scalar)))
      } else {
        return identifier
      }
    }
  }

}
