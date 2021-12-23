import AppArchitecture
import ComposableArchitecture
import Types
import Utility


func reverseGeocode<Action>(
  rge: @escaping (Coordinate) -> Effect<GeocodedResult, Never>,
  toA: @escaping (GeocodedResult) -> Action,
  main: AnySchedulerOf<DispatchQueue>
) -> (Coordinate) -> Effect<Action, Never> {
  { c in
    rge(c)
      .map(toA)
      .receive(on: main)
      .eraseToEffect()
  }
}

public struct DestinationPickerState: Equatable {
  
  public var flow: DestinationPickerFlow
  public var place: GeoCodedResult?
}

public enum DestinationPickerAction {
  case changeFlow(DestinationPickerFlow)
  case pickAddress(Address)
  case pickCoordinate(Coordinate)
  case addressAction(ChoosingAddressAction)
  case coordinateAction(ChoosingCoordinateAction)
}

public let destinationPickerReducer =
  (choosingAddressP,
  choosingCoordinateP,
  destintionPickerFlowP)
    .combine)
