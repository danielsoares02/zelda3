param($runtime = "windows", $lang = "pt")

Set-Location $PSScriptRoot
$volume = "${PSScriptRoot}:/zelda3"

function Main {
    BuildContainer
    
    docker run --rm -v $volume zelda3 make RUNTIME=$runtime LANGUAGE=$lang
}
  
function BuildContainer {
    docker build . -t zelda3
}

Main