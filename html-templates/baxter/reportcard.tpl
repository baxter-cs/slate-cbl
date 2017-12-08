{extends designs/site.tpl}

{block content}

    {if $renderReportCard}
        <h2>{$student->FullName|escape}</h2>
        {foreach item=Competency from=$competencies}
            <div>
                <span>{$Competency.code}</span>
                <span>{$Competency.currentLevel}</span>
            </div>

        {/foreach}
        <h2>{$student->FullName|escape}</h2>
        {foreach item=Section from=$courseSections}
                <span>{$Section->Title}</span>
        {/foreach}
    {else}
        <script src="https://unpkg.com/vue"></script>
        <script>
          var students = {json_encode($students)};
        </script>
        <h3>Generate Transcript</h3>
        <form method="POST" id="report-panel">
            {capture assign=term}
                <select class="field-control inline medium" name="term">
                    {foreach item=Term from=Slate\Term::getAll(array(order=array(ID=DESC)))}
                        <option value="{$Term->ID|escape}">{$Term->Title|escape}</option>
                    {/foreach}
                </select>
            {/capture}
            {labeledField html=$term type=select label=Term class=auto-width}


                <select class="field-control inline medium" name="studentID">
                    <option value="">&ndash;select&ndash;</option>
                    <optgroup label="My Sections">
                            <option v-for="student in students" :value="student.id">{'{{ student.name }}'}</option>
                    </optgroup>
                </select>

            <input type="submit" name="submitTranscript" value="Generate Transcript">
            <input type="submit" name="submitProgress" value="Generate Progress Report">
            </form>
            <script>

            {'var studentList = new Vue({
              el: "#report-panel",
              data: {
                students: students,
              },
              methods: {

              },
            });'}
            </script>
    {/if}

{/block}
