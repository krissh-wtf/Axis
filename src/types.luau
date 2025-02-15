export type DeviceType = "Desktop" | "Touch" | "Controller"
export type Map = { [Enum | string]: number | Vector2 | nil }
export type Input = (Map) -> { 
    read: () -> number,
    pressing: () -> boolean,
    pressed: () -> boolean,
    released: () -> boolean,
    changed: () -> boolean,
    hold: (value: number) -> (),
    map: (Map) -> nil,
}
export type axis = {
    device: DeviceType?,
    update: (inputs: { [string]: Input } ) -> nil,
    clear: () -> nil
}

return {}