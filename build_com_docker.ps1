param($runtime = "switch", $lang = "pt")

Set-Location $PSScriptRoot
$volume = "${PSScriptRoot}:/zelda3"

function Main {
    BuildContainer
    
    if ($runtime -eq "switch") {
        docker run --rm -v $volume -e DEVKITPRO=/opt/devkitpro zelda3 sh -c 'cd src/platform/switch && make'
        docker run --rm -v $volume zelda3 make RUNTIME=$runtime LANGUAGE=$lang TARGET_EXEC=''

        New-Item -ItemType Directory -Force -Path "builds/switch/zelda3"
        Copy-Item "src/platform/switch/zelda3.ini" "builds/switch/zelda3/zelda3.ini" 
        Copy-Item "src/platform/switch/zelda3.nro" "builds/switch/zelda3/zelda3.nro" 
        Copy-Item "builds/zelda3_assets.dat" "builds/switch/zelda3/zelda3_assets.dat" 
    } else {
        docker run --rm -v $volume zelda3 make RUNTIME=$runtime LANGUAGE=$lang
    }
}
  
function BuildContainer {
    docker build . -t zelda3
}

Main