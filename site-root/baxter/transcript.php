<?php

use Slate\CBL\Competency;
use Slate\People\Student;


$GLOBALS['Session']->requireAccountLevel('Staff');


$students = Student::getAllByWhere([
    'Class' => Student::class
]);
$competencies = Competency::getAll();


$transcriptStudents = [];
$i = 0;
foreach ($students as $student) {
    $studentComps = [];
    foreach ($competencies as $Competency) {
        $currentLevel = $Competency->getCurrentLevelForStudent($student);
        $studentComps[] = [
            'code' => $Competency->Code,
            'currentLevel' => $currentLevel,
            'nextLevel' => $currentLevel + 1            
        ];        
    }
    
    $transcriptStudent = [
        'name' => $student->FullName,
        'id' => $student->ID,
        'competencies' => $studentComps
    ];
    
    $transcriptStudents[] = $transcriptStudent;
}


RequestHandler::respond('transcript', [
    'students' => $transcriptStudents
]);
