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

if ($_POST['submitReport']) {
  $studentID = $_POST['studentID'];
  $termID = $_POST['termID'];
  $student = Student::getByID($studentID);
  $studentComps = [];
  $courseSections = [];

  /* get course sections */
  $sectionParticipants = SectionParticipant::getAllByWhere([
     'PersonID' => $studentID,
  ]);

  foreach ($sectionParticipants as $SectionParticipant){
      $section = $SectionParticipant->Section;
      #if($section->TermID == $termID) {
      $courseSections[] = $section;
      #}
  }

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
  RequestHandler::respond('baxter/reportcard', [
      'student' => $student,
      'competencies' => $studentComps,
      'renderTranscript' => true
  ]);


} elseif ($_POST['submitProgress']) {





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



  RequestHandler::respond('baxter/reportcard', [
      'students' => $transcriptStudents
  ]);
}
