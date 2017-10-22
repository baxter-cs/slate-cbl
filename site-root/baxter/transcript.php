<?php

use Slate\CBL\Competency;
use Slate\CBL\StudentCompetency;
use Slate\People\Student;
use Slate\Courses\Section;
use Slate\Courses\SectionParticipant;
use Slate\CBL\Tasks\StudentTask;
use Slate\CBL\Tasks\TaskSkill;
use Slate\CBL\Tasks\StudentTaskSkill;

$GLOBALS['Session']->requireAccountLevel('Staff');


$competencies = Competency::getAll();

$transcriptStudents = [];
$i = 0;
if ($_POST['submitTranscript']) {
    $studentID = $_POST['studentID'];
    $student = Student::getByID($studentID);

    $studentComps =getStudentCompetencyData($competencies);
    
    RequestHandler::respond('baxter/transcript', [
        'student' => $student,
        'competencies' =>  getStudentCompetencyData($studentCompetencies),
        'renderTranscript' => true
    ]);

} elseif ($_POST['submitProgress']) {
    $studentID = $_POST['studentID'];
    $termID = $_POST['termID'];
    $student = Student::getByID($studentID);
    $sectionParticipants = SectionParticipant::getAllByWhere([
       'PersonID' => $studentID,
    ]);

    $courseSectionInfos = [];
    foreach ($sectionParticipants as $SectionParticipant){
        $section = $SectionParticipant->Section;
        
        $studentTasks = StudentTask::getAllByWhere([
            'StudentID' => $studentID,
            'SectionID' => $SectionParticipant->Section->ID
        ]);
        $taskInfos = [];
        foreach($studentTasks as $studentTask) {
            $taskSkills = TaskSkill::getAllByWhere(['TaskID'=> $studentTask->Task->ID ]);
            $demonstration = $studentTask->Demonstration;
            $taskInfos[] = [ 
                'id' => $StudentTask->ID,
                'studentTask' => $studentTask,
                'demonstration' => $demonstration,
                'title' =>  $StudentTask->Task->Title,
                'demonstrationSkills' => $demonstration->Skills,
                'taskSkills' => $taskSkills     
            ];
            
        }
        
        $courseSectionInfos[] = [ 
            'section' => $section,  
            'taskInfos' => $taskInfos,
            'lut' => ['NE','EN','PR','GB','AD','EX']
        ];
    }


    RequestHandler::respond('baxter/transcript', [
        'student' => $student,
        'courseSectionInfos' => $courseSectionInfos,
        'renderProgress' => true

    ]);

}  else {
    $students = Student::getAllByWhere([
        'Class' => Student::class
    ]);

    foreach ($students as $student) {
        $studentLevels = [];

        $transcriptStudent = [
            'name' => $student->FullName,
            'id' => $student->ID,
            'competencies' => $studentComps
        ];

        $transcriptStudents[] = $transcriptStudent;
    }



    RequestHandler::respond('baxter/transcript', [
        'students' => $transcriptStudents
    ]);
}


function getTasksByCompetency($competency) {
    
    
}

function getStudentCompetencyData($competencies) {
    $outputCompetencyData = [];
    foreach ($competencies as $Competency) {
        $studentCompetencies = StudentCompetency::getAllByWhere([
            'StudentID' => $student->ID,
            'CompetencyID' => $Competency->ID
        ]);
        foreach ($studentCompetencies as $StudentCompetency) {
          $outputCompetencies[] = [
              'code' => $Competency->Code,
              'currentLevel' => $StudentCompetency->Level,
              'created' => $StudentCompetency->Created
          ];
        }
    }
    return $ouputCompetencyData;
}
