
function makeStudentReportVue(student, contentAreas){
    return new Vue({
        el: "#report-panel",
        data: {
            student: student,
            contentAreas: contentAreas
        },
        methods: {
        }
    });
}
