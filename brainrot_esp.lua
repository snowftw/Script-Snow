-- Brainrot ESP com menu interativo (console)
local options = {
  player_esp = false,
  base_esp = false,
  best_brainrot_esp = false,
}

local players = {
  {name="Snow", brainrot=150, x=100, y=220},
  {name="Alpha", brainrot=200, x=180, y=300},
  {name="Beta", brainrot=90, x=400, y=50},
}
local bases = {
  {owner="Snow", time_left=3600, x=110, y=230},
  {owner="Beta", time_left=600, x=410, y=60},
}

function findBestBrainrot(players)
  local best = players[1]
  for i, p in ipairs(players) do
    if p.brainrot > best.brainrot then best = p end
  end
  return best
end

function drawESP()
  if options.player_esp then
    for i, p in ipairs(players) do
      print(string.format("[PLAYER ESP] %s - Brainrot: %d - Pos: (%d,%d)", p.name, p.brainrot, p.x, p.y))
    end
  end
  if options.base_esp then
    for i, b in ipairs(bases) do
      print(string.format("[BASE ESP] Owner: %s - Decay em: %ds - Pos: (%d,%d)", b.owner, b.time_left, b.x, b.y))
    end
  end
  if options.best_brainrot_esp then
    local best = findBestBrainrot(players)
    print(string.format(">>> [BEST BRAINROT ESP] %s - Brainrot: %d - Pos: (%d,%d) <<<", best.name, best.brainrot, best.x, best.y))
  end
end

function showMenu()
  print("======= Brainrot ESP Menu =======")
  print("1. Toggle Player ESP [" .. tostring(options.player_esp) .. "]")
  print("2. Toggle Base Decay ESP [" .. tostring(options.base_esp) .. "]")
  print("3. Toggle Melhor Brainrot ESP [" .. tostring(options.best_brainrot_esp) .. "]")
  print("4. Mostrar ESP")
  print("5. Sair")
  print("Escolha uma opção (1-5):")
end

while true do
  showMenu()
  local choice = io.read()
  if choice == "1" then
    options.player_esp = not options.player_esp
  elseif choice == "2" then
    options.base_esp = not options.base_esp
  elseif choice == "3" then
    options.best_brainrot_esp = not options.best_brainrot_esp
  elseif choice == "4" then
    drawESP()
  elseif choice == "5" then
    print("Fechando menu!")
    break
  else
    print("Opção inválida!")
  end
end
