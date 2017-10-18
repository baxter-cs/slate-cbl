{extends designs/site.tpl}

{block content}
    <h3>Generate Transcript</h3>
    <ul>
    {foreach item=Student from=$students}
        <li>
            {$Student.name}  {$Student.id} {if $pretend}is eligible to graduate{else}has been graduated{/if} in the following competencies:
            <ul>
                {foreach item=competency from=$Student.competencies}
                    <li>{$competency.currentLevel} &rarr; {$competency.nextLevel} in {$competency.code}</li>
                {/foreach}
            </ul>
        </li>
    {/foreach}
    </ul>
{/block}
