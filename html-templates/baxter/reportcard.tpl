<!DOCTYPE html>
<html>
    <head>
        {cssmin "reports/legacy.css" embed=true}
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="https://unpkg.com/vue"></script>
        <style>

        .main-grid{
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            grid-template-rows: repeat(5, 1fr);
        }

        .content-area{
            border: 1px solid black;
            border-radius: 2em;
            padding: 1em;
            margin: 0.5em;
        }

        .content-area-title{
            margin: 0.5em;
            font-size: 20pt;
        }

        .competencies{
            display: flex;
        }
</style>
    
    </head>
    <body>
      <div class="infoHeader" id="p1info">
        <div class="logo"><img src="images/logo.png"/></div>
        <div class="infoFlex">
          <div class="infoLine"><div class="infoLabel">Name</div>
            <div id="studentName" class="info" v-html="student.firstName"></div>
          </div>
          <div class="infoLine"><div class="infoLabel">Address</div>
            <div id="studentAddress" class="info"></div>
          </div>
          <div class="infoLine"><div class="infoLabel">Birthdate</div><div id="studentBirthdate" class="info"></div></div>
          <div class="infoLine"><div class="infoLabel">Graduation</div><div id="graduationDate" class="info"></div></div>
        </div>
      </div>

    
    </div>
    <div id="report-panel" class="main-grid">
        <div class="content-area" v-for="contentArea in contentAreas">
            <div class="content-area-title" v-html="contentArea.title"></div>
            <div class="competencies">
                <div v-for="competency in contentArea.competencies">
                    <div v-html="competency.title"></div>
                    <div v-for="scompetency in competency.studentCompetencies">
                        <div v-for="lev in scompetency.levels">
                            <div v-html="standardLevelString(lev.highestLevel)"></div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>


    <script src="scripts/reportcard.js"></script>
    <script>
        var currentYearStart = 2017;
        var studentYear = 4;
        var STUDENT_START_YEAR = 1;
        {json_encode($completion)};
        var student = {json_encode($student)};
        var contentAreas = {json_encode($contentAreas)};
        var reportVue = makeStudentReportVue(student, contentAreas);
    </script>

  </body>
</html>
