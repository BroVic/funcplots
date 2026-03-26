param([switch]$Test)

if ($Test) {
    $cmd = "library(shiny); runApp(launch.browser = TRUE)"
} else {
    $cmd = "shinytest2::test_app()
}

Rscript -e $cmd

