<!DOCTYPE html>
<html>
  <head>
    {cssmin "reports/legacy.css" embed=true}
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>
        var currentYearStart = {$currentYear};
        var studentYear = {$studentYear};
        var STUDENT_START_YEAR = {$startYear};

        var allData = {$data};
    </script>
    <script src="scripts/app.js"></script>
    </head>
    <body>
    <div class="page page1">
      
      <div class="infoHeader" id="p1info">
        <div class="logo"><img src="images/logo.png"/></div>
        <div class="infoFlex">
          <div class="infoLine"><div class="infoLabel">Name</div>
            <div id="studentName" class="info"></div>
          </div>
          <div class="infoLine"><div class="infoLabel">Address</div>
            <div id="studentAddress" class="info"></div>
          </div>
          <div class="infoLine"><div class="infoLabel">Birthdate</div><div id="studentBirthdate" class="info"></div></div>
          <div class="infoLine"><div class="infoLabel">Graduation</div><div id="graduationDate" class="info"></div></div>
          <div class="infoLine"><div class="infoLabel">GPA</div><div id="studentGpa" class="info"></div></div>
        </div>
        <div class="portfolio" id="portfolio">
 
        </div>
      </div>

      <div class="flexBody">
        <div id="years"></table></div>
      </div>
    </div>

    <div class="page page2">
    <div class="infoHeader" id="p2info"></div>
      <div class="flex">
        <div class="deptWrapper" id="deptTarget">
          <div class="deptHeader" id="deptHeader">
            <div class="deptScale standardBar">
              <div class="standardName"> </div>
              <div class="barWrapper">
                <div class="keyCell"></div>
                <div class="keyCell"></div>
                <div class="keyCell"></div>
                <div class="keyCell"></div>
                <div class="keyCell"></div>
              </div>
            </div>
          </div>
        </div>
        <div class="legend">
          <div class="classLegend">
            <img src="images/legend.png"/>
          </div>
          <div class="courseLegend">
            <div class="deptYear">
            <div class="div1">Toward Graduation Level</div>
            <div class="div2">Graduation Level Target</div>
            <div class="div3">Above Graduation Level</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>