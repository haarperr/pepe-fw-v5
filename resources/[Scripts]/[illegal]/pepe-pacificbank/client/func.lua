function LockDownStart()
    Citizen.Wait(12000)
    if not copsCalled then
        if Config.PacificB["alarm"] then
            --TriggerServerEvent("pepe-pacific:server:callCops", GetEntityCoords(PlayerPedId()))
            copsCalled = true
        end
    end
    -- SpawnSecurity()
    StartLockDownEscape()
    TriggerServerEvent("pepe-doorlock:server:updateState", 35, true)
    TriggerServerEvent("pepe-doorlock:server:updateState", 36, true)
end

function LockPick()
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(
        PlayerPedId(),
        "veh@break_in@0h@p_m_one@",
        "low_force_entry_ds",
        3.0,
        3.0,
        -1,
        16,
        0,
        false,
        false,
        false
    )
    LockPicking = true
    Citizen.CreateThread(
        function()
            while LockPicking do
                TaskPlayAnim(
                    PlayerPedId(),
                    "veh@break_in@0h@p_m_one@",
                    "low_force_entry_ds",
                    3.0,
                    3.0,
                    -1,
                    16,
                    0,
                    0,
                    0,
                    0
                )
                Citizen.Wait(1000)
            end
        end
    )
end

function StartMiniGamePacific()
    
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function StartLockDownEscape()
    Citizen.SetTimeout(
        17 * 60 * 1000,
        function()
            if not LockDownEnded then
                TriggerServerEvent("pepe-doorlock:server:updateState", 35, true)
                TriggerServerEvent("pepe-doorlock:server:updateState", 36, true)
            end
        end
    )
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function loadParticleDict(ParticleDict)
    RequestNamedPtfxAsset("des_vaultdoor")
    while not HasNamedPtfxAssetLoaded("des_vaultdoor") do
        Citizen.Wait(0)
    end
end

function GetMoneyFromTrolly(TrollyNumber)
    local CurrentTrolly =
        GetClosestObjectOfType(
        Config.Trollys[TrollyNumber]["Coords"]["X"],
        Config.Trollys[TrollyNumber]["Coords"]["Y"],
        Config.Trollys[TrollyNumber]["Coords"]["Z"],
        1.0,
        269934519,
        false,
        false,
        false
    )
    local MoneyObject = CreateObject(MoneyModel, GetEntityCoords(PlayerPedId()), true)
    SetEntityVisible(MoneyObject, false, false)
    AttachEntityToEntity(
        MoneyObject,
        PlayerPedId(),
        GetPedBoneIndex(PlayerPedId(), 60309),
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        false,
        false,
        false,
        false,
        0,
        true
    )
    local GrabBag =
        CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local GrabOne =
        NetworkCreateSynchronisedScene(
        GetEntityCoords(CurrentTrolly),
        GetEntityRotation(CurrentTrolly),
        2,
        false,
        false,
        1065353216,
        0,
        1.3
    )
    NetworkAddPedToSynchronisedScene(
        PlayerPedId(),
        GrabOne,
        "anim@heists@ornate_bank@grab_cash",
        "intro",
        1.5,
        -4.0,
        1,
        16,
        1148846080,
        0
    )
    NetworkAddEntityToSynchronisedScene(
        GrabBag,
        GrabOne,
        "anim@heists@ornate_bank@grab_cash",
        "bag_intro",
        4.0,
        -8.0,
        1
    )
    SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
    NetworkStartSynchronisedScene(GrabOne)
    Citizen.Wait(1500)
    GrabbingMoney = true
    SetEntityVisible(MoneyObject, true, true)
    local GrabTwo =
        NetworkCreateSynchronisedScene(
        GetEntityCoords(CurrentTrolly),
        GetEntityRotation(CurrentTrolly),
        2,
        false,
        false,
        1065353216,
        0,
        1.3
    )
    NetworkAddPedToSynchronisedScene(
        PlayerPedId(),
        GrabTwo,
        "anim@heists@ornate_bank@grab_cash",
        "grab",
        1.5,
        -4.0,
        1,
        16,
        1148846080,
        0
    )
    NetworkAddEntityToSynchronisedScene(GrabBag, GrabTwo, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(
        CurrentTrolly,
        GrabTwo,
        "anim@heists@ornate_bank@grab_cash",
        "cart_cash_dissapear",
        4.0,
        -8.0,
        1
    )
    NetworkStartSynchronisedScene(GrabTwo)
    Citizen.Wait(37000)
    SetEntityVisible(MoneyObject, false, false)
    local GrabThree =
        NetworkCreateSynchronisedScene(
        GetEntityCoords(CurrentTrolly),
        GetEntityRotation(CurrentTrolly),
        2,
        false,
        false,
        1065353216,
        0,
        1.3
    )
    NetworkAddPedToSynchronisedScene(
        PlayerPedId(),
        GrabThree,
        "anim@heists@ornate_bank@grab_cash",
        "exit",
        1.5,
        -4.0,
        1,
        16,
        1148846080,
        0
    )
    NetworkAddEntityToSynchronisedScene(
        GrabBag,
        GrabThree,
        "anim@heists@ornate_bank@grab_cash",
        "bag_exit",
        4.0,
        -8.0,
        1
    )
    NetworkStartSynchronisedScene(GrabThree)
    NewTrolley = CreateObject(769923921, GetEntityCoords(CurrentTrolly) + vector3(0.0, 0.0, -0.985), true, false, false)
    SetEntityRotation(NewTrolley, GetEntityRotation(CurrentTrolly))
    GrabbingMoney = false
    TriggerServerEvent("pepe-pacific:server:set:trolly:state", TrollyNumber, true)
    TriggerServerEvent("pepe-pacific:server:rob:pacific:money")
    while not NetworkHasControlOfEntity(CurrentTrolly) do
        Citizen.Wait(1)
        NetworkRequestControlOfEntity(CurrentTrolly)
    end
    DeleteObject(CurrentTrolly)
    while DoesEntityExist(CurrentTrolly) do
        Citizen.Wait(1)
        DeleteObject(CurrentTrolly)
    end
    PlaceObjectOnGroundProperly(NewTrolley)
    Citizen.Wait(1800)
    DeleteEntity(GrabBag)
    DeleteObject(MoneyObject)
end

function CreateTrollys()
    RequestModel("hei_prop_hei_cash_trolly_01")
    for k, v in pairs(Config.Trollys) do
        Trolley = CreateObject(269934519, v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], 1, 0, 0)
        SetEntityHeading(Trolley, v["Coords"]["H"])
        FreezeEntityPosition(Trolley, true)
        SetEntityInvincible(Trolley, true)
        PlaceObjectOnGroundProperly(Trolley)
    end
end
