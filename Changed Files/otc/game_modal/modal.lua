modalButton = nil
window = nil
trackerWindow = nil
settings = {}

local callDelay = 1000 -- each call delay is also increased by random values (0-callDelay/2)
local dispatcher = {}

function init()
  g_ui.importStyle('modalwindow')

  window = g_ui.createWidget('ModalWindow', rootWidget)
  window:hide()
  
  if not g_app.isMobile() then
    modalButton = modules.client_topmenu.addLeftGameButton('modalButton', tr('Modal Button'), '/images/topbuttons/questlog', function() g_game.requestQuestLog() end, false, 8)
  end
  
  connect(g_game, { onQuestLog = onGameQuestLog,
                    onGameEnd = offline,
                    onGameStart = online})
  online()
end

function terminate()
  disconnect(g_game, { onQuestLog = onGameQuestLog,
                       onGameEnd = offline,
                       onGameStart = online})

  offline()
  if modalButton then
    modalButton:destroy()
  end
end

function toggle()
  if trackerWindow:isVisible() then
    trackerWindow:hide()
  else
    trackerWindow:show()
  end
end

function offline()
  if window then
    window:hide()
  end
  if trackerWindow then
    trackerWindow:hide()
  end
  save()
  -- reset tracker
  trackerWindow.contentsPanel.list:destroyChildren()
  trackerWindow.contentsPanel.list:setHeight(0)
end

function online()
  local playerName = g_game.getCharacterName()
  if not playerName then return end -- just to be sure
  load()

  local playerName = g_game.getCharacterName()
  settings[playerName] = settings[playerName] or {}
  local settings = settings[playerName]


end

function show(questlog)
  if questlog then
    window:raise()
    window:show()
    window:focus()
    window.jumpButtonRight:setText('Jump!')
    window.jumpButtonLeft:setText('Jump!')
    window.jumpButtonLeft:hide()


    
  else
    window.questlog:setVisible(false)
    window.missionlog:setVisible(true)
    window.jumpButtonRight:setText('Back')
  end
end

function jumpLeft()
  window.jumpButtonRight:hide()
  window.jumpButtonLeft:show()
end

function jumpRight()
  window.jumpButtonRight:show()
  window.jumpButtonLeft:hide()
end

function showQuestLine()
  local questList = window.questlog.questList
  local child = questList:getFocusedChild()

  g_game.requestQuestLine(child.questId)
  window.missionlog.questName:setText(child.questName)
  window.missionlog.currentQuest = child.questId
end

function onGameQuestLog(quests)
  show(true)

  local questList = window.questlog.questList

  questList:destroyChildren()
  for i,questEntry in pairs(quests) do
    local id, name, completed = unpack(questEntry)

    local questLabel = g_ui.createWidget('QuestLabel', questList)
    questLabel:setChecked(i % 2 == 0)
    questLabel.questId = id -- for quest tracker
    questLabel.questName = name
    name = completed and name.." (completed)" or name
    questLabel:setText(name)
    questLabel.onDoubleClick = function()
      window.missionlog.currentQuest = id
      g_game.requestQuestLine(id)
      window.missionlog.questName:setText(questLabel.questName)
    end
  end
  questList:focusChild(questList:getFirstChild())
end


-- json handlers
function load()
  local file = "/settings/questlog.json"
  if g_resources.fileExists(file) then
    local status, result = pcall(function()
        return json.decode(g_resources.readFileContents(file))
    end)
    if not status then
        return g_logger.error(
                   "Error while reading profiles file. To fix this problem you can delete storage.json. Details: " ..
                       result)
    end
    settings = result
  end
end

function save()
  local file = "/settings/questlog.json"
  local status, result = pcall(function() return json.encode(settings, 2) end)
  if not status then
      return g_logger.error(
                 "Error while saving profile settings. Data won't be saved. Details: " ..
                     result)
  end
  if result:len() > 100 * 1024 * 1024 then
      return g_logger.error(
                 "Something went wrong, file is above 100MB, won't be saved")
  end
  g_resources.writeFileContents(file, result)
end