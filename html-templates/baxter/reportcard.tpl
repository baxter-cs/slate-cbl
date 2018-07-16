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
        }

        .content-area{
            justify-content: space-between;
            padding: 1em;
            margin: 0.5em;
        }

        .content-area-title{
            margin: 0.2em;
            font-size: 24pt;
            text-decoration: underline;
        }

        .competencies{
            display: grid;
            flex-direction: column;
        }
        .competency-title{
            display: flex;
            justify-content: space-around;
            align-items: center;
            text-align: center;
            background-color: #DDD;
            font-size: 10pt;
            min-width: 215px;

        }

        .competency, .competency-header{
            margin: 2px;
            padding: 2px;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            flex: 1;
            background-color: #CCC;

        }

        .competency-header .level{
            border: 1px solid white;
            text-transform: uppercase;
            background-color: #eee;
        }       


        .competency-header .indicator{
            min-height: auto;
            min-width: auto;
        }
        .level{
            flex: 1;
            display: flex;
            flex-wrap: wrap;
            border: 2px dotted rgba(0,0,0,0.2);
            margin: 1px;
            width: 1 fr;
            max-height: 60px;
            flex-direction: column;
            
        }

        .level-title{
            position: absolute;
            top: 5px;
            left: 5px;
            font-size:10;
            
            background-color: #FFF;
        }

        .indicator{
            background-color: #eee;
            margin: 2px;
            font-size: 6pt;
            border-radius: 5%;
            display: flex;
            min-width: 2em;
            min-height: 2em;
            justify-content: space-around;
            align-items: center;
            text-align: center;
            font-weight: bold;
        }

        .indicator:hover{
            transform: scaleX(2) scaleY(2);
            box-shadow: 2px 2px 4px #333;
            transition: all 0.2s;
        }

        .level-boxes {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            width: 2fr;
        }

        .level-box{
            flex: 1;
            color: white;
        }
        .level-box > .level-text{
            padding: 0.2em;
            margin: 0.1em;
            display: flex;
            justify-content: center;
            
        }

        .level-text.disabled{
            font-variant: italics;
            color: #EAEAEA;
        }
        .level-1{
            background-color: magenta;
        }

        .level-2{
            background-color: orange;
        }
        .level-3{
            background-color: green;
        }
        .level-4{
            background-color: blue;
        }
        .level-5{
            background-color: purple;
        }


        .year15, .year16, .year17{

        }
        .year15{
            color: red;

        }
        .year16{
            color: green;
        }
        .year17{
            color: blue;
        }
        .year18{

        }        


</style>
    
    </head>
    <body>

    
    <div id="report-panel">
        <div id="studentName" class="info" v-html="student.lastName + ', ' + student.firstName"></div>
        <div class="main-grid">
            <div class="content-area" v-for="contentArea in contentAreas">
                <div class="content-area-title" v-html="contentArea.title"></div>
                <div class="competencies">

                    <div class="competency" v-for="competency in contentArea.competencies">
                        <div class="competency-title" v-html="competency.title"></div>
                        <div class="level-boxes">
                            <div class="level-box" v-for="level in contentLevels">
                                <div v-if="level.number < competency.level" :class="'level-' + level.number" class="level-text" >
                                    <div v-html="level.shortName"></div>
                                </div>
                                <div v-else class="level-text disabled">
                                    <div v-html="level.shortName"></div>
                                </div>
                            </div>
                        </div>
                        <div class="indicator-box">
                            <div v-for="skill in competency.skills">
                                <div v-html="skill.demonstratedLevel"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div v-for = "section in sections">
                <div v-html="section.title"></div>
                <div v-html="section.teacher"></div>
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
        var sections = {json_encode($sections)};
        var contentAreas = {json_encode($contentAreas)};
        var reportVue = makeStudentReportVue(student, sections, contentAreas);
    </script>

  </body>
</html>
