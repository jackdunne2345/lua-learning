function INITIAL_POSITION(x, y)
    if x < 0 then x = 0 end
    if x > 100 then x = 100 end
    if y < 0 then y = 0 end
    if y > 100 then y = 100 end
    return math.floor(SCREEN_WIDTH * x / 100+0.5), math.floor(SCREEN_HEIGHT * y / 100+0.5)
end
