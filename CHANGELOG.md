# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.8.1] - 2022-11-22
### Added
* Danish translation

### Changed
* Desugaring-related bugfix for Android 12L and Android 13

## [1.8.0] - 2022-11-15
Thanks to all the Hacktoberfest participants, translators, and other volunteers for helping out!

### Added
* Turkish translation
* Null safety
* Tooltips for better accessibility
* On-hover timer resume buttons
* Directly visible timer stop button
* Project action menu for discoverability
* Filter indicator
* Press enter to start timer
* Support for Android 13 per-app localization
* Monochrome launcher icon

### Changed
* Translations
* Updated dependencies
* Refactored, fixed up a lot of code
* Increased Android compile SDK
* Clearer import/export labels
* Settings Icon
* Numerals font
* Replaced gesture-based date removal with an icon
* Move "set to current time" to menu in timer editor
* Low contrasts on labels and icons

### Fixed
* Fixed automated screenshot tests
* Swiper
* Storage access permissions
* CastError
* Archived project
* Theme dropdown contrast
* URL launching
* firstDate bug

## [1.7.2] - 2022-05-09
### Fixed
* Fixed bugs for Android 12 users

## [1.7.1] - 2022-05-02
### Added
* F-Droid release

## [1.7.0] - 2022-03-22
### Added
* Linux support!
* Norwegian translations
* Czech translations
* Markdown notes for timers
* Notifications
* Setting for allowing a single timer at a time

### Changed
* Updated dependencies
* Code cleaned up

### Fixed
* Various translation fixes

## [1.6.0] - 2021-01-07
### Added
* Added setting to automatically filter out timers older than the last Monday
* Added setting to only allow a single active timer at once (when creating new ones)
* Added ability to archive projects & their respective timers
* Added app badge notifications on iOS and Android launchers which support the feature to indicate running timers
* Added notifications when timers are running in the background
* Added ability to import records from a database
* Added ability to record markdown-formatted notes for individual timers

### Changed
* Search bar now gets focus immediately upon tapping the search button
* No more "default project" setting (it was buggy and I didn't like it in practice)

### Fixed
* Always delimit fields when exporting CSV files
* Fixed dashboard top bar search text & icon colour
* Fixed some translations (thanks @SeaPants, @danielpetrica)

## [1.5.0] - 2020-04-07
### Added
* Added ability to search for timers in the dashboard
* Added ability to filter timers by time and project in the dashboard
* Added a settings screen
* Added ability to change the theme manually
* Added ability to change the language manually
* Added autocomplete on timer description fields
* Added ability to collapse days
* Added settings to control autocomplete, day collapsing, timer grouping
* Added a time table report, listing per-project time sums

### Changed
* Moved the menu button to be under the Time Cop logo on the left side, to make room for the search and filter buttons
* Fixed some Russian translations thanks to @4name
* Marked hand-translated translations as such so the automatic translator doesn't touch them
* Normalized order of translations across all languages

### Fixed
* Fixed negative duration timers by adjusting timer ends accordingly

## [1.4.0+23] - 2020-03-02
### Added
* Italian translation thanks to @danielpetrica and @Pomettini
* Added ability to swipe-to-resume on the parent of grouped timers (thanks [cl3misch](https://news.ycombinator.com/item?id=22750635) on HN!)

## [1.3.3+22] - 2020-03-30
### Added
* 3 report charts: project breakdown pie chart, weekly total hours line chart, and average daily hours bar chart

### Fixed
* Fixed start button positioning for right-to-left languages (Arabic)

## [1.2.0+14] - 2020-03-27
### Changed
* Added stop and add functions to the start button depending on whether any timers are running or not

## [1.1.0+12] - 2020-03-19
### Added
* Automatically group similar timers on the dashboard view within each day
* Option to group similar timers on a day-by-day basis when exporting

### Changed
* Changed UI of selecting which projects to filter by when exporting to be in line
  with the other sections on the export page

## [1.0.0+11] - 2020-03-14
### Added
* Ability to start / stop / create / edit / delete timers
* Ability to create / edit / delete projects
* Ability to export database file
* Ability to export csv of filtered data

[Unreleased]: https://github.com/hamaluik/timecop/compare/v1.8.0...HEAD
[1.8.0]: https://github.com/hamaluik/timecop/compare/v1.7.2...v1.8.0
[1.7.2]: https://github.com/hamaluik/timecop/compare/v1.7.1...v1.7.2
[1.7.1]: https://github.com/hamaluik/timecop/compare/v1.7.0...v1.7.1
[1.7.0]: https://github.com/hamaluik/timecop/compare/v1.6.0...v1.7.0
[1.6.0]: https://github.com/hamaluik/timecop/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/hamaluik/timecop/compare/v1.4.0+23...v1.5.0
[1.4.0+23]: https://github.com/hamaluik/timecop/compare/v1.3.3+22...v1.4.0+23
[1.3.3+22]: https://github.com/hamaluik/timecop/compare/v1.2.0+14...v1.3.3+22
[1.2.0+14]: https://github.com/hamaluik/timecop/compare/v1.1.0+12...v1.2.0+14
[1.1.0+12]: https://github.com/hamaluik/timecop/compare/v1.0.0+11...v1.1.0+12
[1.0.0+11]: https://github.com/hamaluik/timecop/compare/223213...v1.0.0+11
