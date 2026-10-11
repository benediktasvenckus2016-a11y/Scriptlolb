local SAB_LIVE = function() return true end
local _SABCAP = {}
if not LPH_OBFUSCATED then
    local ok, env = pcall(getfenv)
    local _envs = {}
    if ok and type(env) == "table" then _envs[#_envs + 1] = env end
    if getgenv then local gok, g = pcall(getgenv); if gok and type(g) == "table" then _envs[#_envs + 1] = g end end
    if type(_G) == "table" then _envs[#_envs + 1] = _G end
    for _, e in ipairs(_envs) do
        if not e["LPH_ATTRIBUTES"] then e["LPH_ATTRIBUTES"] = function() end end
        if not e["VM"]     then e["VM"]     = function() end end
        if not e["PRESET"] then e["PRESET"] = function() end end
        if not e["ERROR_HANDLING"] then e["ERROR_HANDLING"] = function() end end
        if not e["LPH_ENCSTR"] then e["LPH_ENCSTR"] = function(s) return s end end
        if not e["LPH_ENCNUM"] then e["LPH_ENCNUM"] = function(n) return n end end
    end end
-- FAST OFF-LOAD TP (Meerko method): read the authoritative synchronizer/channel
-- AnimalList (instant + accurate) instead of waiting for workspace models to stream.
-- This is rose's own sync-scan path (SharedState.ScanAllPlots), just enabled by default.
if _G.JAF_NoSynchronizer   == nil then _G.JAF_NoSynchronizer   = false end
if _G.JAF_ScanViaInstances == nil then _G.JAF_ScanViaInstances = true  end
if _G.JAF_WaitBasesBeforeTp == nil then _G.JAF_WaitBasesBeforeTp = false end
_G.JAF_M2 = function(ax, az, bx, bz) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local dx, dz = ax - bx, az - bz
    return math.sqrt(dx * dx + dz * dz)
end
local _P; _P = function(o, ...) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            for i = 1, select("#", ...), 2 do o[select(i, ...)] = select(i + 1, ...) end return o end
do
    local _clsMemo = {}
    local _isACN; _isACN = (function(cn, inst, cls) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if _G.JAF_ClassMemo == false then return inst:IsA(cls) end
        local m = _clsMemo[cls]
        if not m then m = {}; _clsMemo[cls] = m end
        local v = m[cn]
        if v == nil then v = inst:IsA(cls); m[cn] = v end
        return v
    end)
    _G.JAF_IsACN = _isACN
    _G.JAF_IsA = (function(inst, cls) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if _G.JAF_ClassMemo == false then return inst:IsA(cls) end
        return _isACN(inst.ClassName, inst, cls)
    end) end
_G.JAF_BootReady = false
if _G.JAF_BootYield == false then _G.JAF_BootReady = true end
if _G.JAF_BootYield ~= false then
    task.spawn(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local t0 = os.clock()
        local cap = tonumber(_G.JAF_BootYieldMax) or 20
        if not game:IsLoaded() then game.Loaded:Wait() end
        local RS = game:GetService("ReplicatedStorage")
        local pkgs = RS:WaitForChild("Packages", 10)
        local netF = pkgs and pkgs:WaitForChild("Net", 10)
        if netF then
            local last, stable = -1, 0
            while os.clock() - t0 < cap do
                local n = #netF:GetChildren()
                if n == last and n > 0 then
                    stable = stable + 1
                    if stable >= 2 then break end
                else
                    stable, last = 0, n
                end
                task.wait(0.2)
            end end
        _G.JAF_BootYieldTook = os.clock() - t0
    end)
    _G.JAF_BootReady = true
    end) end
if not game:IsLoaded() then game.Loaded:Wait() end
do
    local _efOn = true
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if type(isfile) == "function" and type(readfile) == "function" and isfile("rosehub.json") then
            local d = game:GetService("HttpService"):JSONDecode(readfile("rosehub.json"))
            if type(d) == "table" and d.FpsOptimizer == false then _efOn = false end
        end end)
    if _efOn then
        local _efPlayers = game:GetService("Players")
        local _efCls = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory",
            "FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory",
            "BackAccessory","WaistAccessory"}
        local function _efStrip(obj, isOther) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            if _G.JAF_FpsOptimizer == false then return end
            pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                if obj.Name == "Overhead" then return end
                for _, c in ipairs(_efCls) do if obj:IsA(c) then obj:Destroy(); return end end
                if isOther and obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                    local s = obj.Size
                    if s.X > 10 or s.Y > 10 or s.Z > 10 then
                        _P(obj, "Transparency", 1, "Transparency", 1, "CanCollide", false, "CanQuery", false, "CanTouch", false, "CastShadow", false)
                    end end end) end
        local function _efChar(char) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            if not char then return end
            local _lp = _efPlayers.LocalPlayer
            local isOther = (_lp ~= nil) and (_efPlayers:GetPlayerFromCharacter(char) ~= _lp)
            task.spawn(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                for _, d in ipairs(char:GetDescendants()) do _efStrip(d, isOther) end
            end)
            char.DescendantAdded:Connect(function(d) LPH_ATTRIBUTES(ERROR_HANDLING(false))
task.defer(_efStrip, d, isOther) end)
        end
        local function _efHook(plr) LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if plr.Character then _efChar(plr.Character) end
            plr.CharacterAdded:Connect(_efChar)
        end
        for _, plr in ipairs(_efPlayers:GetPlayers()) do pcall(_efHook, plr) end
        _efPlayers.PlayerAdded:Connect(_efHook)
    end end
_G.SAB_T_GameLoaded = tick()
if not _G.JAF_WaitPackages then
    local _pkgCache
    _G.JAF_WaitPackages = function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if _pkgCache and _pkgCache.Parent then return _pkgCache end
        local RS = game:GetService("ReplicatedStorage")
        local p = RS:FindFirstChild("Packages")
        while not p do p = RS:WaitForChild("Packages", 5) end
        _pkgCache = p
        return p
    end end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _SyncReal = nil
-- use the getgc-based channel reader instead of require()-ing / calling the
-- Synchronizer module (same approach the working Extras/Teleport hubs use).
if _G.JAF_NoSynchronizer == nil then _G.JAF_NoSynchronizer = true end
local _SyncProxy
local function _syncMod() LPH_ATTRIBUTES(ERROR_HANDLING(false))
    if _G.JAF_NoSynchronizer == true then return nil end
    if _SyncReal ~= nil then return _SyncReal end
    local ok, m = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Synchronizer")) end)
    if ok and type(m) == "table" then _SyncReal = m end
    return _SyncReal
end
_G.JAF_SyncMod = _syncMod
_G.JAF_SyncModLoaded = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return _SyncReal ~= nil end
_SyncProxy = setmetatable({}, {
    __index = function(_, k) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        local m = _syncMod(); if not m then return nil end
        local v = m[k]
        if type(v) ~= "function" then return v end
        return function(a, ...) LPH_ATTRIBUTES(ERROR_HANDLING(false))
if rawequal(a, _SyncProxy) then return v(m, ...) end return v(a, ...) end
    end,
    __newindex = function(_, k, v) LPH_ATTRIBUTES(ERROR_HANDLING(false))
local m = _syncMod(); if m then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
m[k] = v end) end end,
})
local Synchronizer = _SyncProxy
task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
local t0 = os.clock() _syncMod() _G.JAF_SyncModWarmMs = (os.clock() - t0) * 1000 end)
_G.JAF_Mod = (function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
    local cache = {}
    return function(folder, name) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local key = folder .. "." .. name
        local hit = cache[key]
        if hit ~= nil then return hit or nil end
        local ok, mod = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            local RS2 = game:GetService("ReplicatedStorage")
            return require(RS2:WaitForChild(folder, 10):WaitForChild(name, 10))
        end)
        cache[key] = (ok and mod) or false
        return cache[key] or nil
    end end)()
do
    local _RS = game:GetService("ReplicatedStorage")
    local _D  = _RS:WaitForChild("Datas")
    local okA, _A = pcall(require, _D:WaitForChild("Animals"))
    local okG, _G_ = pcall(require, _D:WaitForChild("Game"))
    local okM, _M = pcall(require, _D:WaitForChild("Mutations"))
    local okT, _T = pcall(require, _D:WaitForChild("Traits"))
    _G.JAF_SafeGen = function(index, mutation, traits, _player) LPH_ATTRIBUTES(PRESET(FAST), ERROR_HANDLING(false))
        if _G.JAF_UseGameGen == true then
            local okX, vX = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return require(_RS.Shared.Animals):GetGeneration(index, mutation, traits, nil) end)
            if okX then return vX end
        end
        if not (okA and _A) then return 0 end
        local e = _A[index]
        if not e then return 0 end
        local base = e.Generation
        if not base then local mod = (okG and _G_ and _G_.Game and _G_.Game.AnimalGanerationModifier) or 0 base = (e.Price or 0) * mod end
        local mult, sleepy = 1, false
        local _mu = mutation and okM and _M and _M[mutation]
        if _mu then mult = mult + (_mu.Modifier or 0) end
        if traits and okT and _T then
            for _, t in pairs(traits) do
                local tr = _T[t]
                if tr then if t == "Sleepy" then sleepy = true else mult = mult + (tr.MultiplierModifier or 0) end end
            end end
        local v = base * mult
        if sleepy then v = v * 0.5 end
        return math.round(v)
    end end
_G.Synchronizer = Synchronizer
if _G.JAF_NoSynchronizer == nil then _G.JAF_NoSynchronizer = true end
if _G.JAF_NoCarpetScan   == nil then _G.JAF_NoCarpetScan   = false end
if _G.JAF_NoUpvalues == nil then _G.JAF_NoUpvalues = true end
if _G.JAF_NoFSHook   == nil then _G.JAF_NoFSHook   = true end
_G.JAF_UseGameGen = false
do
    local realT = getfenv(0)
    local BAD = {
        writefile=1, readfile=1, appendfile=1, isfile=1, delfile=1, listfiles=1, makefolder=1,
        isfolder=1, delfolder=1, loadstring=1, hookfunction=1, hookmetamethod=1, newcclosure=1,
        getgenv=1, getrenv=1, getreg=1, getgc=1, getrawmetatable=1, setrawmetatable=1, setreadonly=1,
        getconnections=1, firesignal=1, gethui=1, get_hidden_gui=1, getcustomasset=1, setclipboard=1,
        queue_on_teleport=1, getscriptclosure=1, getscriptbytecode=1, decompile=1, identifyexecutor=1,
        getexecutorname=1, request=1, http_request=1, syn=1, protect_gui=1, checkcaller=1,
        islclosure=1, iscclosure=1, clonefunction=1, getcallingscript=1, getnilinstances=1,
        setthreadidentity=1, getthreadidentity=1, set_thread_identity=1, get_thread_identity=1,
    }
    local cleanT = setmetatable({}, {
        __index    = function(_, k) LPH_ATTRIBUTES(ERROR_HANDLING(false))
if BAD[k] then return nil end return realT[k] end,
        __newindex = function(_, k, v) LPH_ATTRIBUTES(ERROR_HANDLING(false))
realT[k] = v end,
    })
    local function safeCall(f, ...) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if _G.JAF_NoSafeCall == true then return pcall(f, ...) end
        local args = table.pack(...)
        local body = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
