var depts = {
  "SCI": {name: "Science", color: "rgba(200,210,252,0.8)", courses: [] },
  "MATH": {name: "Math", color: "rgba(230,205,229,0.8)", courses: [] } ,
  "DEF" : { name: "Design", color: "rgba(56,181,74,0.8)", courses:[] },
  "HUM": {name: "Humanities", color: "rgba(251,196,228,0.8)", courses: [] },
  "WL": {name: "Languages", color: "rgba(217,213,211,0.8)", courses: [] },
  "OTHER" :{name: "Other", color: "rgba(255,128,128,0.8 )", courses: [] }
};

var deptOrdered = [
  depts.MATH,
  depts.SCI,
  depts.DEF,
  depts.HUM,
  depts.WL,
  depts.OTHER
];


var otherClasses = {
  "Digital Photography I" : {division : 1}
}
$(function() {  
  

  var classData;
  var studentData;
  var standardsData;
  var syncCount = 3;

  function finishClasses(response){
    syncCount --;
    classData = JSON.parse(response.responseText);
    for (key in otherClasses) {
      console.log(key);
      classData.key = otherClasses[key];
    }

    if(syncCount <= 0) {
      finish();
    }
  }

  function finishStudent(responseData){
    syncCount --;
    studentData = responseData;
    if(syncCount <= 0) {
      finish();
    }
  }
  
  function finishStandards(response){
    syncCount --;
    result = JSON.parse(response.responseText);
    standardsData = JSON.parse(response.responseText);


    if(syncCount <= 0) {
      finish();
    }
  }
   

  function finish(){
    handleClassData(classData);
    handleStandardsData(standardsData);
    handleStudentData(studentData);
  }
  
  $.ajax({
    dataType: "json",
    url: "data/class.json",
    complete: finishClasses,
  });

  $.ajax({
    dataType: "json",
    url: "data/standards.json",
    complete: finishStandards,
  });
  finishStudent(allData);
  

});

var classInfo = {};
function handleClassData(classData){
  classInfo = classData;

}

var standardsInfo = {};

function handleStandardsData(data){
  standardsInfo = data.Standards;
  //standardsInfo["Design Process"] = {Department : "DFE"};
}

function getCourseDivision(course){
  var key = course["Course Title"];
  var myClass = classInfo[key];
  if(typeof myClass === "undefined"){
    if(key.match(/College/)){
      return 4;
    }
    if(typeof(course["Transfer"]) !== 'undefined'
      && course["Transfer"].length > 0){
      return 0;
    }

    return 1;
  }
  if(typeof(course["Transfer"]) !== 'undefined'
    && course["Transfer"].length > 0){
    return 0;
  }
  return myClass.division;

}

function handleStudentData(data){
  var standardsData = getStandardsData(data);

  var courseData = getCourseData(data);
  var projectData = getProjectData(data);
  var studentData = getStudentInfo(data);

  var coursesByYear = getCoursesByYear(courseData);
  var years = coursesByYear.keys();

  renderStudentInfo(studentData);

  renderYearSummary(courseData, projectData);
  renderDepts(depts, courseData, standardsData);
}

function getCoursesByYear(courses){
  years = {};
  for (var key in courses){
    var course = courses[key];

    var year = course["Year"];
    if(years[year] == null){
      years[year] = [];
    }
    var courseList = years[year];
    courseList.push(course);
  }
  return courseList;
}

function getCourseData(data){
  data = verifyCourseData(data["Course List"]);
  return data;

};

function getStandardsData(data){
  var data = data["Copy From"];
  var standardsData = [];
  for(var key in data){
    standardsData.push(new standardData(data[key]));
  }

  standardsData = fixDesignProcess(standardsData);

  return standardsData;
};
function getProjectData(data){
  return data["Flex Friday"];
};

function getStudentInfo(data){
  return data["Address Info"][0];

}

var termMisspellingLut = {
  "DFE" : "DEF",
  "MAT" : "MATH",

}

function checkSpellingDeptName(deptName){
  if(termMisspellingLut[deptName] != null){
    return termMisspellingLut[deptName];

  }
  return deptName;

}

function verifyCourseData(data){
  for(var key in data){
    var course = data[key];
    course.Department = checkSpellingDeptName(course.Department);
    //course.Terms = checkForChild(data, ["terms", "Term", "term"]);
  }
  return data;
}


