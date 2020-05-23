function hashSearch(array, searchText) {
  var hash = {};
  for (var i = 0; i < array.length; i++) {
    if (hash[array[i]]) {
      hash[array[i]] = hash[array[i]].concat(i);
    } else {
      hash[array[i]] = [i];
    }
  }
  return hash[searchText];
}

function getMapValue(aMap, aKey) {
  if (aMap.hasOwnProperty(aKey)) {
    return aMap[aKey];
  } else return null;
}

function addToGroup(tsData, sEndOfWeek, aProjectKey, aWorkKey, aNote, aDayOfWeekNum, aMins) {

  weekData = getMapValue(tsData, sEndOfWeek);
  if (weekData == null) {
    weekData = {};
    tsData[sEndOfWeek] = weekData;
  }

  projectData = getMapValue(weekData, aProjectKey);
  if (projectData == null) {
    projectData = {};
    weekData[aProjectKey] = projectData;
  }

  workData = getMapValue(projectData, aWorkKey);
  if (workData == null) {
    workData = { notes: {}, days: Array(7).fill(0) };
    projectData[aWorkKey] = workData;
  }

  notesMap = workData["notes"];
  noteHrs = getMapValue(notesMap, aNote);
  if (noteHrs == null) {
    notesMap[aNote] = 0; // initialize hrs per note to 0
  }
  notesMap[aNote] = notesMap[aNote] + aMins;

  daysArray = workData["days"];
  daysArray[aDayOfWeekNum - 1] = daysArray[aDayOfWeekNum - 1] + aMins;
}

function getWorkKeyMap() {
  return {
    "reqs": "Requirements Gathering",
    "dev": "Development",
    "doc": "Documentation",
    "test": "Testing Support",
    "dep": "Deployment",
    "misc": "Miscellaneous"
  };
}

function getWorkKey(notes) {

  const workKeyMap = getWorkKeyMap();

  var workKey = null;
  for (key in workKeyMap) {
    if (workKeyMap.hasOwnProperty(key)) {
      if (notes.startsWith(key)) {
        workKey = key;
        break;
      }
    }
  }

  if (workKey == null) {
    workKey = "misc";
  }

  return workKey;
}

function getWeekNumStartOnMon(aDate) {

  var dateAtMidnight = new Date(aDate);
  dateAtMidnight.setHours(0, 0, 0, 0);
  const secsPerDay = 60 * 60 * 24;
  const milliSecsPerDay = secsPerDay * 1000;
  const oneJan = new Date(aDate.getFullYear(), 0, 1);
  const oneJanDayOfWeek = oneJan.getDay() || 7;

  let milliSecsSinceOneJan = dateAtMidnight - oneJan;
  let daysSinceOneJan = milliSecsSinceOneJan / milliSecsPerDay;
  return Math.ceil((daysSinceOneJan + oneJanDayOfWeek) / 7);
}

function getWeekEndOnSunday(aDate) {
  const dayOfWeek = aDate.getDay() || 7;
  const daysToAdd = 7 - dayOfWeek;

  var sunday = new Date(aDate);
  sunday.setDate(sunday.getDate() + daysToAdd);
  sunday.setHours(0, 0, 0, 0);
  return sunday;
}

function addWorkTime(tsData, project, workKey, notes, startTime, endTime, discount) {
  if (endTime.getDay() != startTime.getDay()) {
    var newStartTime = new Date(endTime);
    newStartTime.setHours(0, 0, 0, 0);
    addWorkTime(tsData, project, workKey, notes, newStartTime, endTime, discount);

    endTime = new Date(startTime);
    endTime.setHours(23, 59, 59, 999)
  }
  var millis = Math.abs(endTime - startTime);
  if (discount > 0) {
    millis = millis * (1 - discount);
  }
  var mins = (millis / 1000) / 60;
  addToGroup(tsData, getWeekEndOnSunday(startTime), project, workKey, notes, startTime.getDay() || 7, mins);
}