setfenv(0, cleanT) return table.pack(pcall(f, table.unpack(args, 1, args.n))) end
        setfenv(body, cleanT)
        local co = coroutine.create(body)
        local ok, packed = coroutine.resume(co)
        if not ok then return false, packed end
        if type(packed) ~= "table" then return false, "safeCall: target yielded" end
        return table.unpack(packed, 1, packed.n)
    end
    _G.JAF_SafeCall = safeCall
    local chanCache = setmetatable({}, {__mode = "k"})
    local function wrapChannel(ch) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if ch == nil or (type(ch) ~= "table" and type(ch) ~= "userdata") then return ch end
        local hit = chanCache[ch]; if hit then return hit end
        local w = setmetatable({}, {
            __index = function(_, k) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local v = ch[k]
                if type(v) ~= "function" then return v end
                return function(_, ...) LPH_ATTRIBUTES(ERROR_HANDLING(false))
local ok, r = safeCall(v, ch, ...) if not ok then return nil end return r end
            end,
            __newindex = function(_, k, v) LPH_ATTRIBUTES(ERROR_HANDLING(false))
ch[k] = v end,
        })
        chanCache[ch] = w
        return w
    end
    _G.JAF_WrapChannel = wrapChannel
    local _chanTable, _chanAt = nil, 0
    local HEAP_MIN = 24
    local heapScanAsync
    local _heapBusy, _heapDone, _missAt = false, false, 0
    local RETRY_COOLDOWN = 3
    local _heapMissAt = 0
    local HEAP_RETRY  = 5
    local GUIDPAT_C = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
    local function _looksLikeRegistry(t) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if type(t) ~= "table" then return false end
        local hits, n = 0, 0
        for k, chan in pairs(t) do
            n = n + 1
            if n > 64 then break end
            if type(k) == "string" and #k == 36 and k:match(GUIDPAT_C) and type(chan) == "table"
               and type(rawget(chan, "CacheTable")) == "table" then
                hits = hits + 1
                if hits >= 3 then return true end
            end end
        return false
    end
    _G.JAF_ChanValid = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return _looksLikeRegistry(_chanTable) end
    local _needCache, _needAt, _haveCache = 0, 0, 0
    local _pulled = {}
    local _pullT0 = tick()      -- ⭐own clock: JAF_HubStart is defined much later in the file
    _G.JAF_Pulled = _pulled
    local function _requestData(name) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        local pk = ReplicatedStorage:FindFirstChild("Packages")
        local sy = pk and pk:FindFirstChild("Synchronizer")
        local rf = sy and sy:FindFirstChild("RequestData")
        if not rf or not rf:IsA("RemoteFunction") then return nil end
        local ok, res = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return rf:InvokeServer(name) end)
        if ok and type(res) == "table" then return res end
        return nil
    end
    _G.JAF_PullPlot = function(name) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        local ct = _requestData(name)
        if ct then
            _pulled[name] = ct
            _G.JAF_PullOk = (tonumber(_G.JAF_PullOk) or 0) + 1
        else
            _G.JAF_PullFail = (tonumber(_G.JAF_PullFail) or 0) + 1
        end
        return ct
    end
    local function _instanceChans() LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if not (getconnections and debug and debug.getupvalues) then return nil end
        local pk = ReplicatedStorage:FindFirstChild("Packages")
        local sy = pk and pk:FindFirstChild("Synchronizer")
        local cf = sy and sy:FindFirstChild("Channel")
        if not cf then return nil end
        local map, n = {}, 0
        for _, re in ipairs(cf:GetChildren()) do
            if re:IsA("RemoteEvent") then
                local okC, conns = pcall(getconnections, re.OnClientEvent)
                if okC and type(conns) == "table" then
                    for _, conn in ipairs(conns) do
                        local okF, f = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return conn.Function end)
                        if okF and type(f) == "function" then
                            local okU, uvs = pcall(debug.getupvalues, f)
                            if okU and type(uvs) == "table" then
                                for _, uv in ipairs(uvs) do
                                    if type(uv) == "table" and type(rawget(uv, "CacheTable")) == "table" then
                                        map[re.Name] = uv
                                        n = n + 1
                                        break
                                    end end end end
                        if map[re.Name] then break end
                    end end end end
        local function _realCount(c) LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if type(c) ~= "table" then return -1 end
            local al = rawget(c, "AnimalList") or rawget(c, "Animals")
            if type(al) ~= "table" then return -1 end
            local n2 = 0
            for _, a in pairs(al) do if type(a) == "table" then n2 = n2 + 1 end end
            return n2
        end
        local _inWindow = (tick() - _pullT0) < (tonumber(_G.JAF_PullTrustWindow) or 15)
        if not _inWindow and next(_pulled) ~= nil then
            local anyLive = false
            for kk in pairs(_pulled) do
                local c2 = map[kk]
                if c2 and _realCount(rawget(c2, "CacheTable")) >= 0 then anyLive = true break end
            end
            if anyLive then
                table.clear(_pulled)
                _G.JAF_PullDropped = (tonumber(_G.JAF_PullDropped) or 0) + 1
            end
        end
        for k, ct in pairs(_pulled) do
            local cur   = map[k]
            local curCT = cur and rawget(cur, "CacheTable")
            if cur == nil then
                map[k] = { CacheTable = ct }
                n = n + 1
            elseif _inWindow and _realCount(ct) > _realCount(curCT) then
                map[k] = { CacheTable = ct }
                _G.JAF_PullPreferred = (tonumber(_G.JAF_PullPreferred) or 0) + 1
            end end
        if n == 0 then return nil end
        _G.JAF_ChanInstCount = n
        if not _G.JAF_ChansFirstAt then _G.JAF_ChansFirstAt = tick() end
        return map
    end
    _G.JAF_InstanceChans = _instanceChans
    if _G.JAF_PullOnJoin ~= false then
        task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            local t0 = os.clock()
            local plotsF = workspace:FindFirstChild("Plots") or workspace:WaitForChild("Plots", 10)
            if not plotsF then return end
            local kids = plotsF:GetChildren()
            local left = #kids
            for _, pl in ipairs(kids) do task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_G.JAF_PullPlot(pl.Name) left = left - 1 end) end
            local t1 = os.clock()
            while left > 0 and (os.clock() - t1) < 8 do task.wait(0.02) end
            _G.JAF_PullMs = (os.clock() - t0) * 1000
            local got = 0 ; for _ in pairs(_pulled) do got = got + 1 end
            local function allSettled() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                for _, ct in pairs(_pulled) do
                    if type(ct) == "table" and rawget(ct, "Owner") ~= nil then
                        local al = rawget(ct, "AnimalList") or rawget(ct, "Animals")
                        local real = 0
                        if type(al) == "table" then
                            for _, a in pairs(al) do if type(a) == "table" then real = real + 1 end end
                        end
                        if real == 0 then return false end   -- owned base, still empty -> ask again
                    end
                end
                return true
            end
            local rounds = math.clamp(tonumber(_G.JAF_PullRetries) or 4, 0, 8)
            for r = 1, rounds do
                if allSettled() then break end
                task.wait(tonumber(_G.JAF_PullRetryGap) or 0.4)
                local n2 = #kids
                for _, pl in ipairs(kids) do task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_G.JAF_PullPlot(pl.Name) ; n2 = n2 - 1 end) end
                local t2 = os.clock()
                while n2 > 0 and (os.clock() - t2) < 5 do task.wait(0.02) end
                _G.JAF_PullRounds = r
                if allSettled() then
                    if _G.JAF_JoinMark then _G.JAF_JoinMark("pullSettled", "round " .. r) end
                    break
                end
            end end) end
    local ANIMAL_KEYS = { "Animals", "AnimalList" }
    local function animalsOf(cacheTable) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if type(cacheTable) ~= "table" then return nil end
        for _, k in ipairs(ANIMAL_KEYS) do local v = rawget(cacheTable, k) if type(v) == "table" then return v end end
        return nil
    end
    _G.JAF_AnimalsOf = animalsOf
    _G.JAF_OwnerName = function(o) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if o == nil then return nil end
        if typeof(o) == "Instance" then return o.Name end
        if type(o) == "table"  then return o.Name end
        if type(o) == "string" then if o == "" or o == "..." then return nil end return o end
        return nil
    end
    _G.JAF_OwnerPlayer = function(o) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if typeof(o) == "Instance" and o:IsA("Player") then return o end
        if type(o) == "table" and o.UserId then return game:GetService("Players"):GetPlayerByUserId(o.UserId) end
        local n = _G.JAF_OwnerName(o)
        return n and game:GetService("Players"):FindFirstChild(n) or nil
    end
    local function _findChans() LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if _G.JAF_ChanInstOff ~= true then
            local _now = tick()
            if (_now - _needAt) > 2 then
                local _pl = workspace:FindFirstChild("Plots")
                _needCache, _needAt = (_pl and #_pl:GetChildren() or 0), _now
            end
            local _need     = _needCache
            local _have     = _haveCache
            local _complete = (_need > 0 and _have >= _need)
            if _complete and _G.JAF_ChanSource == "instances" and _chanTable and next(_chanTable) ~= nil
               and (tick() - _chanAt) < (tonumber(_G.JAF_ChanInstTTL) or 1) then
                return _chanTable
            end
            local m = _instanceChans()
            if m then
                if _chanTable then for k, v in pairs(_chanTable) do if m[k] == nil then m[k] = v end end end
                local mn = 0 ; for _ in pairs(m) do mn = mn + 1 end
                _chanTable, _chanAt = m, tick()
                _haveCache          = mn
                _G.JAF_ChanSource   = "instances"
                _G.JAF_ChanHave, _G.JAF_ChanNeed = mn, _need
                if _need > 0 and mn < _need then
                    _G.JAF_ChanPartial = (tonumber(_G.JAF_ChanPartial) or 0) + 1
                    if heapScanAsync then pcall(heapScanAsync) end
                end
                return m
            end end
        if _chanTable and not _looksLikeRegistry(_chanTable) then
            _chanTable = nil
            _haveCache = 0
            _heapDone  = false
            _G.JAF_ChanEvictions = (tonumber(_G.JAF_ChanEvictions) or 0) + 1
        end
        if _chanTable and next(_chanTable) ~= nil then return _chanTable end
        if _chanTable and (tick() - _chanAt) < 5 then return _chanTable end
        if (tick() - _missAt) < RETRY_COOLDOWN then return _chanTable end
        local best, bestScore = nil, 0
        pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            local BUDGET, seen = 30000, {}
            local function score(t) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local withCache, withAL, n = 0, 0, 0
                for _, v in next, t do
                    n = n + 1; if n > 400 then break end
                    if type(v) == "table" then
                        local c = rawget(v, "CacheTable")
                        if type(c) == "table" then withCache = withCache + 1 if animalsOf(c) then withAL = withAL + 1 end end
                    end end
                return withCache + withAL * 10
            end
            heapScanAsync = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                if not getgc then return end
                if _heapBusy or _heapDone then return end
                if (tick() - _heapMissAt) < HEAP_RETRY then return end
                _heapBusy = true
                task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                    local ok, gc = pcall(getgc, true)
                    if not ok or type(gc) ~= "table" then _heapBusy, _heapMissAt = false, tick() return end
                    local SLICE = math.clamp(tonumber(_G.JAF_HeapSliceMs) or 4, 1, 16) / 1000
                    local _lastYield = os.clock()
                    local GUIDPAT = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
                    local best, bestGuid, bestAnimals, cands, since = nil, 0, -1, 0, 0
                    for i = 1, #gc do
                        local v = gc[i]
                        if type(v) == "table" then
                            pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                                local guidHits, animals, n = 0, 0, 0
                                for k, chan in pairs(v) do
                                    n = n + 1
                                    if n > 64 then return end
                                    if type(k) == "string" and k:match(GUIDPAT) and type(chan) == "table" then
                                        local ct = rawget(chan, "CacheTable")
                                        if type(ct) == "table" then
                                            guidHits = guidHits + 1
                                            local al = rawget(ct, "AnimalList")
                                            if type(al) == "table" then
                                                for _, a in pairs(al) do if type(a) == "table" then animals = animals + 1 end end
                                            end end end end
                                if guidHits >= 3 then
                                    cands = cands + 1
                                    if guidHits > bestGuid or (guidHits == bestGuid and animals > bestAnimals) then
                                        best, bestGuid, bestAnimals = v, guidHits, animals
                                    end end end) end
                        if (os.clock() - _lastYield) >= SLICE then task.wait() _lastYield = os.clock() since = since + 1 end
                    end
                    _G.JAF_HeapYields = since
                    if best then
                        _chanTable, _chanAt = best, tick()
                        do local _hc = 0 for _ in pairs(best) do _hc = _hc + 1 end _haveCache = _hc end
                        _G.JAF_ChanGuids   = bestGuid
                        _G.JAF_ChanCands   = cands
                        _G.JAF_ChanSource  = "heap-validated"
                    end
                    _heapBusy = false
                    if best then
                        _heapDone = true
                    else
                        _heapMissAt = tick()
                        _G.JAF_HeapMisses = (tonumber(_G.JAF_HeapMisses) or 0) + 1
                    end end) end
            _G.JAF_HeapRescan = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_heapDone, _heapBusy, _chanTable = false, false, nil heapScanAsync() end
            _G.JAF_HeapScan = heapScanAsync
            if _G.JAF_HeapWarm ~= false then
                task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
