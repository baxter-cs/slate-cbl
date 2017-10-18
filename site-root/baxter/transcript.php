<?php

use Slate\CBL\Competency;
use Slate\CBL\StudentCompetency;
use Slate\People\Student;
use Slate\Courses\Section;
use Slate\Courses\SectionParticipant;


$GLOBALS['Session']->requireAccountLevel('Staff');


$competencies = Competency::getAll();

$transcriptStudents = [];
$i = 0;
if ($_POST['submitTranscript']) {
    $studentID = $_POST['studentID'];
    $student = Student::getByID($studentID);

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
        'student' => $student,
        'competencies' => $studentComps,
        'renderTranscript' => true
    ]);

} elseif ($_POST['submitProgress']) {
    $studentID = $_POST['studentID'];
    $termID = $_POST['termID'];
    $student = Student::getByID($studentID);
    $sectionParticipants = SectionParticipant::getAllByWhere([
       'PersonID' => $studentID,
    ]);

    $courseSections = [];

    foreach ($sectionParticipants as $SectionParticipant){
        $section = $SectionParticipant->Section;
        #if($section->TermID == $termID) {
        $courseSections[] = $section;
        #}
    }


    RequestHandler::respond('baxter/transcript', [
        'student' => $student,
        'courseSections' => $courseSections,
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
