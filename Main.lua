local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "MessagesUI"

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0.3, 0, 0.5, 0)
Frame.Position = UDim2.new(0.7, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Chat with BaconBot"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = Frame
ScrollingFrame.Size = UDim2.new(1, 0, 1, -80)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local MessageBox = Instance.new("TextBox")
MessageBox.Parent = Frame
MessageBox.Size = UDim2.new(1, 0, 0, 40)
MessageBox.Position = UDim2.new(0, 0, 1, -40)
MessageBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MessageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageBox.Font = Enum.Font.Gotham
MessageBox.TextSize = 18
MessageBox.PlaceholderText = "Type a message..."
MessageBox.TextXAlignment = Enum.TextXAlignment.Left

-- List of inappropriate words
local badWords = {
    "idiot", "idiots", "fuck", "stupid", "dumb", "dick", "cum", "cock"
}

-- Function to censor bad words
local function filterBadWords(message)
    for _, word in ipairs(badWords) do
        local pattern = "%f[%a]" .. word .. "%f[%A]"  -- Matches whole words only
        message = string.gsub(message, pattern, string.rep("#", #word))
    end
    return message
end

-- Function to Add Messages
local function logMessage(playerName, message, isBot)
    local MessageFrame = Instance.new("Frame")
    MessageFrame.Size = UDim2.new(1, -10, 0, 50)
    MessageFrame.BackgroundTransparency = 1
    MessageFrame.Parent = ScrollingFrame

    local ProfileImage = Instance.new("ImageLabel")
    ProfileImage.Parent = MessageFrame
    ProfileImage.Size = UDim2.new(0, 40, 0, 40)
    ProfileImage.Position = UDim2.new(0, 5, 0, 5)
    ProfileImage.Image = isBot and "rbxthumb://type=AvatarHeadShot&id=10802384&w=150&h=150" or "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    ProfileImage.BackgroundTransparency = 1

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = MessageFrame
    NameLabel.Position = UDim2.new(0, 50, 0, 5)
    NameLabel.Size = UDim2.new(1, -60, 0, 20)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = playerName
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 16
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Parent = MessageFrame
    MessageLabel.Position = UDim2.new(0, 50, 0, 25)
    MessageLabel.Size = UDim2.new(1, -60, 0, 20)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = filterBadWords(message) -- Filter message before displaying
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextSize = 14
    MessageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Expand Canvas Size Dynamically
    task.wait(0.05) -- Prevents lag
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- Bot Responses
local function getBotResponse(userMessage)
    local lowerMessage = string.lower(userMessage) -- Convert to lowercase for easier checking

    -- Check for bad words
    for _, word in pairs(badWords) do
        if string.find(lowerMessage, word) then
            return "Sorry, I can't respond to that inappropriate message."
        end
    end

    -- Simple Yes/No detection
    if lowerMessage == "yes" then return "Yes!"
    elseif lowerMessage == "no" then return "No!"
    end

    -- Random Responses
    local responses = {
        "Hello! How are you?",
        "That's interesting!",
        "Tell me more!",
        "Wow, really?",
        "I like talking to you!",
        "Hmm... I have to think about that.",
        "Nice!",
        "Haha, good one!",
        "Let's talk more!",
        "Sure!",
        "Maybe!",
        "I don't know...",
        "Why not?",
        "What do you mean?",
        "That's funny!",
        "I agree!",
        "No way!",
        "Sounds good to me!",
        "Let's do it!"
    }

    return responses[math.random(1, #responses)]
end

-- Send Messages + Bot Replies
MessageBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and MessageBox.Text ~= "" then
        local userMessage = MessageBox.Text
        MessageBox.Text = ""

        -- Show User Message
        logMessage(LocalPlayer.Name, userMessage, false)

        -- Bot Replies Quickly
        task.wait(math.random(1, 2)) -- Simulates quick response
        logMessage("BaconBot", getBotResponse(userMessage), true)
    end
end)