local t0 = os.clock() pcall(heapScanAsync) _G.JAF_HeapWarmMs = (os.clock() - t0) * 1000 end)
            end
            local function scan(v, depth) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                BUDGET = BUDGET - 1
                if BUDGET <= 0 or depth > 7 then return end
                local tv = type(v)
                if tv == "table" then
                    if seen[v] then return end; seen[v] = true
                    local n = 0
                    for _ in next, v do n = n + 1; if n > 600 then return end end
                    local s = score(v)
                    if s > bestScore then best, bestScore = v, s end
                    for _, val in next, v do scan(val, depth + 1) end
                elseif tv == "function" then
                    if seen[v] then return end; seen[v] = true
                    local oku, ups = pcall(debug.getupvalues, v)
                    if oku and type(ups) == "table" then for _, u in next, ups do scan(u, depth + 1) end end
                end end
            for _, fn in next, (_syncMod() or {}) do if type(fn) == "function" then pcall(scan, fn, 0) end end
        end)
        if best and bestScore >= HEAP_MIN then
            _chanTable, _chanAt = best, tick()
            _G.JAF_ChanSource = "upvalues"
        else
            _missAt = tick()
            if not _chanTable then heapScanAsync() end
        end
        _G.JAF_ChanScore = bestScore
        return _chanTable
    end
    _G.JAF_FindChans = _findChans
    local dcCache = setmetatable({}, {__mode = "k"})
    local function directChannel(cd) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if type(cd) ~= "table" then return cd end
        local hit = dcCache[cd]; if hit then return hit end
        local w = {
            Raw = cd,
            Get = function(_, key) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local ct = rawget(cd, "CacheTable")
                if type(ct) ~= "table" then return nil end
                if key == "AnimalList" or key == "Animals" then return _G.JAF_AnimalsOf(ct) end
                return rawget(ct, key)
            end,
            GetTable = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return rawget(cd, "CacheTable") end,
        }
        dcCache[cd] = w
        return w
    end
    _G.JAF_DirectChannel = directChannel
    if _G.JAF_SnitchPatchOn == true and _G.JAF_NoSnitchPatch ~= true then
        task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            local t
            for _ = 1, 120 do
                t = _findChans()
                if type(t) == "table" and (_G.JAF_ChanScore or 0) >= 10 then break end
                t = nil
                task.wait(0.25)
            end
            if type(t) ~= "table" then _G.JAF_SnitchPatched = 0 return end
            pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            _G.JAF_SyncOrig = {
                GetAllChannels      = Synchronizer.GetAllChannels,
                Get                 = Synchronizer.Get,
                GetTableFromChannel = Synchronizer.GetTableFromChannel,
            }
            local function reg() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return _findChans() or t end
            local patched = 0
            local function put(name, fn) LPH_ATTRIBUTES(ERROR_HANDLING(false))
if pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
Synchronizer[name] = fn end) then patched = patched + 1 end end
            put("GetAllChannels", function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return reg() end)
            put("Get", function(_, key) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local r = reg()
                local direct = rawget(r, key)
                if direct ~= nil then return direct end
                return rawget(r, tostring(key))
            end)
            put("GetTableFromChannel", function(_, key) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local r = reg()
                local ch = rawget(r, key) or rawget(r, tostring(key))
                if type(ch) ~= "table" then return nil end
                return rawget(ch, "CacheTable")
            end)
            _G.JAF_SnitchPatched = patched
            end) end) end
    local _getCache = {}
    _G.JAF_SyncGetCache = _getCache
    local SyncSafe = setmetatable({}, {
        __index = function(_, k) LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if k == "GetAllChannels" then
                return function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                    local t = _findChans(); if not t then return {} end
                    local out = {}
                    for n, cd in next, t do out[n] = directChannel(cd) end
                    return out
                end end
            if k == "Get" and _G.JAF_SyncPlain ~= true then
                return function(_, name) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                    local t = _findChans(); if not t then return nil end
                    return directChannel(rawget(t, tostring(name)))
                end end
            if k == "Get" and _G.JAF_SyncPlain == true then
                return function(_, name) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                    local key = tostring(name)
                    local hit = _getCache[key]
                    if hit ~= nil then return hit end
                    local ok, ch = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return Synchronizer:Get(name) end)
                    if not ok or ch == nil then return nil end
                    local w = directChannel(ch)
                    _getCache[key] = w
                    return w
                end end
            local v = Synchronizer[k]
            if type(v) ~= "function" then return v end
            return function(_, ...) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                if k == "Get" then local ok, r = safeCall(v, _syncMod(), ...) if not ok then return nil end return wrapChannel(r) end
                local a = table.pack(...)
                local ok, r = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return v(_syncMod(), table.unpack(a, 1, a.n)) end)
                if not ok then return nil end
                return r
            end end, })
    _G.JAF_SyncSafe = SyncSafe
    if _G.JAF_SyncStub == true and debug and debug.getupvalues then
        task.spawn(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            local function isGuid(s) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                return type(s) == "string" and #s == 36 and s:upper() == s
                   and s:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
            end
            local patched, BUDGET, seen = 0, 40000, {}
            local function scan(v, depth) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                BUDGET = BUDGET - 1
                if BUDGET <= 0 or depth > 8 then return end
                local tv = type(v)
                if tv == "table" then
                    if seen[v] then return end; seen[v] = true
                    local n = 0
                    for _ in next, v do n = n + 1; if n > 600 then return end end
                    if n <= 12 then
                        local guid, fnKeys = nil, {}
                        for k, val in next, v do
                            if isGuid(val) then guid = val
                            elseif type(val) == "function" then fnKeys[#fnKeys + 1] = k end
                        end
                        if guid and #fnKeys > 0 then
                            for _, fk in ipairs(fnKeys) do
                                local g = guid
                                if pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
v[fk] = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return g end end) then patched = patched + 1 end
                            end end end
                    for _, val in next, v do scan(val, depth + 1) end
                elseif tv == "function" then
                    if seen[v] then return end; seen[v] = true
                    local oku, ups = pcall(debug.getupvalues, v)
                    if oku and type(ups) == "table" then for _, u in next, ups do scan(u, depth + 1) end end
                end end
            for _, fn in next, (_syncMod() or {}) do if type(fn) == "function" then pcall(scan, fn, 0) end end
            _G.JAF_SyncStubbed = patched
        end) end end
_G.JAF_GetSynchronizer = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
if _G.JAF_NoSafeCall == true then return Synchronizer end return _G.JAF_SyncSafe end
do
    local _PS = game:GetService("Players")
    pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.RespawnTime = 0 end)
    pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.CharacterAutoLoads = true end)
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        _PS:GetPropertyChangedSignal("CharacterAutoLoads"):Connect(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if _PS.CharacterAutoLoads ~= true then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.CharacterAutoLoads = true end) end
        end) end)
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        _PS:GetPropertyChangedSignal("RespawnTime"):Connect(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if _PS.RespawnTime ~= 0 then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.RespawnTime = 0 end) end
        end) end)
    local function _hookLP(lp) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if not lp then return end
        lp.CharacterAdded:Connect(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false)) pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.RespawnTime = 0 end) end)
    end
    _hookLP(_PS.LocalPlayer)
    _PS.PlayerAdded:Connect(function(plr) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if plr == _PS.LocalPlayer then _hookLP(plr) end
    end) end
pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
if setfpscap then setfpscap(_G.JAF_FpsCap or 9999) end end)
local SharedState = {
    ConveyorAnimals = {},
    AllAnimalsCache = nil,
    DisableStealSpeed = nil,
    AdminButtonCache = {},
    StealSpeedToggleFunc = nil,
    BalloonedPlayers = {},
}
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    Workspace = game:GetService("Workspace"),
    Lighting = game:GetService("Lighting"),
    VirtualInputManager = (cloneref and cloneref(game:GetService("VirtualInputManager"))) or game:GetService("VirtualInputManager"),
    GuiService = game:GetService("GuiService"),
    TeleportService = game:GetService("TeleportService"),
}
local Players = Services.Players
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local ReplicatedStorage = Services.ReplicatedStorage
local TweenService = Services.TweenService
local HttpService = Services.HttpService
local Workspace = Services.Workspace
local Lighting = Services.Lighting
local VirtualInputManager = Services.VirtualInputManager
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local LocalPlayer = Players.LocalPlayer
if _G.JAF_PingAdapt == nil then _G.JAF_PingAdapt = false end
_G.JAF_Ping = function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if _G.JAF_PingAdapt ~= true then return 0 end
    local p = 0; pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
p = LocalPlayer:GetNetworkPing() or 0 end)
    return p
end
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HubGui = PlayerGui
pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local h = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
    if typeof(h) == "Instance" then HubGui = h end
end)
local hubFind; hubFind = function(name) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if HubGui ~= PlayerGui then local g = HubGui:FindFirstChild(name); if g then return g end end
    return PlayerGui:FindFirstChild(name)
end
local function safeKeyCode(name, fallback) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if type(name) ~= "string" then return fallback end
    local cleaned = name:gsub("^%s+", ""):gsub("%s+$", "")
    if cleaned == "" or cleaned == "--" or cleaned == "NONE" then return nil end
    local ok, kc = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return Enum.KeyCode[cleaned] end)
    if ok and kc then return kc end
    return fallback
end
local FileName = "rosehub.json"
do
    if type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function" then
        if not isfile(FileName) then
            for _, old in ipairs({ "rosehub_v1.json", "JustAFanHub_v1.json" }) do
                if isfile(old) then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
writefile(FileName, readfile(old)) end); break end
            end end end end
