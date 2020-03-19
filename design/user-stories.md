<!--
 Copyright 2020 Kenton Hamaluik

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

## User Stories

- [x] App must be fully offline
- [x] Record time by starting a timer with a button
    - [x] Timers may (or may not) have descriptions
    - [x] Timers may (or may not) have a project
    - [x] Timers may be started with a missing description and/or project
    - [x] Timers may be started with a description and/or project pre-applied
    - [x] Timers must be manually stopped with a button
    - [x] Timers may be "resumed" by effectively cloning the project and description and starting from the current time
- [x] Multiple timers may be active at once
- [x] The user may specify a default project to pre-populate all new timers with
- [x] A “dashboard” screen will display:
    - [x] a list of the latest completed timers,
    - [x] the current running timers,
    - [x] an interface to start or create new timers
- [x] Timers may be edited (whether running or not). All data related to each timer may be changed:
    - [x] Start time
    - [x] End time
    - [x] Description
    - [x] Project
- [x] Timers may be deleted (whether running or not)
    - [x] A confirmation should be presented to the user to confirm the deletion
- [x] Projects can be created with a project name and a colour
    - [x] The colour will be pre-populated by the system
    - [x] The colour can be set by the user before creating the project
    - [x] The project name must never be empty
- [x] Each project can be edited:
    - [x] The project name
    - [x] The project colour
- [x] Export database using native OS sharing
- [x] Export data as `csv` (or `xlsx`?) using native OS sharing
    - [x] Optionally filtered by:
        1. Date
        2. Project
    - [x] Optionally grouped by timer descriptions on a daily basis
    - [x] Export format should be able to include:
        - [x] Timer description
        - [x] Timer project
        - [x] Timer start time (RFC 3339)
        - [x] Timer end time (RFC 3339)
        - [x] Timer length in hours
    - [x] Export settings should be persisted and re-used as defaults
- [x] The list of open-source software should be included
- [x] Starting / stopping timers should be located at the bottom of the screen to facilitate one-handed operation

### In Consideration

* An in-app-purchase should be available as a donation towards the development of the app.
    * Perhaps tied to the ability to export data (either reports or the database)?
* A reporting screen which gives you the same filtering options as exporting data in a spreadsheet but displays the results locally
    * As charts
    * As tables
* Ability to import a previously exported database, overwriting what we currently have