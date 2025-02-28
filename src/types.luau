export type DeviceType = "Desktop" | "Touch" | "Controller"
export type Map<T> = { [Enum | string]: T } & { Enum.KeyCode | Enum.UserInputType }
export type Input<T> = {
    read: (controller: number?) -> (T, T),
    pressing: (controller: number?) -> boolean,
    pressed: (controller: number?) -> boolean,
    released: (controller: number?) -> boolean,
    changed: (controller: number?) -> boolean,
    hold: (value: T?, controller: number?) -> (),
    move: (value: T?, controller: number?) -> (),
    map: (keyMap: Map<T>) -> nil,
    update: () -> nil,
}

export type InputConstructor = <T>(Map<T>) -> Input<T>


export type Axis = {
    device: (any) -> DeviceType,
    update: (inputs: { [any]: Input<any> } ) -> nil,
    clear: (any) -> nil,
    input: InputConstructor,
}

return {}