local DefaultConfig = {
    Positions = {
        AdminPanel = {X = 0.1859375, Y = 0.5767123526556385},
        WalkingBestBar = {X = 0.5, Y = 0.96},
    },
    TpSettings = {
        Tool           = "Flying Carpet",
        TpKey          = "T",
        CloneKey       = "V",
        CarpetSpeedKey = "Q",
        InfiniteJump   = false,
        CacheWait      = 0.00,
        WaitFullScan   = true,
        TpSpeedF1      = 130,
        TpSpeedF2      = 130,
        TpSpeedF1Front      = 130, TpSpeedF1Side      = 130,
        TpSpeedF2Front      = 130, TpSpeedF2Side      = 130,
        GrappleSpeedF1Front = 400, GrappleSpeedF1Side = 400,
        GrappleSpeedF2Front = 400, GrappleSpeedF2Side = 400,
        F1SpotMode      = "auto",
        F2SpotMode      = "auto",
        F2StealBelow    = true,
        TpMode          = "tween",
        GrappleFireMode = "firesignal",
        GrappleSpeed    = 400,
        BrainrotSpeed   = 175,
        InstaTpBrainrot = true,
        CloneDelay      = 0.15,
        F1FrontCloneDelay = 0.15,
        WaitStableFps   = false,
        FpsStableThresh = 60,
    },
    HitRecovery    = true,
    RetargetOnSelect      = true,
    SkipStolenTarget      = true,
    AutoTPPriority = true,
    StealSpeed   = 20,
    MenuKey      = "LeftControl",
    AntiRagdollV2 = true,
    PlayerESP    = true,
    StealerESP   = false,
    BaseOwnerESP = false,
    FpsOptimizer = true,
    RemoveAnimations = true,
    OptimizeFloorSmooth = true,
    OptimizeStripMeshTextures = true,
    DarkMode     = false,
    DarkBrightness = 0.4,
    BrainrotESP = true,
    LineToBase = false,
    StealNearest = false,
    ConveyorESP = false,
    PriorityList = {},
    MutationPriorityList = {},
    MutationPriorityEnabled = true,
    PrioritySkipPicker   = false,
    PriorityLastTab      = "brainrot",
    UILocked     = false,
    HideAdminPanel = false,
    HideAutoSteal = false,
    HideWalkingBest = false,
    AutoKickOnSteal = false,
    KickToPrivateOnSteal = false,
    PrivateServerCode = "",
    InvisStealAngle = 233,
    SinkSliderValue = 2.5,
    AutoRecoverLagback = true,
    AutoInvisDuringSteal = false,
    InvisDelayEnabled = false,
    InvisDelayMs = 0,
    InvisToggleKey = "I",
    ClickToAP = false,
    ClickToAPKeybind = "L",
    ProximityAP = false,
    ProximityAPKeybind = "P",
    ProximityRange = 15,
    StealSpeedKey = "C",
    ResetKey = "X",
    AntiBeeDisco = false,
    FOV = 70,
    AutoUnlockOnSteal = false,
    UIScale = 1,
    PanelScales = {},
    MobileMode      = "auto",
    HubButtonMode   = "auto",
    MobileHubButton = true,
    MobileSheet     = true,
    MobileBtnPos    = nil,
    KickKey = "",
    CleanErrorGUIs = false,
    ClickToAPSingleCommand = false,
    RagdollSelfKey = "",
    AutoBuyKey = "",
    DropBrainrotKey = "",
    FloatKey   = "" ,
    FloatSpeed = 40,
    AutoBuyEnabled = false,
    AutoBuyMode = "normal",
    AutoBuyFastRate = 12,
    CarpetAutoBuy = false,
    CarpetMinGen = "",
    CarpetBuySpeed = 70,
    AutoGrief = false,
    KickAfterBuy = false,
    KickAfterBuyToPS = false,
    AutoResetOnBalloon = false,
    AutoStealSpeed = false,
    HideAdminCooldowns = false,
    CurrentTheme = "white",
    CustomThemeHex = "FFC800",
    ThemeImageUrl = "",
    ShowMiniActions = true,
    MiniUIPos = {X = 0.01, Y = 0.35},
    Blacklist = {},
    AntiApAtlasUsers = true,
    AntiApKawaifuUsers = true,
    AntiApBraintopiaUsers = true,
    AntiApFmlyUsers = true,
    AntiApSonUsers = true,
    GriefDetectorEnabled = true,
    AdminRandomCmd = false,
    ShowProxCircle = false,
    AdminAllowedCmds = {},
    AdminCmdOrder = {"ragdoll", "balloon", "rocket", "jail", "inverse", "jumpscare", "morph", "nightvision", "tiny"},
    AdminCmdPinned = {},
    KnownSecrets = {},
    KnownSecretRarities = {},
    NewSecretsBatch = {},
}
local function _deepCopy(t) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local o = {}
    for k, v in pairs(t) do o[k] = (type(v) == "table") and _deepCopy(v) or v end
    return o
end
_G.JAF_ConfigDefaults = _deepCopy(DefaultConfig)
local Config = DefaultConfig
if isfile and isfile(FileName) then
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local ok, decoded = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return HttpService:JSONDecode(readfile(FileName)) end)
        if not ok then return end
        for k, v in pairs(DefaultConfig) do if decoded[k] == nil then decoded[k] = v end end
        for _, sub in ipairs({"TpSettings", "Positions"}) do
            if decoded[sub] then for k, v in pairs(DefaultConfig[sub]) do if decoded[sub][k] == nil then decoded[sub][k] = v end end end
        end
        for _, k in ipairs({"Blacklist", "AdminAllowedCmds", "AdminCmdPinned", "KnownSecrets"}) do
            if type(decoded[k]) ~= "table" then decoded[k] = {} end
        end
        if type(decoded.AdminCmdOrder) ~= "table" or #decoded.AdminCmdOrder == 0 then
            local _o = {}
            for _, c in ipairs(DefaultConfig.AdminCmdOrder) do _o[#_o + 1] = c end
            decoded.AdminCmdOrder = _o
        end
        Config = decoded
    end) end
Config.ProximityAP = false
if not Config._CloneDelayMigrated then
    Config._CloneDelayMigrated = true
    if Config.TpSettings and tonumber(Config.TpSettings.CloneHold) then
        Config.TpSettings.CloneDelay = tonumber(Config.TpSettings.CloneHold)
        Config.TpSettings.CloneHold  = nil
    end end
Config.StealRadius = nil
if not Config._F2StealBelowDefaultOn then
    Config._F2StealBelowDefaultOn = true
    if Config.TpSettings then Config.TpSettings.F2StealBelow = true end
end
Config.OptimizeFloorSmooth = true
Config.OptimizeStripMeshTextures = true
if _G.JAF_NoCarpetScan == true then Config.CarpetAutoBuy = false end
if _G.JAF_FastBuyPublic == nil then _G.JAF_FastBuyPublic = true end
_G.JAF_FastBuyAllowed = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return true end
if not (isfile and isfile(FileName)) then
    local vpH = 1080
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local cam = Workspace.CurrentCamera
        local h = cam and cam.ViewportSize and cam.ViewportSize.Y
        if not h or h < 200 then local res = GuiService.GetScreenResolution and GuiService:GetScreenResolution() h = res and res.Y end
        if h and h >= 200 then vpH = h end
    end)
    local autoScale = 0.9 * (vpH / 1080)
    Config.UIScale = math.floor(math.clamp(autoScale, 0.9, 1.5) * 20 + 0.5) / 20
end
_G.JAF_FFlagList = {
    {"DFFlagBrowserTrackerIdTelemetryEnabled","False"},{"DFFlagPreloadAsyncSupportTexturePack","True"},{"DFFlagTextureQualityOverrideEnabled","True"},
    {"DFFlagVideoCaptureServiceEnabled","False"},{"DFFlagSampleAndRefreshRakPing","True"},{"DFFlagRakNetUseSlidingWindow4","True"},
    {"DFFlagCoreScriptTelemetry2","False"},{"DFFlagEnableSoundPreloading","True"},{"DFFlagOptimizePartsInPart","True"},
    {"DFFlagDisableDPIScale","True"},{"DFFlagDebugPerfMode","True"},{"DFIntRaknetBandwidthInfluxHundredthsPercentageV2","10000"},
    {"DFIntRakNetClockDriftAdjustmentPerPingMillisecond","100"},{"DFIntPerformanceControlTextureQualityBestUtility","-1"},{"DFIntSignalRHubConnectionHeartbeatTimerRateMs","1000"},
    {"DFIntMaxReceiveToDeserializeLatencyMilliseconds","15"},{"DFIntMegaReplicatorNetworkQualityProcessorUnit","10"},{"DFIntNetworkInDeserializeLimitGameplayMsClient","6"},
    {"DFIntSignalRHubConnectionBaseRetryTimeMs","100"},{"DFIntClientPacketHealthyAllocationPercent","20"},{"DFIntTelemetryProfilerHundredthsPercentage","0"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS","1"},{"DFIntNetworkInProcessLimitGameplayMsClient","6"},{"DFIntAnimationLodFacsVisibilityDenominator","0"},
    {"DFIntRaknetBandwidthPingSendEveryXSeconds","1"},{"DFIntSignalRCoreKeepAlivePingPeriodMs","250"},{"DFIntClientPacketMaxFrameMicroseconds","200"},
    {"DFIntSoundServiceCacheCleanupMaxAgeDays","2"},{"DFIntMaxProcessPacketsStepsPerCyclic","5000"},{"DFIntClientPacketExcessMicroseconds","1000"},
    {"DFIntMaxProcessPacketsStepsAccumulated","0"},{"DFIntWaitOnUpdateNetworkLoopEndedMS","100"},{"DFIntLargePacketQueueSizeCutoffMB","1000"},
    {"DFIntMaxProcessPacketsJobScaling","10000"},{"DFIntRakNetNakResendDelayRttPercent","50"},{"DFIntSignalRCoreServerTimeoutMs","11100"},
    {"DFIntDebugFRMQualityLevelOverride","1"},{"DFIntClientPacketMinMicroseconds","1"},{"DFIntAnimationLodFacsDistanceMin","0"},
    {"DFIntAnimationLodFacsDistanceMax","0"},{"DFIntWaitOnRecvFromLoopEndedMS","100"},{"DFIntRakNetNakResendDelayMsMax","100"},
    {"DFIntCodecMaxOutgoingFrames","10000"},{"DFIntSignalRCoreRpcQueueSize","256"},{"DFIntRakNetMinAckGrowthPercent","0"},
    {"DFIntTaskSchedulerTargetFps","9999"},{"DFIntCodecMaxIncomingPackets","100"},{"DFIntRakNetMtuValue3InBytes","1200"},
    {"DFIntRakNetMtuValue1InBytes","1280"},{"DFIntRakNetMtuValue2InBytes","1240"},{"DFIntRakNetNakResendDelayMs","10"},
    {"DFIntRakNetResendRttMultiple","1"},{"DFIntMemCacheMaxCapacityMB","48"},{"DFIntClientPacketMaxDelayMs","11"},
    {"DFIntTextureQualityOverride","0"},{"DFIntRakNetSelectTimeoutMs","1"},{"DFIntSignalRCoreTimerMs","750"},
    {"DFIntConnectionMTUSize","1260"},{"DFIntMaxFrameBufferSize","4"},{"DFIntRakNetLoopMs","1"},
    {"DFIntDebugRestrictGCDistance","1"},{"FIntTaskSchedulerAsyncTasksMinimumThreadCount","2"},{"FIntRenderMaxShadowAtlasUsageBeforeDownscale","80"},
    {"FIntPerformanceTelemetryQueueProcessLimit","0"},{"FIntRenderShadowMapDepthCacheMemLimit","192"},{"FIntUITextureMaxRenderTextureSize","1024"},
    {"FIntRakNetResendBufferArrayLength","128"},{"FIntTaskSchedulerAutoThreadLimit","6"},{"FIntTerrainOTAMaxTextureSize","1024"},
    {"FIntOcclusionWorkerThreadCount","5"},{"FIntTaskSchedulerMaxNumOfJobs","86"},{"FIntTelemetryProfilerFrequency","0"},
    {"FIntRenderLocalLightFadeInMs","0"},{"FIntDefaultMeshCacheSizeMB","256"},{"FIntReportDeviceInfoRollout","0"},
    {"FIntTaskSchedulerThreadMin","1"},{"FIntRobloxGuiBlurIntensity","0"},{"FIntTerrainArraySliceSize","0"},
    {"FIntDebugForceMSAASamples","1"},{"FIntRenderShadowmapBias","0"},{"FIntFRMMaxGrassDistance","0"},
    {"FIntFRMMinGrassDistance","0"},{"FIntGrassMovementReducedMotionFactor","0"},{"FIntDebugTextureManagerSkipMips","7"},
    {"RenderUseTextureManager224","False"},{"TextureQualityOverride","1"},{"TextureQualityOverrideEnabled","True"},
    {"PerformanceControlTextureQualityBestUtility","1"},{"FFlagRenderAllocateShadowMapResourcesOnDemand","True"},{"FFlagSpecifyNetworkReplicatorScopeForItems","True"},
    {"FFlagTaskSchedulerLimitTargetFpsTo2402","False"},{"FFlagHandleAltEnterFullscreenManually","False"},{"FFlagGameBasicSettingsFramerateCap5","False"},
    {"FFlagSpecifyNetworkReplicatorScope","True"},{"FFlagSendRenderFidelityTelemetry2","False"},{"FFlagRenderGpuTextureCompressor","True"},
    {"FFlagBaseThreadPoolUseRuntime2","True"},{"FFlagCacheTextBoundsInGuiText","True"},{"FFlagEnableTelemetryService1","False"},
    {"FFlagDebugGraphicsPreferD3D11","True"},{"FFlagPerfDataOnTelemetryV2","False"},{"FFlagOpenTelemetryEnabled2","False"},
    {"FFlagRbxStorageUseMemCache","True"},{"FFlagDebugForceGenerateHSR","True"},{"FFlagRenderInitShadowmaps","True"},
    {"FFlagFastGPULightCulling3","True"},{"FFlagDebugSkyGray","True"},{"FFlagDebugRenderingSetDeterministic","True"},
    {"FLogNetwork","7"},
}
_G.JAF_ApplyFFlags = function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local fn = rawget(getfenv and getfenv(0) or _G, "setfflag") or rawget(_G, "setfflag") or setfflag
    if type(fn) ~= "function" then return false end
    local n = 0
    for _, f in ipairs(_G.JAF_FFlagList) do if pcall(fn, f[1], f[2]) then n = n + 1 end end
    return n > 0
end
if Config.FFlagsEnabled then pcall(_G.JAF_ApplyFFlags) end
Config.AutoTPPriority = true
Config.UsePriority = Config.StealNearest ~= true
if type(Config.MutationPriorityList) ~= "table" then Config.MutationPriorityList = {} end
if Config.PriorityLastTab    ~= "mutation" then Config.PriorityLastTab    = "brainrot" end
if Config.PrioritySkipPicker ~= true       then Config.PrioritySkipPicker = false end
if Config.MutationPriorityEnabled ~= false then Config.MutationPriorityEnabled = true end
Config.PriorityMode, Config.MutationFilterStrict = nil, nil
BlacklistedPlayers    = BlacklistedPlayers    or Config.Blacklist or {}
addToBlacklist        = addToBlacklist        or function() end
removeFromBlacklist   = removeFromBlacklist   or function() end
isBlacklisted         = isBlacklisted         or function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return false end
canUseAdminAction     = canUseAdminAction     or function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return true end
refreshBlacklistUI    = refreshBlacklistUI    or function() end
isAtlasUser           = isAtlasUser           or function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return false end
local function SaveConfig() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if writefile then
        pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            local toSave = {}
            for k, v in pairs(Config) do toSave[k] = v end
            toSave.ProximityAP = false
            writefile(FileName, HttpService:JSONEncode(toSave))
        end) end end
