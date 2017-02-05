#!/bin/bash

modsPath=""
version=""
modsCfgPath=""
modsList=()
tempModsList=""
shareModsLoc="/home/steam/ARK_Mod_Updates/"

# Get which version user is updating
case "$1" in
        core)
                version=core
                modsPath=/home/steam/ARKdedicated/ShooterGame/Content/Mods
                modsCfgPath=/home/steam/ARKdedicated/ShooterGame/Saved/Config/LinuxServer
                ;;
        annanuki)
                version=annanuki
                modsPath=/home/steam/ARK_annunaki/ARKdedicated/ShooterGame/Content/Mods
                modsCfgPath=/home/steam/ARK_annunaki/ARKdedicated/ShooterGame/Saved/Config/LinuxServer
                ;;
        ecore)
                version=ecore
                modsPath=/home/steam/ARK_annunaki/ARK_Extinction_Core/ShooterGame/Content/Mods
                modsCfgPath=/home/steam/ARK_annunaki/ARK_Extinction_Core/ShooterGame/Saved/Config/LinuxServer
                ;;
        *)
                echo $"Usage: ark_updatemods.sh version where \"version\" is \"core\", \"annanuki\", or \"ecore\""
                ;;
esac

# Now that we have a version, grab mod list from cfg
while [ "$version" != "" ] ; do
        cd $modsCfgPath
        tempModsList=$(grep 'ActiveMods' GameUserSettings.ini)
        tempModsList=${tempModsList:11},TheCenter
        IFS=',' read -r -a modsList <<< "$tempModsList"

        # Iterate through version's mod list
        for mod in "${modsList[@]}"
        do
                # Compare file timestamps and if share directory file's timestamp is
                # newer then copy mod directory and .mod file to version's mod dir
                if [ "$shareModsLoc$mod.mod" -nt "$modsPath/$mod.mod" ]; then
                        echo "Windows $mod.mod is newer than $version $mod.mod ... Copying ..."
                        cp -rf $shareModsLoc$mod* $modsPath
                        echo "New timestamps:"
                        ls -ld "$modsPath/$mod" | awk '{print $6,$7,$8,$9}'
                        ls -l "$modsPath/$mod.mod" | awk '{print $6,$7,$8,$9}'
                        echo ""
                else
                        echo "$shareModsLoc$mod.mod is not newer than $modsPath/$mod.mod ... No Action ..."
                        echo ""
                fi
        done

        # reset version
        version=""

        echo "Finished updating $version mods."
done