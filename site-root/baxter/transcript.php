Emergence

File

Edit

View

Help

grep all living files...

Search
emergence
Files
Name
_parent (v2.slate.is)
api-docs
content-blocks
dwoo-plugins
event-handlers
html-templates
app
baxter
transcript.tpl
cbl
exports
enroll.tpl
graduate.tpl
teacher-dashboard.tpl
js-library
php-classes
Slate
php-config
php-migrations
sencha-build
sencha-workspace
site-root
baxter
transcript.php
cbl
dashboards
exports
competencies.php
content-areas.php
demonstration-skills.php
demonstrations.php
enroll.php
graduate.php
import-maps.php
skills.php
student-dashboard.php
student-tasks.php
tasks.php
teacher-dashboard.php
todos.php
site-tasks


Activity

transcript.tpl

transcript.php

demonstrations.php

enroll.php

graduate.php

graduate.tpl
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
    $studentID = $_POST['studentID'];
    $student = Student::getAllByWhere([ 'ID' => $studentID ])[0];
    $studentComps = [];
    foreach ($competencies as $Competency) {
        $studentCompetencies = StudentCompetency::getAllByWhere([
            'StudentID' => $student->ID,
            'CompetencyID' => $Competency->ID
        ]);
        foreach ($studentCompetencies as $StudentCompetency) {
          $studentComps[] = [
              'code' => $Competency->Code,
              'currentLevel' => $StudentCompetency->Level,
              'created' => $StudentCompetency->Created
          ];
        }
    }


    RequestHandler::respond('baxter/transcript', [
        'fish' => $studentID,
        'student' => $student,
        'competencies' => $studentComps
    ]);


} else {
    $students = Student::getAllByWhere([
        'Class' => Student::class
    ]);
    foreach ($students as $student) {
        $studentLevels = [];
