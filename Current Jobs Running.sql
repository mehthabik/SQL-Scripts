--TO FIND THE JOB RUNNING NOW

SELECT 
    j.name AS 'Job Name',
    ja.start_execution_date AS 'Start Time',
    ja.last_executed_step_id AS 'Last Executed Step ID',
    ja.stop_execution_date AS 'Stop Time',
    jh.message AS 'Last Message'
FROM 
    msdb.dbo.sysjobs j
INNER JOIN 
    msdb.dbo.sysjobactivity ja ON j.job_id = ja.job_id
LEFT JOIN 
    msdb.dbo.sysjobhistory jh ON ja.job_history_id = jh.instance_id
WHERE 
    ja.stop_execution_date IS NULL
    AND CONVERT(DATE, ja.start_execution_date) = CONVERT(DATE, GETDATE());

