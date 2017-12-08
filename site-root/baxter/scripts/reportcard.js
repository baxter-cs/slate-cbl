var lut = ["NE", "EN", "PR", "GB", "AD", "EX", "BA"];
function makeStudentReportVue(student, contentAreas){
    return new Vue({
        el: "#report-panel",
        data: {
            student: student,
            contentAreas: contentAreas,
            headerLevels: [
              "Entering (EN)",  
              "Progressing (PR)",  
              "Grad. Benchmark (GB)",  
              "Advancing (AD)",  
              "Excelling (EX)",
              "Beyond Assessment"
            ],
        },
        methods: {
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
            }
        }
    });
}
