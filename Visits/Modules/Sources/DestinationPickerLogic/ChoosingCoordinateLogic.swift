import AppArchitecture
import ComposableArchitecture
import Types
import Utility

// MARK: - Action

public enum ChoosingCoordinateAction: Equatable {
  case liftedAddPlaceCoordinatePin
  case reverseGeocoded(GeocodedResult)
  case updatedAddPlaceCoordinate(Coordinate)
}

let choosingCoordinateActionPrism = /DestinationPickerAction.coordinateAction

// MARK: - Reducer

let choosingCoordinateP: Reducer<
  DestinationPickerState,
  DestinationPickerAction,
  SystemEnvironment<DestinationEnvironment>
> = choosingCoordinateReducer.pullback(
  state: \.adding ** Optional.prism ** \.flow ** /AddPlaceFlow.choosingCoordinate,
  action: choosingCoordinateActionPrism,
  environment: identity
)

let choosingCoordinateReducer = Reducer<GeocodedResult?, ChoosingCoordinateAction, SystemEnvironment<DestinationEnvironment>> { state, action, environment in
  let reverseGeocode = reverseGeocode(
    rge: environment.reverseGeocode,
    toA: ChoosingCoordinateAction.reverseGeocoded,
    main: environment.mainQueue
  )

  switch action {
  case .liftedAddPlaceCoordinatePin:

    state = nil

    return .none
  case let .reverseGeocoded(gr):
    guard gr.coordinate == state?.coordinate else { return .none}

    state = gr

    return .none
  case let .updatedAddPlaceCoordinate(c):

    state = .init(coordinate: c)

    return reverseGeocode(c)
  }
}
