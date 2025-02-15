export type DeviceType = "Desktop" | "Touch" | "Controller"
export type Map<T> = { [Enum | string]: T } & { Enum.KeyCode | Enum.UserInputType }
export type Input = <T>(Map<T>) -> { 
    read: () -> (T, T),
    pressing: () -> boolean,
    pressed: () -> boolean,
    released: () -> boolean,
    changed: () -> boolean,
    hold: (value: T) -> (),
    map: (keyMap: Map<T>) -> nil,
    update: () -> nil,
}


export type axis = {
    device: DeviceType?,
    update: (inputs: { [any]: Input<any> } ) -> nil,
    clear: () -> nil
}

return {}