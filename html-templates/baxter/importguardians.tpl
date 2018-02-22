<!DOCTYPE html>
<html>
    <head>
        {cssmin "reports/legacy.css" embed=true}
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="https://unpkg.com/vue"></script>
        <style>
        </style>
    
    </head>
    <body>

    
    <div id="report-panel">
    </div>
</div>

    <script src="scripts/importguardians.js"></script>
    <script>
        var vue = makeStudentReportVue("#report-panel");
    </script>

  </body>
</html>
