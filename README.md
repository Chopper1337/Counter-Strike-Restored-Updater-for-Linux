# Counter-Strike: Restored Updater for Linux

> [!CAUTION]
> The CSR team has not yet created an equivalent API for their Linux client files. As a proof of concept, this version uses the currently available API which provides Windows client files.

[Counter-Strike: Restored](https://csrestored.com/app)

This is not an official updater for CSR. I am not a member of the CSR team.

This updater script utilises the [CSR API](https://download-api.csrestored.com/) to individually verify files and update them if necessary.

It also supports the creation of new directories which should allow the CSR team to push updates which may require new directories instead of just new files.

The script assumes you have already correctly installed CSR. If you haven't, go through their support on Discord for the latest instructions. The Discord should be linked on the [CSR website](https://csrestored.com/app).

## Usage

Clone the repo:

```
git clone https://github.com/Chopper1337/Counter-Strike-Restored-Updater-for-Linux
```

Make the script executable:

```
chmod +x ./Counter-Strike-Restored-Updater-for-Linux/updater.sh
```

Copy it to your CSR game directory:

(Your install directory may not be the same)

```
cp ./Counter-Strike-Restored-Updater-for-Linux/updater.sh /home/$USER/.steam/steam/ubuntu12_32/steamapps/content/app_730/depot_731/
```
