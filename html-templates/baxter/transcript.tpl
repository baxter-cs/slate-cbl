{extends designs/site.tpl}

{block content}
    {assign array ('NE','EN','PR','GB','AD','EX') lookUp}
    {if $renderTranscript}
        <h2>{$student->FullName|escape}</h2>
        {foreach item=Competency from=$competencies}
            <div>
                <span>{$Competency.code}</span>
                <span>{$Competency.currentLevel}</span>
            </div>

        {/foreach}

    {elseif $renderProgress}
        <h2>{$student->FullName|escape}</h2>
        {foreach item=sectionInfo from=$courseSectionInfos}
            <div>
                <h3>{$sectionInfo.section->Title}</h3>
                <div style="display: flex;">
                {foreach item=taskInfo from=$sectionInfo.taskInfos}
                    <div style= "flex: 1;">
                        <h4>{$taskInfo.title}</h4>
                            <div style="flex: 1;">
                            {foreach item=demoSkill from=$taskInfo.demonstrationSkills}
                                <div style="display: flex">
                                <div style="flex: 10;">{$demoSkill->Skill->Competency->ContentArea->Title} > 
                                {$demoSkill->Skill->Competency->Descriptor} > 
                                 {$demoSkill->Skill->Descriptor}</div>
                                <div  style="flex: 1;">{$lookUp[$demoSkill->DemonstratedLevel]}</div>
                                </div>
                            {/foreach}
                        </div>
                    </div>
                {/foreach}

            
            </div></div>
        {/foreach}
        

    {else}
        <h3>Generate Transcript</h3>
        <form method="POST">
            {capture assign=term}
                <select class="field-control inline medium" name="term">
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
                            {foreach item=Student from=Emergence\People\Person::getAll(array(order=array(ID=DESC)))}
                                <option value="{$Student->ID|escape}">{$Student->FullName|escape}</option>
                            {/foreach}
                        </optgroup>
                </select>
            {/capture}
            {labeledField html=$studentsSelect type=select label=student class=auto-width}
            <input type="submit" name="submitTranscript" value="Generate Transcript">
            <input type="submit" name="submitProgress" value="Generate Progress Report">
            </form>
    {/if}

{/block}
