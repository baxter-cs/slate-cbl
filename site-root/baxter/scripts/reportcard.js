var lut = ["NE", "EN", "PR", "GB", "AD", "EX", "BA"];
function makeStudentReportVue(student, contentAreas){
    return new Vue({
        el: "#report-panel",
        data: {
            student: student,
            contentAreas: contentAreas
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
            }
        }
    });
}
