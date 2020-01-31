local IsVisible = true

function ToggleChat() 
    if IsVisible then
        ShowChat(false)
        IsVisible = false
    else
        ShowChat(true)
        IsVisible = true
    end 
end

AddEvent("OnPackageStart", function()
    ToggleChat()
end)

AddEvent("OnKeyPress", function(key)
    if key == TOGGLE_CHAT_KEY then
        ToggleChat()
    end
end)
