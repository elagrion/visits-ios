import ComposableArchitecture
import Credentials
import DriverID
import Prelude
import PublishableKey
import RestorationState
import Visit


public struct StateRestorationEnvironment {
  public var loadState: () -> Effect<StorageState?, Never>
  public var saveState: (StorageState?) -> Effect<Never, Never>
  
  public init(
    loadState: @escaping () -> Effect<StorageState?, Never>,
    saveState: @escaping (StorageState?) -> Effect<Never, Never>
  ) {
    self.loadState = loadState
    self.saveState = saveState
  }
}