function renderStudentInfo(data){
  var date = new Date(data["Birthdate"]);

  var m = date.getMonth() + 1;
  var y = date.getFullYear();
  var d = date.getDate();

  $("#studentName").html(data["Last Name"] + ", " + data["First Name"]);
  $("#studentLastName").html(data["Last Name"]);


  $("#studentFirst2").html(data["First Name"]);
  $("#studentLast2").html(data["Last Name"]);

  $("#studentAddress").html([data["Street Address"],data["City"],data["State"],data["Zip"]].join(" "));
  ;
  $("#studentBirthdate").html(m + "/" + d + "/" + y);
  //$("#graduationDate").html("Graduation<br/>" + 6 + "/" + 4 + "/" + 2017);
  $("#studentGpa").html(parseFloat(data["GPA"]).toPrecision(2));
  $("#p2info").html($("#p1info").html());

  if(data["Portfolio Link"] != null && data["Portfolio Link"].length > 0){
    var link = data["Portfolio Link"];
    $("#portfolio").append(        '<img src="' + QR_IMAGE_PATH + '" class="qrcode"/>');
    $("#portfolio").append("<a class='portfolioLink' href='" + link + "'>" + link + "</a>");
  }
}

function makeProjectEl(data){

   var title = data["Project Title"];
   var description = data["Project Description"];
  var projectEl = $("<div class='project'>" +
    "<div class='projectName'>" + data["Project Title"] + "</div>" +
    "<div class='projectDescription'>" + data["Project Description"] + "</div>" +
    "</div>");
  return projectEl;
}



function shouldAddCourse(course, year, term, dept){
  addCourse = false;
  if(getYearInt(course.Year) == year){

    return isInRightTerm(course, term) && isInRightDept(course, dept);
  }
}

var termLut = {
  "Fall" : 1,
  "Winter" : 2,
  "Spring" : 3,
}

function isInRightTerm(course, term){
  if(typeof term === "undefined" || term == null || term == "" ){
    return true;
  }
  for(var termName in termLut){
    var termNum = termLut[termName];

    if(course[termName] != "" && termNum == term ){
      return true;
    }
  }
}

function isInRightDept(course, dept){
  if(typeof dept === "undefined" || dept == "" || dept == null){
    return true;
  }
  if(course.Department == dept ){
    return true;
  }
  return false;
}

//year should be 1,2,3 or 4
function getClasses(classesData, year, term, dept){
  var classesOut = [];
  for(var classIndex in classesData){
    var course = classesData[classIndex];

    if( shouldAddCourse(course,year,term,dept) ){
      classesOut.push(course);
    }
  }
  return classesOut;
}

function renderYearSummary(courseData, projectData) {
  var yearsDiv = $("#years");
  for(var year = studentYear; year > 0; year--){
    var yearDiv = $("<div class='year'><div class='yearLabelWrapper'>" +
      "<div class='yearLabel'>" + getYearSpan(year) + "</div></div></div>");
    var contentDiv = $("<div class='yearContent'></div>");
    var transfer = (year < STUDENT_START_YEAR) ;
    contentDiv.append(renderYearProject(projectData,year, transfer));
    contentDiv.append(renderYearClasses(courseData,year));
    yearDiv.append(contentDiv);
    yearsDiv.append(yearDiv);
  }
}

function renderYearClasses(courseData, year){
  var yearEl = $("<div class='frontPageYear'></div>");

  var shouldRenderTerms = (year >= STUDENT_START_YEAR) ;

  if(shouldRenderTerms){
    for(var i = 0; i < 3; i++){
      var courses = getClasses(courseData, year, i + 1).sort(function(a,b){
        return a["Course Title"].localeCompare(b["Course Title"]);
      });
      var courseCount = courses.length;
      var coursesEl = makeTermEl(courses, "Term " + (i + 1));
      console.log(courseCount);
      if(courseCount > 0){
        yearEl.append(coursesEl);
      }
    }
  } else {
    var courses = getClasses(courseData, year).sort(function(a,b){
      return a["Course Title"].localeCompare(b["Course Title"]);
    });
    var rowHeight = Math.ceil(courses.length / 3);
    for(var i = 0; i < 3; i++){
      var courseSlice = courses.slice(i*rowHeight, (i + 1) * rowHeight);
      var courseCount = courseSlice.length;
      var coursesEl = makeTermEl(courseSlice, "");
      console.log(courseCount);
      if(courseCount > 0){
        yearEl.append(coursesEl);
      }
    }
  }
  return yearEl;
}

