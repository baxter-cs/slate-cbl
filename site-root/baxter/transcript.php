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
use Emergence\People\GuardianRelationship;

$GLOBALS['Session']->requireAccountLevel('Staff');


$transcriptStudents = [];
$i = 0;

if ($_POST['submitTranscript']) {
    $GLOBALS['Session']->requireAccountLevel('Staff');
    $studentID = $_POST['studentID'];
    $studentData = $_POST['studentData'];
    $student = Student::getByID($studentID);

    RequestHandler::respond('baxter/legacy', [
        'student' => $student,
        'data' =>$studentData,
        'studentYear' => $_POST['studentYear'],
        'startYear' => $_POST['startYear'],
        'currentYear' => $_POST['currentYear'],
        'renderTranscript' => true
    ]);
} elseif ($_POST['submitReportCard']) {

    RenderReportCard($_POST['studentID']);    
} elseif ($_GET['studentID']) {

    RenderReportCard($_GET['studentID']);
    
} elseif ($_POST['submitProgress']) {
    $GLOBALS['Session']->requireAccountLevel('Staff');

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
    $GLOBALS['Session']->requireAccountLevel('Staff');

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


function RenderReportCard($studentID) {

    $Student = Student::getByID($studentID);
    $userIsStaff = $GLOBALS['Session']->hasAccountLevel('Staff');
    $GuardianRelationship = \Emergence\People\GuardianRelationship::getByWhere([
        'PersonID' => $Student->ID,
        'RelatedPersonID' => $GLOBALS['Session']->PersonID
    ]);


    if (
        !$GLOBALS['Session']->hasAccountLevel('Staff') &&
        $Student->ID != $GLOBALS['Session']->PersonID &&
        !$GuardianRelationship = GuardianRelationship::getByWhere([
            'Class' => GuardianRelationship::class,
            'PersonID' => $Student->ID,
            'RelatedPersonID' => $GLOBALS['Session']->PersonID,
        ])
    ) {
        return RequestHandler::throwUnauthorizedError('Only staff and guardians may browse others\' records');
    }

    
    
    $lut =  array('NE','EN','PR','GB','AD','EX', 'BA');
    $contentAreas = [];
    foreach(ContentArea::getAll() as $ContentArea) {
        
        $competencies = [];
        foreach ($ContentArea->Competencies as $Competency) {
            $studentCompetencies = StudentCompetency::getAllByWhere([
                'StudentID' => $Student->ID,
                'CompetencyID' => $Competency->ID
            ]);
            $skills = [];
            $maxLevel = 0;
            foreach ($studentCompetencies as $StudentCompetency) {
                if ($maxLevel < $StudentCompetency->Level){
                    $maxLevel = $StudentCompetency->Level;
                }
                $demos = $StudentCompetency->getDemonstrationData();
                $targetLevel = 0;
                $count = 0;
                foreach($demos as $demoSkills){
                    $skill = Skill::GetByID($demoSkill["SkillID"]);
                    //echo(json_encode($demoSkills));
                    foreach($demoSkills as $demoSkill) {
                        $targetLevel = $demoSkill["TargetLevel"];
                        $earnedDate = $demoSkill["DemonstrationDate"];
                        $demoLevel = $demoSkill["DemonstratedLevel"];
                        $count++;
                        $skills[] = [
                            'targetLevel' => $demoSkill["TargetLevel"],
                            'demonstratedLevel' => $demoSkill["DemonstratedLevel"],
                            'ID' => $demoSkill["SkillID"],
                            'demonstrationCount' => $count,
                            'demonstrated' => $earnedDate
                        ];
                    }

                }
                /*
                if($StudentCompetency->Level < 7) {
                    $levels[$StudentCompetency->Level - 1] = [
                        'level' => $StudentCompetency->Level,
                        'renderLevel' => $lut[$StudentCompetency->Level],
                        'created' => $StudentCompetency->Created,
                        'skills' => $skills,
                      ];
                }*/
            }
            
            $competencies[] = [
                'title' => $Competency->Descriptor,    
                'code' => $Competency->Code,
                'level' => $maxLevel,
                'renderLevel' => $lut[$maxLevel],
                'skills' => $skills
            ];
        }
        
        $contentAreas[] = [
            'title' => $ContentArea->Title,
            'competencies' => $competencies
        ];        
    }
    
    
    $sectionParticipants = SectionParticipant::getAllByWhere([
       'PersonID' => $studentID,
    ]);

    $sectionInfos = [];
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
                    'demonstrationSkills' => $demonstration->Skills,
                ];

            }

            $sectionInfos[] = [
                'title' => $section->Title,
                'teacher' => $section->Teacher->FullName,
            ];
        }

    }
    
    
    

    $student = [
        'lastName' => $Student->LastName,
        'firstName' => $Student->FirstName,
        'id' => $Student->ID,        
    ];
    RequestHandler::respond('baxter/reportcard', [
      'sections' => $sectionInfos,
      'student' => $student,
      'contentAreas' => $contentAreas,
    ]);

}
