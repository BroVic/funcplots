param([switch]$Test)

if ($Test) {
    $cmd = "Sys.setenv(NOT_CRAN = 'true'); shinytest2::test_app('.')"
} else {
    $cmd = "library(shiny); runApp(launch.browser = TRUE)"
}

$env:RENV_CONFIG_SYNCHRONIZED_CHECK = 'FALSE'
Rscript -e $cmd

