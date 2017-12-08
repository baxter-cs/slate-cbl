<?php

use Slate\CBL\Competency;
use Slate\CBL\Skill;
use Slate\CBL\StudentCompetency;
use Slate\CBL\ContentArea;
use Slate\People\Student;
use Slate\Courses\Section;
use Slate\Courses\SectionParticipant;
use Slate\CBL\Tasks\StudentTask;
use Slate\CBL\Tasks\TaskSkill;
use Slate\CBL\Tasks\StudentTaskSkill;

$GLOBALS['Session']->requireAccountLevel('Staff');


$transcriptStudents = [];
$i = 0;

if ($_POST['submitTranscript']) {
    $studentID = $_POST['studentID'];
    $studentData = $_POST['studentData'];
    $student = Student::getByID($studentID);

    RequestHandler::respond('baxter/legacy', [
        'student' => $student,
        'data' =>$studentData,
        'startYear' => $_POST['startYear'],
        'renderTranscript' => true
    ]);
} elseif ($_POST['submitReportCard']) {

    RenderReportCard();
    
} elseif ($_POST['submitProgress']) {
    $competencies = Competency::getAll();
    $studentID = $_POST['studentID'];
    $termID = $_POST['termID'];
    $student = Student::getByID($studentID);
    $sectionParticipants = SectionParticipant::getAllByWhere([
       'PersonID' => $studentID,
    ]);

    $courseSectionInfos = [];
    foreach ($sectionParticipants as $SectionParticipant){
        $section = $SectionParticipant->Section;
        if($termID == $section->Term->ID) {
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
                'lut' => $lut
            ];
        }

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


function getTasksByCompetency() {

}


function RenderReportCard() {
    $lut =  array('NE','EN','PR','GB','AD','EX', 'BA');
    
    $studentID = $_POST['studentID'];
    $studentData = $_POST['studentData'];
    $Student = Student::getByID($studentID);
    $contentAreas = [];
    foreach(ContentArea::getAll() as $ContentArea) {
        
        $competencies = [];
        foreach ($ContentArea->Competencies as $Competency) {
            $studentCompetencies = StudentCompetency::getAllByWhere([
                'StudentID' => $Student->ID,
                'CompetencyID' => $Competency->ID
            ]);
            
            $levels = [[],[],[],[],[],[]];
            $maxLevel = 0;
            foreach ($studentCompetencies as $StudentCompetency) {
                if ($maxLevel < $StudentCompetency->Level){
                    $maxLevel = $StudentCompetency->Level;
                }
                $demos = $StudentCompetency->getDemonstrationData();
                $skillLevels = [];
                $targetLevel = 0;
                $count = 0;
                foreach($demos as $demoSkills){
                    $lastDemoDate = 0;
                    $highDemoLevel = 0;
                    $skillName = "";
                    foreach($demoSkills as $demoSkill) {
                        //echo(json_encode($demoSkill));
                        $targetLevel = $demoSkill["TargetLevel"];
                        $earnedDate = $demoSkill["DemonstrationDate"];
                        $demoLevel = $demoSkill["DemonstratedLevel"];
                        if($demoLevel > $highDemoLevel){
                            $highDemoLevel = $demoLevel;
                        }
                        if ($earnedDate > $lastDemoDate){
                            $lastDemoDate = $earnedDate;                          
                        }
                        $count++;

                    }
                    $skillLevels[] = [
                        'targetLevel' => $demoSkill["TargetLevel"],
                        'highestLevel' => $demoSkill["DemonstratedLevel"],
                        'demonstrationCount' => $count,
                        'demonstrated' => $earnedDate
                    ];
                }
                if($StudentCompetency->Level < 7) {
                    $levels[$StudentCompetency->Level - 1] = [
                        'level' => $StudentCompetency->Level,
                        'renderLevel' => $lut[$StudentCompetency->Level],
                        'created' => $StudentCompetency->Created,
                        'skillLevels' => $skillLevels,
                      ];
                }
            }
            
            $competencies[] = [
                'title' => $Competency->Descriptor,    
                'code' => $Competency->Code,
                'level' => $maxLevel,
                'renderLevel' => $lut[$maxLevel],
                
                'levels' => $levels
            ];
        }
        
        $contentAreas[] = [
            'title' => $ContentArea->Title,
            'competencies' => $competencies
        ];        
    }

    $student = [
        'lastName' => $Student->LastName,
        'firstName' => $Student->FirstName,
        'id' => $Student->ID,        
    ];
    RequestHandler::respond('baxter/reportcard', [
      'student' => $student,
      'contentAreas' => $contentAreas,
    ]);

}