_G.JAF_SaveConfig = SaveConfig
do
    local savePending = false
    function _G.JAF_SaveConfigSoon() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if savePending then return end
        savePending = true
        task.defer(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
savePending = false; SaveConfig() end)
    end end
_G.JAF_PositionDefaults = {
    AdminPanel     = {X = 0.1859375, Y = 0.5767123526556385},
    WalkingBestBar = {X = 0.5,  Y = 0.96},
}
function _G.JAF_ResetGuiPositions() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local moved = 0
    local targets = _G.JAF_DragTargets or {}
    Config.Positions = Config.Positions or {}
    for key, def in pairs(_G.JAF_PositionDefaults) do
        Config.Positions[key] = {X = def.X, Y = def.Y}
        local f = targets[key]
        if f and f.Parent then f.Position = UDim2.new(def.X, 0, def.Y, 0) moved = moved + 1 end
    end
    Config.JustAFanSettingsPos = nil
    local sg = hubFind("JustAFanSettings")
    local mp = sg and sg:FindFirstChild("MainPanel")
    if mp then mp.Position = UDim2.new(0, 60, 0.5, -280); moved = moved + 1 end
    Config.MiniUIPos = {X = 0.01, Y = 0.35}
    local mg = hubFind("JustAFanMiniActions")
    local mn = mg and mg:FindFirstChild("MiniPanel")
    if mn then mn.Position = UDim2.new(0.01, 0, 0.35, 0); moved = moved + 1 end
    Config.MobileBtnPos = nil
    local bg = hubFind("JustAFanMobileBar")
    local lb = bg and bg:FindFirstChild("Launcher")
    if lb then
        local inset = 10
        if type(_G.JAF_TopInset) == "function" then
            local ok, v = pcall(_G.JAF_TopInset); if ok and tonumber(v) then inset = tonumber(v) + 10 end
        end
        lb.Position = UDim2.new(0, 14, 0, inset); moved = moved + 1
    end
    SaveConfig()
    return moved
end
function _G.JAF_ResetSettingsToDefault() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local defs = _G.JAF_ConfigDefaults
    if type(defs) ~= "table" then return false end
    for k in pairs(Config) do Config[k] = nil end
    for k, v in pairs(defs) do Config[k] = (type(v) == "table") and _deepCopy(v) or v end
    _P(Config, "ProximityAP", false, "StealRadius", nil, "AutoTPPriority", true, "UsePriority", true, "OptimizeFloorSmooth", true, "OptimizeStripMeshTextures", true)
    Config._CloneDelayMigrated = true
    Config._F2StealBelowDefaultOn = true
    SaveConfig()
    pcall(_G.JAF_ResetGuiPositions)
    return true
end
_G.InvisStealAngle = Config.InvisStealAngle
_G.SinkSliderValue = Config.SinkSliderValue
_G.AutoRecoverLagback = Config.AutoRecoverLagback
_G.AutoInvisDuringSteal = Config.AutoInvisDuringSteal
_G.JAF_FpsOptimizer = Config.FpsOptimizer ~= false
_G.JAF_RemoveAnims = Config.RemoveAnimations ~= false
_G.JAF_OptimizeFloorSmooth       = _G.JAF_FpsOptimizer and Config.OptimizeFloorSmooth ~= false
_G.JAF_OptimizeStripMeshTextures = _G.JAF_FpsOptimizer and Config.OptimizeStripMeshTextures == true
_G.JAF_InvisDelayEnabled = Config.InvisDelayEnabled == true
_G.JAF_InvisDelayMs = tonumber(Config.InvisDelayMs) or 0
_G.JAF_F1Mode = (Config.TpSettings and Config.TpSettings.F1SpotMode) or "auto"
_G.JAF_F2Mode = (Config.TpSettings and Config.TpSettings.F2SpotMode) or "auto"
if Config.TpSettings and Config.TpSettings._WaitStableFpsDefaultOn == nil then
    Config.TpSettings.WaitStableFps = true
    Config.TpSettings._WaitStableFpsDefaultOn = true
end
_G.JAF_WaitStableFps   = (Config.TpSettings and Config.TpSettings.WaitStableFps) == true
_G.JAF_FpsStableThresh = (Config.TpSettings and Config.TpSettings.FpsStableThresh) or 60
if _G.JAF_LoadTpFpsWait == nil then _G.JAF_LoadTpFpsWait = 1.5 end
do
    local invisKey = nil
    if type(Config.InvisToggleKey) == "string" and Config.InvisToggleKey ~= "" then
        local ok, kc = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return Enum.KeyCode[Config.InvisToggleKey] end)
        if ok and kc then invisKey = kc end
    end
    _G.INVISIBLE_STEAL_KEY = invisKey
end
_G.invisibleStealEnabled = false
_G.RecoveryInProgress = false
local function kickPlayer() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local ok = pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if game.Shutdown then game:Shutdown() else LocalPlayer:Kick("\nJUSTAFAN HUB") end
    end)
    if not ok then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
LocalPlayer:Kick("\nJUSTAFAN HUB") end) end
end
_G.JAF_KickPlayer = kickPlayer
local function _jafParsePSInput(input) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if type(input) ~= "string" then return nil end
    input = input:gsub("%s+", "")
    if input == "" then return nil end
    local placeId = tonumber(input:match("/games/(%d+)"))
    local direct = input:match("[?&]privateServerLinkCode=([%w%-_]+)") or input:match("[?&]linkCode=([%w%-_]+)")
    if direct then return direct, placeId, false end
    if input:match("[?&]code=([%w%-_]+)") then return nil, placeId, true end
    if input:match("^[%w%-_]+$") then
        local looksShare = (#input == 32) and (input:match("^[0-9a-f]+$") ~= nil)
        if looksShare then return nil, placeId, true end
        return input, placeId, false
    end
    return nil
end
_G.JAF_ParsePSInput = _jafParsePSInput
_G.JAF_TeleportToPrivateServer = function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local linkCode, placeId, shareWarn = _jafParsePSInput(Config.PrivateServerCode)
    if shareWarn then return false, "that's a SHARE code, not a linkCode" end
    if not linkCode then return false, "no valid private-server link code saved" end
    placeId = placeId or game.PlaceId
    local ok = pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        game:GetService("ExperienceService"):LaunchExperience({ placeId = placeId, linkCode = linkCode })
    end)
    if ok then return true end
    local ok2, err = pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        TeleportService:TeleportToPrivateServer(placeId, linkCode, { LocalPlayer })
    end)
    if ok2 then return true end
    return false, tostring(err)
