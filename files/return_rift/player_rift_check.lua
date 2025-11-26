print("a")
function teleported(from_x, from_y, to_x, to_y, is_portal)
    print("b")

    print(tostring(is_portal))
    print(tostring(GetParallelWorldPosition(from_x, from_y) ~= 0))
    print(tostring(GetParallelWorldPosition(to_x, to_y) == 0))
    --check if using portal from parallel world to main world
    if is_portal and (GetParallelWorldPosition(from_x, from_y) ~= 0) and (GetParallelWorldPosition(to_x, to_y) == 0) then
        print("yay :D")
    end
end