function createTimesheet() {

  var lightBlue = "#e8f0f3";
  var darkBlue = "#5b95f9";
  var ui = SpreadsheetApp.getUi();
  var ss = SpreadsheetApp.getActiveSpreadsheet();

  var settingsSheet = ss.getSheetByName("settings");
  var settingsValues = settingsSheet.getRange(1, 1, 2, 2).getValues();
  var timesheetEndOfWeek = settingsValues[1][1];

  var sheet = ss.getSheetByName("timecop");

  var rangeData = sheet.getDataRange();
  var lastColumn = rangeData.getLastColumn();
  var lastRow = rangeData.getLastRow();
  var searchRange = sheet.getRange(2, 1, lastRow - 1, lastColumn);

  var tsData = {};

  // Get array of values in the search Range
  var rangeValues = searchRange.getValues();
  for (r = 0; r < lastRow - 1; r++) {
    var project = rangeValues[r][1];
    var spaceInProject = project.indexOf(' ');
    if (spaceInProject > 0) {
      project = project.substring(0, spaceInProject);
    }
    var notes = rangeValues[r][2];
    var noteAndWorkKey = getWorkKeyFromNote(notes);
    var startTime = convert2jsDate(rangeValues[r][3]);
    var endTime = convert2jsDate(rangeValues[r][4]);
    var discount = rangeValues[r][6];

    addWorkTime(tsData, project, noteAndWorkKey.workKey, noteAndWorkKey.note, startTime, endTime, discount);
  };

  var rows = createTimeSheetArray(tsData, timesheetEndOfWeek);

  var totCols = 11; // Week, Project, Work, Notes, Total Hours, Mon, Tue, Wed, Thu, Fri, Sat, Sun
  var timeSheet = ss.getSheetByName("timesheet");
  timeSheet.getRange(1, 1, rows.length + 100, totCols + 50).clear();

  var range = timeSheet.getRange(1, 1, rows.length, totCols);
  range.setValues(rows);

  weekEndCell = timeSheet.getRange(1, totCols - 6, 1, 7);
  weekEndCell.merge();
  weekEndCell.setNumberFormat("MMM d, yyyy");
  weekEndCell.setFontWeight("bold");
  weekEndCell.setBackground(darkBlue);

  for (var c = 1; c <= rows[0].length; c++) {
    headerRow = timeSheet.getRange(2, c);
    headerRow.setFontWeight("bold");
    headerRow.setBackground(darkBlue);

    totalsRow = timeSheet.getRange(rows.length, c);
    totalsRow.setFontWeight("bold");
    totalsRow.setBackground(darkBlue);
  }

  for (var r = 3; r <= rows.length - 1; r++) {
    for (var c = 1; c <= rows[0].length; c++) {
      timeSheet.getRange(r, c).setBorder(true, true, true, true, false, false, "grey", SpreadsheetApp.BorderStyle.SOLID);
      if (r % 2 == 0) {
        timeSheet.getRange(r, c).setBackgroundColor(lightBlue);
      }
    }

    projectCol = timeSheet.getRange(r, 1);
    projectCol.setFontWeight("bold");
    projectCol.setBackground("lightgrey");

    TotalCol = timeSheet.getRange(r, 4);
    TotalCol.setFontWeight("bold");
    TotalCol.setBackground("lightgrey");
  }

  totalLabel = timeSheet.getRange(rows.length, 3);
  totalLabel.setFontWeight("bold");
  totalLabel.setBackground(darkBlue);
  totalLabel.setHorizontalAlignment("right")

};

// from: https://stackoverflow.com/a/33813783/5572674
/**
 * Convert any spreadsheet value to a date.
 * Assumes that numbers are using Epoch (days since 1 Jan 1900, e.g. Excel, Sheets).
 * 
 * @param {object}  value  (optional) Cell value; a date, a number or a date-string 
 *                         will be converted to a JavaScript date. If missing or
 *                         an unknown type, will be treated as "today".
 *
 * @return {date}          JavaScript Date object representation of input value.
 */
function convert2jsDate(value) {
  var jsDate = new Date();  // default to now
  if (value) {
    // If we were given a date object, use it as-is
    if (typeof value === 'date') {
      jsDate = value;
    }
    else {
      if (typeof value === 'number') {
        // Assume this is spreadsheet "serial number" date
        var daysSince01Jan1900 = value;
        var daysSince01Jan1970 = daysSince01Jan1900 - 25569 // 25569 = days TO Unix Time Reference
        var msSince01Jan1970 = daysSince01Jan1970 * 24 * 60 * 60 * 1000; // Convert to numeric unix time
        var timezoneOffsetInMs = jsDate.getTimezoneOffset() * 60 * 1000;
        jsDate = new Date(msSince01Jan1970 + timezoneOffsetInMs);
      }
      else if (typeof value === 'string') {
        // Hope the string is formatted as a date string
        jsDate = new Date(value);
      }
    }
  }
  return jsDate;
}

