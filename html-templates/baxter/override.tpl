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
        <h3>Override Standard</h3>
        <form method="POST">
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

            {capture assign=indicatorSelect}
                <select class="field-control inline medium" name="studentID">
                    <option value="">&ndash;select&ndash;</option>
                        <optgroup label="My Indicators">
                            {foreach item=Skill from=Slate\CBL\Skill::getAll(array(order=array(Code=ASC)))}
                                <option value="{$Skill->ID|escape}">{$Skill->Code|escape} : {$Skill->Descriptor|escape}</option>
                            {/foreach}
                        </optgroup>
                </select>
            {/capture}
            {labeledField html=$indicatorSelect type=select label=indicator class=auto-width}

            {capture assign=newLevelSelect}
                <select class="field-control inline medium" name="level">
                    <option value="1">Entering</option>
                    <option value="2">Progressing</option>
                    <option value="3">Graduation Benchmark</option>
                    <option value="4">Advancing</option>
                    <option value="5">Excelling</option>
                    <option value="6">BA</option>
                </select>
            {/capture}
            {labeledField html=$newLevelSelect type=select label=Level class=auto-width}
            <br/>
            <input type="submit" name="submitProgress" value="Generate Progress Report">

</form>
    {/if}

{/block}
</body>
</html>
