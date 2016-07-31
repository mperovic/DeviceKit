//===----------------------------------------------------------------------===//
//
// This source file is part of the DeviceKit project
//
// Copyright © 2015 - 2016 Dennis Weissmann and all project contributors
//
//===----------------------------------------------------------------------===//

import func Darwin.C.stdlib.getenv

/**
 *  Semi-public protocol (should be private but we cannot (yet?) let a public
    protocol conform to a private one.
 */
public protocol _DeviceMappable {
  /**
   Maps an identifier to a type-erased `Device`.

   - parameter identifier: The identifier.

   - parameter isSimulator: Indicating whether or not the device is real.

   - returns: Either an initialized Phone, Pad, etc. (type-erased as `Device`)
              or nil.
   */
  static func mapIdentifierToDevice(identifier: String, isSimulator: Bool) -> Device?
}

extension _DeviceMappable {

  public static func mapIdentifierToDevice(identifier: String, isSimulator: Bool = false) -> Device? {
    switch identifier {
    case _ where identifier.hasPrefix("iPhone"):  return mapPhones(identifier: identifier, isSimulator: isSimulator)
    case _ where identifier.hasPrefix("iPad"):    return mapPads(identifier: identifier, isSimulator: isSimulator)
    case _ where identifier.hasPrefix("AppleTV"): return mapTVs(identifier: identifier, isSimulator: isSimulator)
    case "x86_64": return mapSimulatorsAndComputers(identifier: identifier, isSimulator: isSimulator)
    default: return nil
    }
  }

  /**
   Map iPhones from identifiers to enums (type erased as `Device?`)

   - parameter identifier: The identifier.

   - parameter isSimulator: Indicating whether or not the device is real.

   - returns: If the device is a real iPhone the corresponding device is
              returned, otherwise `nil`.
   */
  private static func mapPhones(identifier: String, isSimulator: Bool = false) -> Device? {
  let device: Phone
  switch identifier {
    case "iPhone3,1", "iPhone3,2", "iPhone3,3": device = Phone.iPhone4
    case "iPhone4,1":                           device = Phone.iPhone4s
    case "iPhone5,1", "iPhone5,2":              device = Phone.iPhone5
    case "iPhone5,3", "iPhone5,4":              device = Phone.iPhone5c
    case "iPhone6,1", "iPhone6,2":              device = Phone.iPhone5s
    case "iPhone7,2":                           device = Phone.iPhone6
    case "iPhone7,1":                           device = Phone.iPhone6Plus
    case "iPhone8,1":                           device = Phone.iPhone6s
    case "iPhone8,2":                           device = Phone.iPhone6sPlus
    case "iPhone8,4":                           device = Phone.iPhoneSE
    case _:                                     device = Phone.unknownPhone(identifier)
    }
    return isSimulator ? Phone.simulator(device) : device
  }

  /**
   Map iPads from identifiers to enums (type erased as `Device?`).

   - parameter identifier: The identifier.

   - parameter isSimulator: Indicating whether or not the device is real.

   - returns: If the device is a real iPad the corresponding device is
              returned, otherwise `nil`.
   */
  private static func mapPads(identifier: String, isSimulator: Bool = false) -> Device? {
    let device: Pad
    switch identifier {
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":  device = Pad.iPad2
    case "iPad3,1", "iPad3,2", "iPad3,3":             device = Pad.iPad3
    case "iPad3,4", "iPad3,5", "iPad3,6":             device = Pad.iPad4
    case "iPad4,1", "iPad4,2", "iPad4,3":             device = Pad.iPadAir
    case "iPad5,3", "iPad5,4":                        device = Pad.iPadAir2
    case "iPad2,5", "iPad2,6", "iPad2,7":             device = Pad.iPadMini
    case "iPad4,4", "iPad4,5", "iPad4,6":             device = Pad.iPadMini2
    case "iPad4,7", "iPad4,8", "iPad4,9":             device = Pad.iPadMini3
    case "iPad5,1", "iPad5,2":                        device = Pad.iPadMini4
    case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":  device = Pad.iPadPro
    case _:                                           device = Pad.unknownPad(identifier)
    }
    return isSimulator ? Pad.simulator(device) : device
  }

  /**
   Map TVs from identifiers to enums (type erased as `Device?`).

   - parameter identifier: The identifier.

   - parameter isSimulator: Indicating whether or not the device is real.

   - returns: If the device is a real TV the corresponding device is
              returned, otherwise `nil`.
   */
  private static func mapTVs(identifier: String, isSimulator: Bool = false) -> Device? {
    let device: TV
    switch identifier {
    case "AppleTV5,3":  device = TV.TV4
    case _:             device = TV.unknownTV(identifier)
    }
    return isSimulator ? TV.simulator(device) : device
  }

  /**
   Map simulators and real devices from identifiers to enums
   (type erased as `Device?`).

   - parameter identifier: The identifier.

   - parameter isSimulator: Indicating whether or not the device is real.

   - returns: If the device is a simulator or a `Computer` iPad the
              corresponding device is returned, otherwise `nil`.
   */
  private static func mapSimulatorsAndComputers(identifier: String, isSimulator: Bool = false) -> Device? {
    // Simulator?
    // Compiler warning needs to be ignored, getenv returns an IUO which is only set in simulators
    if let env = getenv("SIMULATOR_MODEL_IDENTIFIER"), env != nil {
      if case let simID = String(cString: env), simID.characters.count > 0 {
        return mapIdentifierToDevice(identifier: simID, isSimulator: true)
      }
    } else {
      // is Computer
      // TODO
      return nil
    }
return nil
  }

}