function onOpen() {
  var ui = SpreadsheetApp.getUi();
  ui.createMenu('My Timesheet')
    .addItem('Create Timesheet', 'createTimesheet')
    .addToUi();
};

function getWorkKeyFromNote(note, workKey) {
  var workKey = getWorkKey(note);

  if (workKey != null && workKey.length > 0) {
    if (note.startsWith(workKey)) {
      note = note.substring(workKey.length, note.length).trim();
    }
  }
  return { note, workKey };
}

function createTimeSheetArray(tsData, timesheetEndOfWeek) {
  var rows = [];
  var topRow = ["", "", "", "", "", "", "", "", "", "", timesheetEndOfWeek];
  var rowIdx = 0;
  rows[rowIdx++] = topRow;
  var headerRow = ["Project", "Work", "Notes", "TotHrs", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  rows[rowIdx++] = headerRow;
  var startDataRowNum = rowIdx + 1;

  const workKeyMap = getWorkKeyMap();

  for (const endOfWeek in tsData) {
    if (timesheetEndOfWeek != endOfWeek) {
      continue;
    }
    for (const project in tsData[endOfWeek]) {
      if (project == "personal") {
        continue;
      }
      projectData = tsData[endOfWeek][project];
      for (const workType in projectData) {
        var colIdx = 0;
        var rowCells = [];
        rowCells[colIdx++] = project;
        rowCells[colIdx++] = getMapValue( workKeyMap, workType );

        var workTypeData = projectData[workType];
        var notes = "";
        for (const note in workTypeData.notes) {
          if (notes.length > 0) {
            notes = notes + "; ";
          }
          var noteMins = Math.round(workTypeData.notes[note]);
          var timeStr = noteMins + "m";
          if (noteMins > 60) {
            var noteHrs = Math.trunc(noteMins / 60);
            noteMins = noteMins - noteHrs * 60;
            timeStr = noteHrs + "h " + noteMins + "m";
          }
          notes = notes + note + "[" + timeStr + "]";
        }
        rowCells[colIdx++] = notes;
        var totalRowHoursColIdx = colIdx++;
        var totalRowHours = 0;
        for (const day in workTypeData.days) {
          var mins = workTypeData.days[day];
          mins = applyMinBlockOfTime(mins);
          var hrs = +(mins / 60).toFixed(2);
          totalRowHours = totalRowHours + hrs;
          if (hrs == 0) {
            hrs = "";
          }
          rowCells[colIdx++] = hrs;
        }
        rowCells[totalRowHoursColIdx] = totalRowHours;
        rows[rowIdx++] = rowCells;
      }
    }
  }
  var sumColumnFormula = '=sum(INDIRECT("R' + startDataRowNum + 'C"&column()&":"&"R"&(row()-1)&"C"&column(),false))';
  var totalRowCells = ["", "", "TOTAL:", sumColumnFormula, sumColumnFormula, sumColumnFormula, sumColumnFormula, sumColumnFormula, sumColumnFormula, sumColumnFormula, sumColumnFormula];
  rows[rowIdx++] = totalRowCells;
  return rows;
}

function applyMinBlockOfTime(mins) {
  var minBlockOfMins = 15;
  mins = Math.round(mins / minBlockOfMins) * 15;
  return mins;
}

function test() {
  var tsData = {};

  var project = "ITR6017 Consignments>EBS";
  var note = "dep int";
  var noteAndWorkKey = getWorkKeyFromNote(note);
  var startTime = new Date("2020-04-27T10:05:40.622Z");
  var endTime = new Date("2020-04-27T11:59:57.318Z");
  var discount = 0;
  addWorkTime(tsData, project, noteAndWorkKey.workKey, noteAndWorkKey.note, startTime, endTime, discount);

  //   project = "ITR6017 Consignments>EBS";
  //   note = "test int";
  //   var noteAndWorkKey = getWorkKeyFromNote(note);
  //   startTime = new Date("2020-04-27T11:56:40.622Z");
  //   endTime = new Date("2020-04-27T12:58:57.318Z");
  //   discount = 0;
  //   addWorkTime(tsData, project, noteAndWorkKey.workKey, noteAndWorkKey.note, startTime, endTime, discount);

  //   project = "ITR6017 Consignments>EBS";
  //   note = "test int";
  //   var noteAndWorkKey = getWorkKeyFromNote(note);
  //   startTime = new Date("2020-04-29T11:56:40.622Z");
  //   endTime = new Date("2020-04-29T14:58:57.318Z");
  //   discount = 0;
  //   addWorkTime(tsData, project, noteAndWorkKey.workKey, noteAndWorkKey.note, startTime, endTime, discount);

  //   /*
  // 5/1/2020	ITR6017 Consignments>EBS	dev process lock	2020-05-01T22:02:00.000Z	2020-05-02T01:01:00.000Z	2.9833	50.00%
  // */
  //   project = "ITR6017 Consignments>EBS";
  //   note = "dev process lock";
  //   var noteAndWorkKey = getWorkKeyFromNote(note);
  //   startTime = new Date("2020-05-01T22:02:00.000Z");
  //   endTime = new Date("2020-05-02T01:01:00.000Z");
  //   discount = 0;
  //   addWorkTime(tsData, project, noteAndWorkKey.workKey, noteAndWorkKey.note, startTime, endTime, discount);

  //   /*
  // 5/2/2020	ITR6017 Consignments>EBS	dev logging	2020-05-02T12:43:00.000Z	2020-05-02T19:36:54.670Z	6.8983	100.00%
  // */
  //   project = "ITR6017 Consignments>EBS";
  //   note = "dev logging";
  //   var noteAndWorkKey = getWorkKeyFromNote(note);
  //   startTime = new Date("2020-05-02T12:43:00.000Z");
  //   endTime = new Date("2020-05-02T19:36:54.670Z");
  //   discount = 0;
  //   addWorkTime(tsData, project, noteAndWorkKey.workKey, noteAndWorkKey.note, startTime, endTime, discount);

  /*
5/3/2020	ITR6017 Consignments>EBS	dev emails missing received sent ts	2020-05-03T12:54:05.396Z	2020-05-03T14:40:22.583Z	1.7714	100.00%
*/
  project = "ITR6017 Consignments>EBS";
  note = "dev emails missing received sent ts";
  var noteAndWorkKey = getWorkKeyFromNote(note);
  startTime = new Date("2020-05-03T12:54:05.396Z");
  endTime = new Date("2020-05-03T14:40:22.583Z");
  discount = 0;
  addWorkTime(tsData, project, noteAndWorkKey.workKey, noteAndWorkKey.note, startTime, endTime, discount);

  createTimeSheetArray(tsData, new Date("May 3, 2020"));
}

function testWeekNum() {
  // var date = new Date('1/1/2020');
  // var weekNum = getWeekNumStartOnMon(date);
  // console.log("weekNum=" + weekNum);

  // var date = new Date('1/5/2020');
  // var weekNum = getWeekNumStartOnMon(date);
  // console.log("weekNum=" + weekNum);

  // var date = new Date('1/6/2020');
  // var weekNum = getWeekNumStartOnMon(date);
  // console.log("weekNum=" + weekNum);

  // var date = new Date('1/12/2020');
  // var weekNum = getWeekNumStartOnMon(date);
  // console.log("weekNum=" + weekNum);

  // var date = new Date('1/13/2020');
  // var weekNum = getWeekNumStartOnMon(date);
  // console.log("weekNum=" + weekNum);

  // var date = new Date('4/29/2020');
  // var weekNum = getWeekNumStartOnMon(date);
  // console.log("weekNum=" + weekNum);

  // var date = new Date('5/2/2020');
  // var weekNum = getWeekNumStartOnMon(date);
  // console.log("weekNum=" + weekNum);

  var date = new Date('5/2/2020 14:04:00');
  var weekNum = getWeekNumStartOnMon(date);
  console.log("weekNum=" + weekNum);

  var date = new Date('5/3/2020 00:00:00');
  var weekNum = getWeekNumStartOnMon(date);
  console.log("weekNum=" + weekNum);

  var date = new Date('5/3/2020 14:04:00');
  var weekNum = getWeekNumStartOnMon(date);
  console.log("weekNum=" + weekNum);
}

// test();