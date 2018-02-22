<!DOCTYPE html>
{load_templates subtemplates/forms.tpl}

<html lang="en">


<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> {* disable IE compatibility mode, use Chrome Frame if available *}
    {block "meta"}{/block}
    {cssmin "reports/print.css" embed=true}
    {cssmin "reports/transcript.css" embed=true}

    <title>{block "title"}{Site::getConfig(label)}{/block}</title>

</head>
<body>

{block body}
    {assign array ('NE','EN','PR','GB','AD','EX') lookUp}
    {if $renderTranscript}
        <div class="transcript">
            <h2>{$student->FullName|escape}</h2>
            {foreach item=Competency from=$competencies}
                <div>
                    <span>{$Competency.code}</span>
                    <span>{$Competency.currentLevel}</span>
                </div>

            {/foreach}
        </div>

    {elseif $renderProgress}
        <div class="progress-report">
        <h2>{$student->FullName|escape}</h2>
        {foreach item=sectionInfo from=$courseSectionInfos}
            <div class="section">
                <h3>{$sectionInfo.section->Title}</h3>
                <h4>Instructor: {$sectionInfo.section->Teachers[0]->FullName}</h4>
                <div class="assignment-wrapper">
                    {foreach item=taskInfo from=$sectionInfo.taskInfos}
                        <div class="assignment">
                            <div class="assignment-info">
                                <div class="title">{$taskInfo.studentTask->Task->Title}</div>
                                <div class="due">DUE: {date_format $taskInfo.studentTask->DueDate}</div>
                                <div class="status">STATUS: {$taskInfo.studentTask->TaskStatus}</div>
                                <div class="instructions">INSTRUCTIONS: {$taskInfo.studentTask->Task->Instructions}</div>
                            </div>
                            <div class="indicators">
                                <div class="header">Indicators</div>
                                {foreach item=demoSkill from=$taskInfo.demonstrationSkills}
                                    <div class="indicator">
                                    <div class="description">{$demoSkill->Skill->Competency->Descriptor} >
                                     {$demoSkill->Skill->Descriptor}</div>
                                    <div  class="rating">{$lookUp[$demoSkill->DemonstratedLevel]}</div>
                                    </div>
                                {/foreach}
                            </div>
                            <div class="comments">
                                <div class="header">Comments</div>
                                {foreach item=comment from=$taskInfo.studentTask->Comments}
                                    <div class="comment">{date_format $comment->Created}: {$comment->Message}</div>
                                {/foreach}
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>
        {/foreach}


    {else}
        <h3>Generate Transcript</h3>
        <form method="POST">
            {capture assign=term}
                <select class="field-control inline medium" name="termID">
                    {foreach item=Term from=Slate\Term::getAll(array(order=array(ID=DESC)))}
                        <option value="{$Term->ID|escape}">{$Term->Title|escape}</option>
                    {/foreach}
                </select>
            {/capture}
            {labeledField html=$term type=select label=Term class=auto-width}


            {capture assign=studentsSelect}
                <select class="field-control inline medium" name="studentID">
                    <option value="">&ndash;select&ndash;</option>
                        <optgroup label="My Sections">
                            {foreach item=Student from=Emergence\People\Person::getAll(array(order=array(LastName=ASC)))}
                                <option value="{$Student->ID|escape}">{$Student->LastName|escape}, {$Student->FirstName|escape}</option>
                            {/foreach}
                        </optgroup>
                </select>
            {/capture}
            {labeledField html=$studentsSelect type=select label=student class=auto-width}

            <br/>
            <input type="submit" name="submitProgress" value="Generate Progress Report">
            <input type="submit" name="submitReportCard" value="Generate Report Card">
            <hr/>
            <div>
                <h2>Transcripts</h2>
                <div>
                    <h3>Paste Transcript JSON Here</h3>
                    <textarea name="studentData" value=""></textarea>
                </div>
                <div>
                    <h3>Started at Baxter</h3>
                    <select class="field-control inline medium" name="startYear">
                        <option selected value=1>9th</option>
                        <option value=2>10th</option>
                        <option value=3>11th</option>
                        <option value=4>12th</option>
                    </select>
                    <h3>Current Grade</h3>
                    <select class="field-control inline medium" name="studentYear">
                        <option selected value=4>12th</option>
                        <option value=3>11th</option>
                        <option value=2>10th</option>
                        <option value=1>9th</option>
                    </select>

                </div>  
                <div>Reference Academic Year (beginning year only): <input name="currentYear" value="2017"></div>
                <input type="submit" name="submitTranscript" value="Generate Transcript">
            </div>
            <div>

</form>
    {/if}

{/block}
</body>
</html>