function makeTermEl(courses, title){
  var coursesEl = $("<div class='frontPageCourses'></div>");
  var courseCount = 0;
  coursesEl.append("<div class='termHead'>" + title + "</div>");

  for(var key in courses){
    courseCount++;
    var course = courses[key];
    var courseEl = $("<div class='course'>" + course["Course Title"] + "</div>");
    coursesEl.append(courseEl);
  }
  return coursesEl;
}

function renderYearProject(projectData, studentYear, transfer){
  var projectEl = $("<div class='projectBox'></div>");
  var noData = true;
  for(var key in projectData){
    var project = projectData[key];
    if(getYearInt(project.Year) == studentYear){
      noData = false;
      projectEl.append( $("<div class='projectTitle'>" + project["Project Title"] + "</div>"));
      projectEl.append( $("<div class='projectDescription'>" + project["Project Description"] + "</div>"));
    }
  }

  if(transfer){
    projectEl.addClass("transferBox");
    projectEl.append( $("<div class='projectTitle'>" + "Transfer" + "</div>"));
    projectEl.append( $("<div class='projectDescription'>" + "Transfer classes are for reference only, for any assessment please see transcript from prior school." + "</div>"));
  } else if (noData) {
      projectEl.append( $("<div class='projectTitle'>" + "Flex Friday" + "</div>"));
      projectEl.append( $("<div class='projectDescription'>" + "Student has not yet provided a Flex Friday description for this year." + "</div>"));

  }
  return projectEl;
}

function renderClassGroup(courseData){
    var coursesEl = $("<div class='courses'></div>");
    for(var key in dept.courses){
      var courseEl = makeCourseDiv(dept.courses[key]);
      coursesEl.append(courseEl);
    }
    return coursesEl;
}

var rendered = 0;
function renderDepts(depts, courseData, standardsData){
  var deptsEl = $("#deptTarget");
  for(var deptKey in depts){
    var dept = depts[deptKey];
    var deptEl = makeDeptDiv(deptKey, courseData, standardsData);
    deptsEl.append(deptEl);
  }
}


function getStandardDataByName(name, data){
  for(var key in data){
    var standard = data[key];
    if(standard.name == name){
      return standard;
    }
  }
}


function dropLowest(nums){
  nums.sort();
  nums.shift();
  return nums[1];
}

var fixed = false;
function fixDesignProcess(standardsData){
  if(fixed){
    console.log("leak");
    return;
  }
  fixed = true;
  var dp = getStandardDataByName("Define Problems", standardsData);
  var ds = getStandardDataByName("Develop Solutions", standardsData);
  var ao = getStandardDataByName("Analyze and Optimize Solutions", standardsData);
  var designProReal = getStandardDataByName("Design", standardsData);
  var levels = [];
  for(var i = 0; i < 4; i++){
    var dpLevel = dp.levels[i];
    var dsLevel = ds.levels[i];
    var aoLevel = ao.levels[i];
    var dprealLevel = designProReal.levels[i];
    var compVal = dropLowest([dpLevel, dsLevel, aoLevel]);
    console.log(dprealLevel + "DESIGN");
    var storeVal = (Math.max(dprealLevel, compVal));
    levels.push(compVal);
  }
  dp.name = "Design Process";
  ds.name = "";
  ao.name = "";
  dp.levels = levels;
  ds.levels = [0,0,0,0];
  ao.levels = [0,0,0,0];
  dp.shouldRender = true;
  return standardsData;
}

function renderStandards(standardsData, dept) {
  if(dept == "DEF"){
    dept = "DFE";
  }
  var setEl = $("<div class='standards'></div>");

  for(var key in standardsData){
    var data = standardsData[key];
    if(data.dept == dept && data.shouldRender){
      var barEl = makeStandardBar(data);
      setEl.append(barEl);
    }
  }
  return setEl;
}

var deptCount = 0;

function makeDeptDiv(dept, courseData, standardsData){
  var deptName = $("<div class='deptName'>" + depts[dept].name + "</div>");
  var deptContainer = $("<div class='deptContainer " + dept + "'></div>");
  var deptEl = $("<div class='dept'></div>");
  var bars =  renderStandards(standardsData, dept);
  deptContainer.append(deptName);
  deptContainer.append(deptEl);
  deptEl.append(bars);

  for(var i = 1; i  <= 4; i++){
    var yearHead = $("<div class='deptYearHead'>" + getYearSpan(i) + "</div>");
    var coursesEl = $("<div class='deptYear'></div>");
    var classes = getClasses(courseData, i, null, dept).sort(function(a,b){
      if(getCourseDivision(b) == getCourseDivision(a)) {
        return b["Course Title"].localeCompare(a["Course Title"]);
      }
      return getCourseDivision(b) > getCourseDivision(a);
    });
    for(var key in classes){
      var courseEl = makeCourseDiv(classes[key]);
      coursesEl.append(courseEl);
    }
    deptEl.append(coursesEl);
    if(deptCount == 0){
      coursesEl.append(yearHead);

    }
  }
  deptCount ++;
  var resizeFunc;
  var lastWidth = 0;
  var lastFontSize = 0;
  resizeFunc = function(){
    deptName.height(deptContainer.height());
    deptName.css("font-size", deptName.height() - 10);
    deptName.css("color", depts[dept].color);
  };

  window.setTimeout(resizeFunc, 10);
  deptName.css("color", depts[dept].color);
  return deptContainer;


}

