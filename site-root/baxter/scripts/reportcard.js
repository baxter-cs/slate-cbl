var lut = ["NE", "EN", "PR", "GB", "AD", "EX", "BA"];

function yearStem(date){
    var stem = date.getFullYear() % 100;
    if (date.getMonth() > 7){
        return stem + 1;
    } else {
        return stem;
    }
}

function yearsAgo(date){
    return yearStem(new Date()) - yearStem(date);
}

function makeStudentReportVue(student, sections, contentAreas){
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
        el: "#report-panel",
        data: {
            student: student,
            sections: sections,
            contentAreas: contentAreas,
            headerLevels: [
                'Year 1',
                'Year 2',
                'Year 3',
                'Year 4'
              //"Entering",  
              //"Progressing",  
              //"Grad. Benchmark",  
              //"Advancing",  
              //"Excelling",
              //"Beyond Assessment"
            ],
            contentLevels: [
                { name: "Entering", shortName: "EN", number: 1 },
                { name: "Progressing", shortName: "PR", number: 2 },
                { name: "Graduation Benchmark", shortName: "GB", number: 3 },
                { name: "Advancing", shortName: "AD", number: 4 },
                { name: "Excelling", shortName: "EX", number: 5 },
            ]
        },
        methods: {
            getDemosAtLevel function(skills){
                return skills.sort(function(a, b){ return a.demonstratedLevel - b.demonstratedLevel });
            },            
            standardLevelString: function(levelNum){
                
                if (levelNum <= 0 ){
                    return "NE";
                }
                if( levelNum < 1 && levelNum > 0){
                    return "IE";
                } else { 
                    return lut[Math.floor(levelNum)];
                }
            },
            shortDate: function(date){
                return (date.getMonth() + 1) + "/" + (date.getFullYear() % 100);
            },
            yearStem: function(date){
                return yearStem(date);
            },

            schoolYear: function(date){
                var stem = this.yearStem(date);
                return stem + "-" + (stem + 1);
            },

            checkForOverride: function(){

            }
        }
    });
}
