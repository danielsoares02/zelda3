# Altere o runtime para "windows", "linux" ou "switch"
param($runtime = "switch", $lang = "pt")

Set-Location $PSScriptRoot
$volume = "${PSScriptRoot}/../:/zelda3"

function Main {
    BuildContainer
    
    if ($runtime -eq "switch") {
        docker run --rm -v $volume -e DEVKITPRO=/opt/devkitpro zelda3 sh -c 'cd platform/switch && make'
        docker run --rm -v $volume zelda3 make RUNTIME=$runtime LANGUAGE=$lang TARGET_EXEC=''

        New-Item -ItemType Directory -Force -Path "switch"
        Copy-Item "../platform/switch/zelda3.ini" "switch/zelda3.ini" 
        Move-Item "../platform/switch/zelda3.nro" "switch/zelda3.nro"
    } else {
        docker run --rm -v $volume zelda3 make RUNTIME=$runtime LANGUAGE=$lang
    }
}
  
function BuildContainer {
    docker build . -t zelda3
}

Main