end
_G.JAF_KickToPrivateServer = function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false)) return _G.JAF_TeleportToPrivateServer() end
local function triggerClosestUnlock(yLevel, maxY) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if not SAB_LIVE() then return end
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local playerY = yLevel or hrp.Position.Y
    local Y_THRESHOLD = 5
    local bestPromptSameLevel = nil
    local shortestDistSameLevel = math.huge
    local bestPromptFallback = nil
    local shortestDistFallback = math.huge
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    local hrpPos = hrp.Position
    for _, obj in ipairs(plots:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local part = obj.Parent
            if part and part:IsA("BasePart") then
                local partPos = part.Position
                if maxY and partPos.Y > maxY then
                else
                    local distance = (hrpPos - partPos).Magnitude
                    local yDifference = math.abs(playerY - partPos.Y)
                    if distance < shortestDistFallback then shortestDistFallback = distance bestPromptFallback = obj end
                    if yDifference <= Y_THRESHOLD then
                        if distance < shortestDistSameLevel then shortestDistSameLevel = distance bestPromptSameLevel = obj end
                    end end end end end
    local targetPrompt = bestPromptSameLevel or bestPromptFallback
    if targetPrompt then
        if fireproximityprompt then
            fireproximityprompt(targetPrompt)
        else
            targetPrompt:InputBegan(Enum.UserInputType.MouseButton1)
            task.wait(0.05)
            targetPrompt:InputEnded(Enum.UserInputType.MouseButton1)
        end end end
_G.JAF_Config     = Config      -- exposed so the Modern GUI (appended at EOF) can read/write settings
_G.JAF_SaveConfig = SaveConfig
local Theme = {
    -- Monochrome look matching the Modern GUI (neutral grayscale, white accents).
    Background      = Color3.fromRGB(20, 20, 20),
    Surface         = Color3.fromRGB(34, 34, 34),
    SurfaceHighlight= Color3.fromRGB(46, 46, 46),
    Accent1         = Color3.fromRGB(235, 235, 235),
    Accent2         = Color3.fromRGB(130, 130, 130),
    TextPrimary     = Color3.fromRGB(238, 238, 238),
    TextSecondary   = Color3.fromRGB(130, 130, 130),
    Success         = Color3.fromRGB(235, 235, 235),
    Error           = Color3.fromRGB(205, 120, 120),
    Stroke          = Color3.fromRGB(50, 50, 50),
}
function _G.JAF_OnAccent(c) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    c = c or Theme.Accent1
    local lum = c.R * 0.299 + c.G * 0.587 + c.B * 0.114
    return lum > 0.55 and Color3.fromRGB(15, 15, 18) or Color3.fromRGB(245, 245, 250)
end
function _G.JAF_Rgb(c) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    c = c or Theme.TextPrimary
    return ("rgb(%d,%d,%d)"):format( math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end
local _THEME_FIELDS = {"Background","Surface","SurfaceHighlight","Accent1","Accent2","TextPrimary","TextSecondary","Success","Error"}
THEMES = {}
do
    local _PAL = {
        cyan     = {8,18,28, 10,25,40, 15,45,65, 50,200,255, 0,150,210, 240,240,240, 170,210,230, 50,200,255, 210,90,90},
        midnight = {10,12,24, 15,18,36, 26,30,60, 125,135,255, 85,95,220, 238,240,250, 180,188,225, 125,135,255, 210,90,90},
        ice      = {10,18,26, 14,26,38, 22,44,62, 150,220,255, 95,180,225, 240,248,252, 180,210,228, 150,220,255, 210,90,90},
        rose     = {26,10,16, 38,14,24, 64,22,40, 255,120,160, 215,75,120, 250,240,244, 230,180,200, 255,120,160, 255,95,95},
        ocean    = {6,14,26, 8,22,42, 14,40,72, 60,130,255, 30,90,210, 238,242,250, 175,195,230, 60,130,255, 210,90,90},
        white    = {18,18,22, 28,28,34, 48,48,56, 235,235,245, 170,170,185, 245,245,248, 185,185,195, 235,235,245, 210,90,90},
        dawg     = {20,13,11, 34,19,17, 60,26,24, 196,42,38, 142,24,22, 246,236,232, 226,184,174, 196,42,38, 255,95,95},
        custom   = {18,8,38, 25,10,55, 45,15,85, 180,50,255, 130,0,220, 240,240,240, 200,170,230, 180,50,255, 210,90,90},
    }
    for name, rgb in pairs(_PAL) do
        local t = {}
        for i = 1, #_THEME_FIELDS do local b = (i - 1) * 3 t[_THEME_FIELDS[i]] = Color3.fromRGB(rgb[b + 1], rgb[b + 2], rgb[b + 3]) end
        THEMES[name] = t
    end end
DAWG_IMAGE_URL   = "https://images.pexels.com/photos/18682530/pexels-photo-18682530.png"
DAWG_IMAGE_ASSET = "rbxassetid://85709371910705"
_G.JAF_DawgResolved = _G.JAF_DawgResolved or nil
_G.JAF_DawgActive   = _G.JAF_DawgActive or false
function resolveDawgImage() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if _G.JAF_DawgResolved then return _G.JAF_DawgResolved end
    if type(DAWG_IMAGE_URL) == "string" and DAWG_IMAGE_URL ~= "" and jafDownloadWebImage then
        local asset = jafDownloadWebImage(DAWG_IMAGE_URL)
        if asset then _G.JAF_DawgResolved = asset; return asset end
    end
    if type(DAWG_IMAGE_ASSET) == "string" and DAWG_IMAGE_ASSET ~= "" then _G.JAF_DawgResolved = DAWG_IMAGE_ASSET return DAWG_IMAGE_ASSET end
    return nil
end
function buildCustomThemeFromColor(accent) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if typeof(accent) ~= "Color3" then return false end
    local r, g, b = accent.R * 255, accent.G * 255, accent.B * 255
    local function toward(c, t, amt) LPH_ATTRIBUTES(ERROR_HANDLING(false))
return c + (t - c) * amt end
    local hex = tostring(Config.CustomThemeHex or "FFC800"):gsub("#", ""):gsub("%s", "")
    local cr = tonumber(hex:sub(1, 2), 16) or 255
    local cg = tonumber(hex:sub(3, 4), 16) or 200
    local cb = tonumber(hex:sub(5, 6), 16) or 0
    local clum = 0.299 * cr + 0.587 * cg + 0.114 * cb
    if clum < 120 then
        local lift = (120 - clum) / 120 * 0.7
        cr, cg, cb = toward(cr, 150, lift), toward(cg, 150, lift), toward(cb, 160, lift)
    end
    cr, cg, cb = math.clamp(cr, 0, 255), math.clamp(cg, 0, 255), math.clamp(cb, 0, 255)
    local accentBright = Color3.fromRGB(cr, cg, cb)
    local accent2 = Color3.fromRGB(math.floor(cr * 0.72), math.floor(cg * 0.72), math.floor(cb * 0.72))
    local function tint(f) LPH_ATTRIBUTES(ERROR_HANDLING(false))
return Color3.fromRGB(
        math.clamp(math.floor(r * f) + 6, 0, 255),
        math.clamp(math.floor(g * f) + 4, 0, 255),
        math.clamp(math.floor(b * f) + 10, 0, 255)) end
    THEMES.custom = {
        Background       = tint(0.06),
        Surface          = tint(0.10),
        SurfaceHighlight = tint(0.20),
        Accent1          = accentBright,
        Accent2          = accent2,
        TextPrimary      = Color3.fromRGB(240, 240, 240),
        TextSecondary    = Color3.fromRGB(
            math.clamp(math.floor(170 + r * 0.28), 0, 255),
            math.clamp(math.floor(170 + g * 0.28), 0, 255),
            math.clamp(math.floor(180 + b * 0.24), 0, 255)),
        Success          = accentBright,
        Error            = Color3.fromRGB(210, 90, 90),
    }
    return true
end
function buildCustomThemeFromHex(hex) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if type(hex) ~= "string" then return false end
    hex = hex:gsub("#", ""):gsub("%s", "")
    if #hex ~= 6 then return false end
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    if not (r and g and b) then return false end
    return buildCustomThemeFromColor(Color3.fromRGB(r, g, b))
end
pcall(buildCustomThemeFromHex, Config.CustomThemeHex)
local AssetService = game:GetService("AssetService")
_G.JAF_ThemeImageAsset = _G.JAF_ThemeImageAsset or nil
local function jafHttpRequest(url) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local req = (syn and syn.request) or (http and http.request) or http_request or request or fluxus and fluxus.request
    if not req then return nil end
    local ok, res = pcall(req, { Url = url, Method = "GET" })
    if ok and res and (res.Body or res.body) then return res.Body or res.body end
    return nil
end
local function jafGetCustomAsset(fileName) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local getter = getcustomasset or getsynasset or (syn and syn.getcustomasset)
    if not getter then return nil end
    local ok, asset = pcall(getter, fileName)
    if ok and asset then return asset end
    return nil
end
local JAF_MEDIA_DIR = "rosehub_theme"
local function jafEnsureMediaDir() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if makefolder and (not isfolder or not isfolder(JAF_MEDIA_DIR)) then makefolder(JAF_MEDIA_DIR) end
    end)
    return JAF_MEDIA_DIR
end
jafJpegAverageColor = function(data) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if type(data) ~= "string" or #data < 4 then return nil, "not image data" end
    local byte = string.byte
    if byte(data, 1) ~= 0xFF or byte(data, 2) ~= 0xD8 then return nil, "not a JPEG" end
    local _dlen = #data
    local function u16(p) LPH_ATTRIBUTES(ERROR_HANDLING(false))
return byte(data, p) * 256 + byte(data, p + 1) end
    local _jrsh, _jband = bit32.rshift, bit32.band
    local quant = {}
    local huffDC, huffAC = {}, {}
    local comps = {}
    local restartInterval = 0
    local W, H = 0, 0
    local pos = 3
    local progressive = false
    local function buildHuff(counts, vals) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local t, code, k = {}, 0, 1
        for L = 1, 16 do t[L] = {} for _ = 1, counts[L] do t[L][code] = vals[k]; k = k + 1; code = code + 1 end code = code * 2 end
        return t
    end
    while pos < _dlen do
        if byte(data, pos) ~= 0xFF then pos = pos + 1
        else
            while byte(data, pos) == 0xFF do pos = pos + 1 end
            local marker = byte(data, pos); pos = pos + 1
            if marker == 0xD9 then break
            elseif marker == 0xC0 or marker == 0xC1 or marker == 0xC2 then
                progressive = (marker == 0xC2)
                local len = u16(pos)
                H = u16(pos + 3); W = u16(pos + 5)
                local nf = byte(data, pos + 7)
                local p = pos + 8
                for i = 1, nf do
                    local samp = byte(data, p + 1)
                    comps[i] = { id = byte(data, p), h = _jrsh(samp, 4), v = _jband(samp, 15), tq = byte(data, p + 2) }
                    p = p + 3
                end
                pos = pos + len
            elseif marker == 0xC3 or (marker >= 0xC5 and marker <= 0xCF and marker ~= 0xC8) then
                return nil, "unsupported JPEG (marker " .. string.format("%02X", marker) .. ")"
            elseif marker == 0xC4 then
                local endp = pos + u16(pos); local p = pos + 2
                while p < endp do
                    local tcth = byte(data, p); p = p + 1
                    local counts, total = {}, 0
                    for i = 1, 16 do counts[i] = byte(data, p); total = total + counts[i]; p = p + 1 end
                    local vals = {}
                    for i = 1, total do vals[i] = byte(data, p); p = p + 1 end
                    local built = buildHuff(counts, vals)
                    if _jrsh(tcth, 4) == 0 then huffDC[_jband(tcth, 15)] = built else huffAC[_jband(tcth, 15)] = built end
                end
                pos = endp
            elseif marker == 0xDB then
                local endp = pos + u16(pos); local p = pos + 2
                while p < endp do
                    local pqtq = byte(data, p); p = p + 1
                    local pq, tbl = _jrsh(pqtq, 4), {}
                    for i = 1, 64 do if pq == 0 then tbl[i] = byte(data, p); p = p + 1 else tbl[i] = u16(p); p = p + 2 end end
                    quant[_jband(pqtq, 15)] = tbl
                end
                pos = endp
            elseif marker == 0xDD then
                local len = u16(pos); restartInterval = u16(pos + 2); pos = pos + len
            elseif marker == 0xDA then
                local ns = byte(data, pos + 2)
                local p = pos + 3
                local scan = {}
                for i = 1, ns do
                    local cs = byte(data, p); local tdta = byte(data, p + 1); p = p + 2
                    local td, ta = _jrsh(tdta, 4), _jband(tdta, 15)
                    for _, c in ipairs(comps) do
                        if c.id == cs then
                            c.dc = huffDC[td]; c.ac = huffAC[ta]
                            c.pred, c.sum, c.cnt = 0, 0, 0
                            scan[i] = c
                        end end end
                local Ss = byte(data, p); local Ah_Al = byte(data, p + 2)
                local Ah, Al = _jrsh(Ah_Al, 4), _jband(Ah_Al, 15)
                pos = p + 3
                if progressive and not (Ss == 0 and Ah == 0) then return nil, "progressive JPEG (DC scan not first)" end
                local alScale = 2 ^ Al
                local bitBuf, bitCnt = 0, 0
                local function nextBit() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                    if bitCnt == 0 then
                        if pos > _dlen then return 0 end
                        local b = byte(data, pos); pos = pos + 1
                        if b == 0xFF then local nb = byte(data, pos) if nb == 0x00 then pos = pos + 1 else pos = pos - 1; return 0 end end
                        bitBuf = b; bitCnt = 8
                    end
                    bitCnt = bitCnt - 1
                    return _jband(_jrsh(bitBuf, bitCnt), 1)
                end
                local function receive(s) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                    local v = 0
                    for _ = 1, s do v = v * 2 + nextBit() end
                    return v
                end
                local function extend(v, s) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                    if s == 0 then return 0 end
                    if v < 2 ^ (s - 1) then return v - 2 ^ s + 1 end
                    return v
                end
                local function huffDecode(tbl) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                    local code = 0
                    for L = 1, 16 do
                        code = code * 2 + nextBit()
                        local row = tbl[L]
                        if row then local val = row[code]; if val ~= nil then return val end end
                    end
                    return nil
                end
                local function decodeBlock(c) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                    local t = huffDecode(c.dc); if t == nil then return false end
                    c.pred = c.pred + extend(receive(t), t)
                    c.sum = c.sum + c.pred * alScale; c.cnt = c.cnt + 1
                    if progressive then return true end
                    local k = 1
                    while k < 64 do
                        local rs = huffDecode(c.ac); if rs == nil then break end
                        local r, s = _jrsh(rs, 4), _jband(rs, 15)
                        if s == 0 then
                            if r == 15 then k = k + 16 else break end
                        else
                            k = k + r; if k > 63 then break end
                            receive(s); k = k + 1
                        end end
                    return true
                end
                local hmax, vmax = 1, 1
                for _, c in ipairs(comps) do hmax = math.max(hmax, c.h); vmax = math.max(vmax, c.v) end
                local total = math.ceil(W / (8 * hmax)) * math.ceil(H / (8 * vmax))
                local since = 0
                for m = 1, total do
                    for _, c in ipairs(scan) do for _ = 1, c.v do for _ = 1, c.h do decodeBlock(c) end end end
                    since = since + 1
                    if restartInterval > 0 and since == restartInterval and m < total then
                        since = 0; bitCnt = 0
                        while pos <= _dlen and byte(data, pos) ~= 0xFF do pos = pos + 1 end
                        while pos <= _dlen and byte(data, pos) == 0xFF do pos = pos + 1 end
                        pos = pos + 1
                        for _, c in ipairs(scan) do c.pred = 0 end
                    end end
                break
            else
                local len = u16(pos); pos = pos + len
            end end end
    local function avgVal(c) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if not c or c.cnt == 0 then return 128 end
        local qdc = (quant[c.tq] and quant[c.tq][1]) or 1
        return (c.sum / c.cnt) * qdc / 8 + 128
    end
    local function clamp(x) LPH_ATTRIBUTES(ERROR_HANDLING(false))
return math.max(0, math.min(255, math.floor(x + 0.5))) end
    if #comps == 0 then return nil, "no frame" end
    local Y = avgVal(comps[1])
    if #comps == 1 then local gg = clamp(Y); return gg, gg, gg end
    local Cb, Cr = avgVal(comps[2]), avgVal(comps[3])
    return clamp(Y + 1.402 * (Cr - 128)), clamp(Y - 0.344136 * (Cb - 128) - 0.714136 * (Cr - 128)), clamp(Y + 1.772 * (Cb - 128))
end
jafDownloadWebImage = function(url) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if type(url) ~= "string" then return nil, "no image input" end
    _G.JAF_LastImageBytes = nil
    _G.JAF_GifUrl = nil
    local idNum = url:match("^%s*(%d+)%s*$") or url:match("rbxassetid://(%d+)") or url:match("rbxasset://(%d+)")
    if idNum then return "rbxassetid://" .. idNum end
    if isfile and isfile(url) then
        local asset = jafGetCustomAsset(url)
        if asset then if readfile then local okR, b = pcall(readfile, url); if okR then _G.JAF_LastImageBytes = b end end return asset end
        return nil, "found the file but executor has no getcustomasset"
    end
    if not writefile then return nil, "executor has no writefile" end
    local b64 = url:match("^data:image/[%w%+%.%-]*;base64,(.+)$")
    if b64 then
        b64 = b64:gsub("%s", "")
        local dec = (crypt and crypt.base64decode)
                 or (crypt and crypt.base64 and crypt.base64.decode)
                 or (syn and syn.crypt and syn.crypt.base64decode)
        if not dec then return nil, "executor has no base64 decoder" end
        local okD, bin = pcall(dec, b64)
        if not okD or type(bin) ~= "string" or #bin < 64 then return nil, "base64 decode failed/empty" end
        _G.JAF_LastImageBytes = bin
        local ext = (url:match("^data:image/([%w]+)") or "png"):lower()
        if ext == "jpeg" then ext = "jpg" end
        if ext ~= "png" and ext ~= "jpg" and ext ~= "tga" and ext ~= "bmp" then ext = "png" end
        local fname = jafEnsureMediaDir() .. "/JustAFanThemeBG." .. ext
        if not pcall(writefile, fname, bin) then return nil, "writefile failed" end
        local asset = jafGetCustomAsset(fname)
        if asset then return asset end
        return nil, "executor has no getcustomasset"
    end
    if not url:match("^https?://") then return nil, "paste a direct http(s) image link, a data:image base64 string, or an asset id" end
    local mediaUrl = url
    local host = url:match("^https?://([^/]+)") or ""
    if host:find("tenor%.com") then
        local page = jafHttpRequest(url)
        if page then
            local og = page:match('property="og:image"[^>]-content="([^"]+)"') or page:match('content="([^"]+)"[^>]-property="og:image"')
            if og then mediaUrl = (og:gsub("\\u002[fF]", "/")) end
        end end
    local hostPath = mediaUrl:gsub("^https?://", "")
    if mediaUrl:lower():find("%.gif") then _G.JAF_GifUrl = mediaUrl end
    local function urlEnc(s) LPH_ATTRIBUTES(ERROR_HANDLING(false))
return (s:gsub("[^%w%-%._~/]", function(ch) LPH_ATTRIBUTES(ERROR_HANDLING(false))
return string.format("%%%02X", string.byte(ch)) end)) end
    local function imgExt(b) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if type(b) ~= "string" or #b < 64 then return nil end
        local a, c = b:byte(1), b:byte(2)
        if a == 0x89 and c == 0x50 then return "png" end
        if a == 0xFF and c == 0xD8 then return "jpg" end
        return nil
    end
    local candidates = {
        "https://images.weserv.nl/?url=" .. urlEnc(hostPath) .. "&w=512&output=png",
        "https://i0.wp.com/" .. hostPath .. "?w=512",
        mediaUrl,
    }
    local lastReason = "couldn't fetch/convert that image link"
    for _, u in ipairs(candidates) do
        local body = jafHttpRequest(u)
        local ext = imgExt(body)
        if ext then
            _G.JAF_LastImageBytes = body
            local fname = jafEnsureMediaDir() .. "/JustAFanThemeBG." .. ext
            if not pcall(writefile, fname, body) then return nil, "writefile failed" end
            local asset = jafGetCustomAsset(fname)
            if asset then return asset end
            return nil, "executor has no getcustomasset"
        elseif body and #body > 0 then
            lastReason = "image host/proxy didn't return a usable image (it may be blocked)"
        end end
    return nil, lastReason
end
jafImageAverageColor = function(assetUri) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local ok, col = pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local img
        local okA = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
img = AssetService:CreateEditableImageAsync(Content.fromUri(assetUri)) end)
        if not okA or not img then img = AssetService:CreateEditableImageAsync(assetUri) end
        if not img then return nil end
        local size = img.Size
        local getPix
        local pixels = 0
        local okBuf, buf = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return img:ReadPixelsBuffer(Vector2.new(0, 0), size) end)
        if okBuf and buf and buffer and buffer.len and buffer.len(buf) >= 4 then
            pixels = math.floor(buffer.len(buf) / 4)
            getPix = function(idx0) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                local o = idx0 * 4
                return buffer.readu8(buf, o) / 255, buffer.readu8(buf, o + 1) / 255,
                       buffer.readu8(buf, o + 2) / 255, buffer.readu8(buf, o + 3) / 255
            end
        else
            local okPx, px = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return img:ReadPixels(Vector2.new(0, 0), size) end)
            if not okPx or type(px) ~= "table" or #px < 4 then return nil end
            pixels = math.floor(#px / 4)
            getPix = function(idx0) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                local i = idx0 * 4 + 1
                return px[i], px[i + 1], px[i + 2], px[i + 3]
            end end
        if pixels <= 0 then return nil end
        local stride = math.max(1, math.floor(pixels / 1500))
        local r, g, b, n = 0, 0, 0, 0
        local rf, gf, bf, nf = 0, 0, 0, 0
        for p = 0, pixels - 1, stride do
            local pr, pg, pb, pa = getPix(p)
            pr = pr or 0; pg = pg or 0; pb = pb or 0
            rf = rf + pr; gf = gf + pg; bf = bf + pb; nf = nf + 1
            local sum = pr + pg + pb
            if (pa == nil or pa > 0.5) and sum > 0.15 and sum < 2.85 then
                r = r + pr; g = g + pg; b = b + pb; n = n + 1
            end end
        if n >= 8 then return Color3.new(r / n, g / n, b / n) end
        if nf > 0 then return Color3.new(rf / nf, gf / nf, bf / nf) end
        return nil
    end)
    if ok and col then return col end
    return nil
