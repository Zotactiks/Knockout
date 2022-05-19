local QBCore = exports["qb-core"]:GetCoreObject()
local knockedOut = false
local wait = 15
local count = 60
local isdead = false

Citizen.CreateThread(
    function()
        while true do
            Wait(1)
            local myPed = GetPlayerPed(-1)
            PlayerData = QBCore.Functions.GetPlayerData()
            if IsPedInMeleeCombat(myPed) then
                --  {UNARMED ONLY}
                if (HasPedBeenDamagedByWeapon(myPed, GetHashKey("WEAPON_UNARMED"), 0)) then
                    -- Health to be knocked out
                    if GetEntityHealth(myPed) < 145 then
                        SetPlayerInvincible(PlayerId(), false)
                        -- Position taken by your Ped
                        SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                        -- Time to wait
                        wait = 60
                        QBCore.Functions.Progressbar("knocked-out", "unconscious...", 45000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true
                            },
                            {},
                            {},
                            {},
                            function()
                                -- Done
                                QBCore.Functions.Notify("Finally you're awake!", "success", 5000)
                            end,
                            function()
                            end,
                            "fa-solid fa-face-dizzy"
                        )
                        knockedOut = true
                        -- Health after knockout preferably dont make it more than 150 (50 %) because people will abuse with it {No need to go to hospital or so}
                        SetEntityHealth(myPed, 140)
                    end
                end
            end
            if knockedOut == true then
                --Your ped is able to die
                SetPlayerInvincible(PlayerId(), false)
                DisablePlayerFiring(PlayerId(), true)
                SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                ResetPedRagdollTimer(myPed)
                -- Blur Cam
                SetTimecycleModifier("hud_def_blur")
                if wait >= 0 then
                    count = count - 1
                    if count == 0 then
                        count = 60
                        wait = wait - 1
                        --- in case bark
                        if GetEntityHealth(myPed) <= 50 then
                            -- Ped healing
                            SetEntityHealth(myPed, GetEntityHealth(myPed) + 2)
                        end
                    end
                else
                    -- Remove Blue cam
                    SetTimecycleModifier("")
                    SetTransitionTimecycleModifier("")
                    -- Ped Able to die again
                    SetPlayerInvincible(PlayerId(), false)
                    knockedOut = false
                end
            end
            -- Simple clear Knockout if Dead
            if PlayerData.metadata['isdead']then
                 -- Remove Konockout effect
                 SetTimecycleModifier("")
                 SetTransitionTimecycleModifier("")
                 knockedOut = false
             end
        end
    end
)
