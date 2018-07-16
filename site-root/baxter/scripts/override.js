var lut = ["NE", "EN", "PR", "GB", "AD", "EX", "BA"];

function makeVue(student, sections, contentAreas){
    var displayContentAreas = [];
    for (var caKey in contentAreas){
        contentArea = contentAreas[caKey];
        for( var compKey in contentArea.competencies){
            var competency = contentArea.competencies[compKey];
            var levels = [[],[],[],[]];
            competency.levels = levels;
            console.log(competency);
            for(var skillKey in competency.skills){
                skill = competency.skills[skillKey];
                console.log(skill);
                var stemIndex = 3 - yearsAgo(new Date(skill.demonstrated));
                levels[stemIndex].push(skill);
            }
        }
    };


    return new Vue({
        el: "#override-panel",
        data: {
            student: student,
            sections: sections,
            contentAreas: contentAreas,
            contentLevels: [
                { name: "Entering", shortName: "EN", number: 1 },
                { name: "Progressing", shortName: "PR", number: 2 },
                { name: "Graduation Benchmark", shortName: "GB", number: 3 },
                { name: "Advancing", shortName: "AD", number: 4 },
                { name: "Excelling", shortName: "EX", number: 5 },
            ]
        },
        methods: {
            
        }
    });
}
