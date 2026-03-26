# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`funcplots` is an R Shiny application that visualizes mathematical functions. Users enter expressions (plain math or LaTeX), and the app parses, renders them as typeset equations (via MathJax), and plots them with ggplot2.

## Running the App

```r
# From R console
library(shiny)
runApp(launch.browser = TRUE)
```

```powershell
# From PowerShell (Windows)
.\run.ps1
```

## Running Tests

```r
# Run all tests (from R console, in project root)
shinytest2::test_app()

# Run only unit tests for utility functions (no browser needed)
testthat::test_file("tests/testthat/test-funs.R")

# Run server logic tests
testthat::test_file("tests/testthat/test-server.R")
```

The `test-funs.R` file uses `here::i_am()` to anchor file paths, so it must be run from within the project.

Snapshot files for `shinytest2` integration tests live in `tests/testthat/_snaps/shinytest2/`. To update snapshots after intentional UI changes, use `shinytest2::test_app(snapshot_update = TRUE)`.

## Dependency Management

This project uses `renv` for reproducible R environments. The `.Rprofile` auto-activates it. To restore the environment:

```r
renv::restore()
```

## Architecture

The app follows standard Shiny separation with three key files:

- **`ui.R`** — Layout using `bslib::page_sidebar()`. Sidebar holds inputs (expression text, x-range, download link); main panel holds the plot and a collapsible accordion for plot settings (color, line width).
- **`server.R`** — Reactive graph: user expression → `latex()` (LaTeX string) → `expr_string()` (R-evaluable string, bound to the "Plot!" button via `bindEvent`) → `xydata()` (data frame) → `gg_obj()` (ggplot object). The LaTeX display and the R evaluation pipelines are intentionally independent — display transformations (fraction formatting, etc.) do not affect the evaluated expression.
- **`R/funs.R`** — All pure utility functions sourced by both `server.R` and the test files.

### Expression Pipeline

User input flows through two parallel pipelines:

1. **Display pipeline** (for MathJax rendering):
   `input$expr` → `remove_mathjax_delims()` → `make_latex_fractions()` → `finalize_equation()` → `renderUI` with `withMathJax()`

2. **Evaluation pipeline** (for plotting):
   `input$expr` → same LaTeX string → `modify_roots()` → `modify_factorials()` → `latex2r::latex2r()` → `eval()` via `eval_r_expr()`

Key limitation: `latex2r` does not support higher-order roots (`\sqrt[n]{x}`) or factorials, so `modify_roots()` and `modify_factorials()` pre-process these before passing to `latex2r`.

## CI

GitHub Actions (`.github/workflows/check-app.yml`) runs `shinytest2` tests on push/PR to `master` and `dev` branches using Windows + R release.
