<!DOCTYPE html>
<html>
  <head>
    {cssmin "reports/legacy.css" embed=true}
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://unpkg.com/vue"></script>
    </head>
    <body>
      <div class="infoHeader" id="p1info">
        <div class="logo"><img src="images/logo.png"/></div>
        <div class="infoFlex">
          <div class="infoLine"><div class="infoLabel">Name</div>
            <div id="studentName" class="info" v-html="student.name">{$student->name}</div>
          </div>
          <div class="infoLine"><div class="infoLabel">Address</div>
            <div id="studentAddress" class="info"></div>
          </div>
          <div class="infoLine"><div class="infoLabel">Birthdate</div><div id="studentBirthdate" class="info"></div></div>
          <div class="infoLine"><div class="infoLabel">Graduation</div><div id="graduationDate" class="info"></div></div>
          <div class="infoLine"><div class="infoLabel">GPA</div><div id="studentGpa" class="info"></div></div>
        </div>
      </div>

    
    </div>
    <div id="report-panel">
        <div v-for="contentArea in contentAreas">
            <div v-html="contentArea.title"></div>
            <div v-for="competency in contentArea.competencies">
                <div v-html="competency.title"></div>
            </div>

        </div>
    </div>


    <script src="scripts/reportcard.js"></script>
    <script>
        var currentYearStart = 2017;
        var studentYear = 4;
        var STUDENT_START_YEAR = 1;


        var student = {json_encode($student)};
        var contentAreas = {json_encode($contentAreas)};
        var reportVue = makeStudentReportVue(student, contentAreas);
    </script>

  </body>
</html>