end
local function jafSetPanelImage(frame, assetUri) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if not frame or not frame:IsA("GuiObject") then return end
    local existing = frame:FindFirstChild("JAFThemeBG")
    if assetUri == nil then if existing then existing:Destroy() end return end
    local img = existing
    if not img then
        img = Instance.new("ImageLabel")
        _P(img, "Name", "JAFThemeBG", "BackgroundTransparency", 1, "BorderSizePixel", 0, "ZIndex", 0, "ScaleType", Enum.ScaleType.Crop)
        local cor = frame:FindFirstChildOfClass("UICorner")
        local c = Instance.new("UICorner", img)
        c.CornerRadius = cor and cor.CornerRadius or UDim.new(0, 10)
        img.Parent = frame
    end
    _P(img, "Size", UDim2.new(1, 0, 1, 0), "Position", UDim2.new(0, 0, 0, 0), "Image", assetUri, "ImageTransparency", 0.05)
    img.ImageColor3 = Color3.fromRGB(200, 200, 200)
    pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
frame.ClipsDescendants = true end)
end
local JAF_IMAGE_PANELS = {
    "JustAFanSettings", "AutoStealUI", "JustAFanMiniActions",
    "XiAdminPanel", "JustAFanStatusHUD", "XiStealingHUD",
    "JustAFanWalkingBestBar", }
