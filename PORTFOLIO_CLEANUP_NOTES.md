# Portfolio cleanup notes

This version reorganizes the original repository without changing its scientific scope.

Changes made:

1. Rewrote the README around purpose, features, example data, requirements, local execution, and scientific context.
2. Explicitly labels all included expression values as synthetic/demo data.
3. Replaced the hard-coded gene menu with choices generated dynamically from the loaded data.
4. Removed commented development code from `app.R`.
5. Moved wide-to-long example-data preparation into `prepare_example_data.R`.
6. Added `requirements.R` for package installation.
7. Renamed/presented the project as **Interactive Gene Expression Visualization with R Shiny**.
8. Explicitly describes the repository as a lightweight visualization application/demonstration rather than a production omics platform.
9. Added `.gitignore` for a cleaner public repository.
10. Removed institutional branding so the repository is presented as a personal portfolio project.
11. No open-source license is included at this time.
12. No screenshot was added, per current availability.

Before publishing, review the README wording and run the application locally to confirm expected behavior.


## v2 update: preserved exploratory development logic

Selected analytical steps from the original commented development code were restored in `exploratory_analysis.R` rather than placed back into `app.R`. These include wide-format group summaries, standard-error calculations, exploratory two-sample t-tests, long-format summary statistics, and a standalone ggplot example. This preserves evidence of the original analytical development process while keeping the Shiny application itself concise and readable.

## Final portfolio update

- Added `images/app_screenshot.jpg`, a screenshot of the working application using synthetic demonstration data.
- Embedded the screenshot in `README.md` under **Application preview** so visitors can understand the interface without running R locally.
- Clarified in the README that the screenshot contains only synthetic demonstration data and no research, patient, or institutional data.
- No live deployment is included; the application remains intended for local demonstration and portfolio documentation.