function Unitize(termString){
  return termString.replace(/Term/,"Unit");
}
function makeCourseDiv(course){
  var term = Unitize(course["Terms"]);
  var termCount = getTermCount(term);
  var divClass = "div" + getCourseDivision(course);
  var courseEl = $("<div class='course " + divClass + "'>" +
    "<div class='courseName'>" + formatName(course["Course Title"]) + "</div>" +
    "<div class='courseLength'>" + term + "</div>" +
    "</div>");

  courseEl.css("height", 2+ "em");
  return courseEl;
}


function getTermCount(termText){
  return termText.substr(0, 1);
}




function makeYearRange(year){
  return year + "-" + (year + 1);
}
function standardData(rawData){
  this.name = rawData.Standard;
  var levels = [];
  console.log(this.name);
  var standardInfo = standardsInfo[this.name];
  this.levels = levels;
  if(typeof standardInfo === 'undefined' || standardInfo == null){
    this.dept = "";
    this.mean = 0;
    this.median = 0;
  } else {
    this.dept = standardInfo.Department;
    this.shouldRender = (this.dept != "DEF" && this.dept != "DFE");
    var index = 0;
    this.mean = standardInfo.Mean;
    this.median = standardInfo.Median;

    for(var i = getStartYear(); i < getStartYear() + studentYear; i++){
      var level = rawData[makeYearRange(i)];
      levels[index] = parseInt(level);
      if(levels[index] > 0){
        this.shouldRender = true; ;
      }
      index++;

    }
    if(this.name == "Design Process" || this.name == "Aesthetics & Meaning"){
      this.shouldRender = true;
    }
    if(this.name == "Design"){
      this.shouldRender = false;
    }
  }

}

standardData.prototype = {
  name: "Unnamed Standard",
  levels: [0,1,2,3],
  shortName: function(){
    return this.name.replace(/\band\b/,"&");
  }
}

function makeStandardBar(standardData){
  var maxLevel = 0;
  var standardBar = $("<div class='standardBar'></div>");
  standardBar.append("<div class='standardName'>" + standardData.shortName() + "</div>")
  var barWrapper = $("<div class='barWrapper'></div>");

  if (standardData.mean > 0 && studentYear == 4) {
    var diamond = $("<div class='diamond'>&diams;</div>");
    barWrapper.append(diamond);
    var standardMean = standardData.mean;
    var left = standardMean * 11 - 4;
    diamond.css("left", left + "px");
  }

  standardBar.append(barWrapper);
  var cellCount = 0;
  for (var year in standardData.levels){
    var standardLevel = standardData.levels[year] + 0; //hack to convert to #
    if(standardLevel > maxLevel){
      var delta = standardLevel - maxLevel;
      var yearInt = parseInt(year);
      var yearCss = "year" + yearInt;
      for(var j = 0; j < delta; j++){
        var standardCell = $("<div class='standardCell " + yearCss +  "'></div>");
        barWrapper.append(standardCell);
        cellCount++;
        if (cellCount == 3){
          standardCell.addClass("benchmark");
        }
        if(cellCount >= 6){
          standardCell.html("+");
        }
        maxLevel = standardLevel;
      }
      //standardCell.css("width", cellWidth * delta);
    }
  }
  return standardBar;
}

function getStartYear(){
  return currentYearStart - studentYear + 1;
}

function getYearInt(yearSpan){
  var startYear = currentYearStart - studentYear;
  var spanStartYear = yearSpan.substr(0, 4);
  var out = spanStartYear - startYear;
  return out;
}

function getYearSpan(yearInt){
  var startYear = currentYearStart - studentYear + yearInt;
  var endYear = startYear + 1;
  var out = startYear + "-" + endYear;
  return out;
}

function formatName(name){
  name = name.replace(/Introduction /, "Intro ");
  return name;

}