local JAF_GIF_ANIM_PANELS = JAF_IMAGE_PANELS
local function jafSetPanelTextStroke(frame, active) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local BLACK = Color3.fromRGB(0, 0, 0)
    for _, d in ipairs(frame:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            if active and d.BackgroundTransparency >= 1 then
                if d.TextStrokeTransparency ~= 0.4 then d.TextStrokeTransparency = 0.4 end
                d.TextStrokeColor3 = BLACK
            else
                d.TextStrokeTransparency = 1
            end end end end
function jafApplyThemeImageToPanels(assetUri) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if not assetUri and jafStopGifAnimation then jafStopGifAnimation() end
    local _yield = _G.JAF_ThemePaintYield ~= false
    for _, gn in ipairs(JAF_IMAGE_PANELS) do
        local sg = hubFind(gn)
        if sg then
            for _, frame in ipairs(sg:GetChildren()) do
                if frame:IsA("Frame") then
                    if assetUri then frame.BackgroundTransparency = math.max(frame.BackgroundTransparency, 0.55) end
                    pcall(jafSetPanelImage, frame, assetUri)
                    pcall(jafSetPanelTextStroke, frame, assetUri ~= nil)
                end end
            if _yield then RunService.Heartbeat:Wait() end
        end end end
_G.JAF_HubStart = _G.JAF_HubStart or tick()
if _G.JAF_HeavyReady == nil then _G.JAF_HeavyReady = false end
function _G.JAF_LoadHeavyNow() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_G.JAF_HeavyReady = true end
if not _G.JAF_CacheFillWatch then
    _G.JAF_CacheFillWatch = true
    task.spawn(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local _emptyScans = 0
        local _lastScanned, _scanStallAt = -1, tick()
        while not _G.JAF_CacheFilledAt do
            local _scanned = (_G.JAF_PlotsTotal or 0) > 0 and (_G.JAF_PlotsScanned or 0) >= (_G.JAF_PlotsTotal or 0)
            local _hasCache = SharedState.AllAnimalsCache and #SharedState.AllAnimalsCache > 0
            local _ps = _G.JAF_PlotsScanned or 0
            if _hasCache and not _G.JAF_FirstBrainrotAt then _G.JAF_FirstBrainrotAt = tick() end
            if _ps ~= _lastScanned then _lastScanned = _ps; _scanStallAt = tick() end
            if _scanned and _hasCache then
                _G.JAF_CacheFilledAt = tick()
                break
            elseif _scanned then
                _emptyScans = _emptyScans + 1
                local _pullDone = (_G.JAF_PullOnJoin == false) or (_G.JAF_PullMs ~= nil)
                    or ((tick() - (_G.JAF_HubStart or 0)) > (tonumber(_G.JAF_PullGrace) or 4))
                if _emptyScans >= 3 and _pullDone then _G.JAF_CacheFilledAt = tick() break end
            elseif _hasCache and (tick() - _scanStallAt) > (_G.JAF_ScanStallTime or 3) then
                _G.JAF_CacheFilledAt = tick()
                break
            else
                _emptyScans = 0
            end
            task.wait(0.1)
        end end) end
function _G.JAF_WaitHeavy() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local _wasReady = _G.JAF_HeavyReady
    local hub = _G.JAF_HubStart or tick()
    while not _G.JAF_BootReady and (tick() - hub) < (_G.JAF_HeavyAbsCap or 12) do task.wait(0.05) end
    while not _G.JAF_HeavyReady and not _G.JAF_CacheFilledAt and (tick() - hub) < (_G.JAF_HeavyAbsCap or 12) do task.wait(0.1) end
    local s = _G.JAF_CacheFilledAt or hub
    while not _G.JAF_HeavyReady and (tick() - s) < (_G.JAF_HeavyMaxWait or 3) do task.wait(0.1) end
    do
        local _grace = tonumber(_G.JAF_HeavyMinGrace) or 1.5
        local _good = 0
        while (tick() - s) < _grace do
            local dt = task.wait(0.05)
            if type(dt) == "number" and dt < 0.025 then
                _good = _good + 1
                if _good >= 2 and _G.JAF_HeavyReady then break end
            else
                _good = 0
            end end end
    _G.JAF_HeavyReady = true
    if not _G.JAF_HeavyNoStagger and not _wasReady then
        local _n = (_G.JAF_HeavyReleaseSeq or 0) + 1
        _G.JAF_HeavyReleaseSeq = _n
        local _spacing = tonumber(_G.JAF_HeavyStaggerFrames) or 3
        local _frames  = math.min((_n - 1) * _spacing, tonumber(_G.JAF_HeavyStaggerCap) or 60)
        for _ = 1, _frames do task.wait() end
    end end
task.spawn(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local w = tick()
    local FALLBACK = _G.JAF_HeavyFallback or 3
    local ENDCAP   = _G.JAF_HeavyTpEndCap or 14
    while not _G.JAF_TpActive and not _G.JAF_HeavyReady and not _G.JAF_CacheFilledAt and (tick() - w) < (_G.JAF_HeavyAbsCap or 12) do task.wait(0.05) end
    local base = _G.JAF_CacheFilledAt or w
    while not _G.JAF_TpActive and not _G.JAF_HeavyReady and (tick() - base) < FALLBACK do task.wait(0.05) end
    if _G.JAF_TpActive and not _G.JAF_HeavyReady then
        local doneFor = 0
        while not _G.JAF_HeavyReady and (tick() - base) < ENDCAP do
            if _G.JAF_TpActive then doneFor = 0 else doneFor = doneFor + 1 end
            if doneFor >= 6 then break end
            task.wait(0.05)
        end
        if not _G.JAF_HeavyReady then task.wait(_G.JAF_HeavyPostTp or 0.25) end
    end
    _G.JAF_HeavyReady = true
end)
function jafStopGifAnimation() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    _G.JAF_GifToken = (_G.JAF_GifToken or 0) + 1
    _G.JAF_GifFrames = nil
    _G.JAF_GifDelays = nil
end
jafParseGifFrames = function(data) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if type(data) ~= "string" or data:sub(1, 3) ~= "GIF" then return 0, {} end
    local byte = string.byte
    local p = 7
    local packed = byte(data, p + 4)
    p = p + 7
    if packed and packed >= 128 then p = p + 3 * (2 ^ ((packed % 8) + 1)) end
    local frames, delays, lastDelay = 0, {}, 0
    while p <= #data do
        local b = byte(data, p)
        if not b or b == 0x3B then break
        elseif b == 0x21 then
            local label = byte(data, p + 1); p = p + 2
            if label == 0xF9 then lastDelay = (byte(data, p + 2) or 0) + (byte(data, p + 3) or 0) * 256 end
            while true do local bs = byte(data, p); if not bs then break end; p = p + 1 + bs; if bs == 0 then break end end
        elseif b == 0x2C then
            frames = frames + 1
            delays[frames] = (lastDelay >= 2 and lastDelay or 10) / 100
            lastDelay = 0
            local lp = byte(data, p + 9); p = p + 10
            if lp and lp >= 128 then p = p + 3 * (2 ^ ((lp % 8) + 1)) end
            p = p + 1
            while true do local bs = byte(data, p); if not bs then break end; p = p + 1 + bs; if bs == 0 then break end end
        else break end
    end
    return frames, delays
end
local function jafStartGifLoop() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    _G.JAF_GifToken = (_G.JAF_GifToken or 0) + 1
    local myToken = _G.JAF_GifToken
    local i, acc = 1, 0
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function(dt) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if _G.JAF_GifToken ~= myToken then conn:Disconnect(); return end
        if _G.JAF_TpActive then return end
        local frames = _G.JAF_GifFrames
        local delays = _G.JAF_GifDelays
        if not frames or #frames < 1 then return end
        acc = acc + dt
        local need = (delays and delays[i]) or 0.08
        if acc < need then return end
        acc = acc - need
        if acc > 0.4 then acc = 0 end
        i = (i % #frames) + 1
        local asset = frames[i]
        _G.JAF_ThemeImageAsset = asset
        for _, gn in ipairs(JAF_GIF_ANIM_PANELS) do
            local sg = hubFind(gn)
            if sg then
                for _, fr in ipairs(sg:GetChildren()) do
                    if fr:IsA("Frame") then local bg = fr:FindFirstChild("JAFThemeBG") if bg then bg.Image = asset end end
                end end end end) end
jafSetupGifAnimation = function(gifUrl) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if type(gifUrl) ~= "string" then return false end
    do local g = tick() while tick() - g < 16 do if game:IsLoaded() and _G.JAF_FirstLoadTpDone then break end task.wait(0.25) end end
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if not req then return false end
    local function get(u) LPH_ATTRIBUTES(ERROR_HANDLING(false))
local ok, r = pcall(req, { Url = u, Method = "GET" }); if ok and r then return r.Body or r.body end end
    local gif = get(gifUrl)
    if not gif or gif:sub(1, 3) ~= "GIF" then return false end
    local fcount, delays = jafParseGifFrames(gif)
    if fcount < 2 then return false end
    local CAP = 90
    local idxs = {}
    if fcount <= CAP then for i = 0, fcount - 1 do idxs[#idxs + 1] = i end
    else local step = fcount / CAP; for i = 0, CAP - 1 do idxs[#idxs + 1] = math.floor(i * step) end end
    local frameDelays = {}
    for j = 1, #idxs do
        local upper = idxs[j + 1] or fcount
        local d = 0
        for di = idxs[j] + 1, upper do d = d + (delays[di] or 0.1) end
        frameDelays[j] = math.max(d, 0.03)
    end
    local host = gifUrl:gsub("^https?://", "")
    local enc = (host:gsub("[^%w%-%._~/]", function(ch) LPH_ATTRIBUTES(ERROR_HANDLING(false))
return string.format("%%%02X", string.byte(ch)) end))
    jafEnsureMediaDir()
    local frames, done, nextK, active = {}, 0, 0, 0
    local CONC = 8
    local function pump() LPH_ATTRIBUTES(ERROR_HANDLING(false))
        while active < CONC and nextK < #idxs do
            nextK = nextK + 1; active = active + 1
            local k = nextK
            local pageIdx = idxs[k]
            task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local body = get("https://images.weserv.nl/?url=" .. enc .. "&w=130&output=png&page=" .. pageIdx)
                if body and body:byte(1) == 0x89 then
                    local fn = JAF_MEDIA_DIR .. "/JAFgiff_" .. k .. ".png"
                    if pcall(writefile, fn, body) then frames[k] = jafGetCustomAsset(fn) end
                end
                active = active - 1; done = done + 1
                pump()
            end) end end
    pump()
    local function rebuild() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local s, sd = {}, {}
        for k = 1, #idxs do if frames[k] then s[#s + 1] = frames[k]; sd[#sd + 1] = frameDelays[k] end end
        return s, sd
    end
    local t0 = tick()
    local timeout = math.max(20, #idxs * 0.7)
    while done < #idxs and tick() - t0 < timeout do task.wait(0.1) end
    local seq, seqD = rebuild()
    if #seq < 2 then return false end
    pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
game:GetService("ContentProvider"):PreloadAsync(seq) end)
    _G.JAF_GifFrames = seq; _G.JAF_GifDelays = seqD
    jafStartGifLoop()
    return true
end
function jafApplyImageTheme(url) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if jafStopGifAnimation then jafStopGifAnimation() end
    local asset, reason = jafDownloadWebImage(url)
    if not asset then return false, reason or "download failed" end
    _G.JAF_ThemeImageAsset = asset
    local avg = jafImageAverageColor(asset)
    local displayable = (avg ~= nil)
    if not avg and _G.JAF_LastImageBytes and jafJpegAverageColor then
        local r, g, b = jafJpegAverageColor(_G.JAF_LastImageBytes)
        if r then avg = Color3.fromRGB(r, g, b) end
    end
    if displayable then
        task.defer(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
pcall(jafApplyThemeImageToPanels, asset) end)
    else
        _G.JAF_ThemeImageAsset = nil
        task.defer(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
pcall(jafApplyThemeImageToPanels, nil) end)
    end
    if not avg then return false, "loaded the image but couldn't read its colour (try a smaller / non-corrupt image)" end
    buildCustomThemeFromColor(avg)
    if applyTheme then applyTheme("custom") end
    if displayable and _G.JAF_GifUrl and jafSetupGifAnimation and Config.GifAnimate ~= false then
        task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
pcall(jafSetupGifAnimation, _G.JAF_GifUrl) end)
    end
    return true
end
if not Config.DefaultWhiteMigrated then
    Config.DefaultWhiteMigrated = true
    if Config.CurrentTheme == nil or Config.CurrentTheme == "preto" then Config.CurrentTheme = "white" end
    pcall(SaveConfig)
end
do
    local removedRemap = { red = "rose", orange = "dawg", green = "ocean", gold = "white", preto = "midnight", pink = "rose" }
    local remapped = removedRemap[Config.CurrentTheme]
    if remapped then Config.CurrentTheme = remapped pcall(SaveConfig) end
end
if Config.CurrentTheme and THEMES[Config.CurrentTheme] then for k, v in pairs(THEMES[Config.CurrentTheme]) do Theme[k] = v end end
-- FORCE the monochrome (Modern GUI) look over any saved/custom/image theme, so the
-- ENTIRE hub matches. Runs before any panel is built, so every Theme-based UI follows.
do
    Theme.Background       = Color3.fromRGB(20, 20, 20)
    Theme.Surface          = Color3.fromRGB(34, 34, 34)
    Theme.SurfaceHighlight = Color3.fromRGB(46, 46, 46)
    Theme.Accent1          = Color3.fromRGB(235, 235, 235)
    Theme.Accent2          = Color3.fromRG
