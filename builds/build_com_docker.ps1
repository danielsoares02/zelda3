# Altere o runtime para "windows", "linux" ou "switch"
param($runtime = "switch", $lang = "pt")

Set-Location $PSScriptRoot
$volume = "${PSScriptRoot}/../:/zelda3"

function Main {
    BuildContainer
    
    if ($runtime -eq "switch") {
        docker run --rm -v $volume -e DEVKITPRO=/opt/devkitpro zelda3 sh -c 'cd platform/switch && make'
        docker run --rm -v $volume zelda3 make RUNTIME=$runtime LANGUAGE=$lang TARGET_EXEC=''

        New-Item -ItemType Directory -Force -Path "switch/zelda3"
        Copy-Item "../platform/switch/zelda3.ini" "switch/zelda3/zelda3.ini" -Force
        Move-Item "../platform/switch/zelda3.nro" "switch/zelda3/zelda3.nro" -Force
        Move-Item "switch/zelda3_assets.dat" "switch/zelda3/zelda3_assets.dat" -Force
        Remove-Item "switch/zelda3.ini" -Force

        echo "Copie a pasta zelda3 para dentro da pasta `"/switch`" do Cartão SD do Switch" > "switch/README.txt"
    } else {
        docker run --rm -v $volume zelda3 make RUNTIME=$runtime LANGUAGE=$lang
    }
}
  
function BuildContainer {
    docker build . -t zelda3
}

Main