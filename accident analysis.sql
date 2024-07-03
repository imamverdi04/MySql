SELECT 
    TYPEOFACCIDENT,
    DATE_FORMAT(`DATE`, '%W') AS hafta_gunu,
    COUNT(*) AS kaza_sayisi
FROM 
    `accident analysis`.`insurancecompany`
GROUP BY 
    TYPEOFACCIDENT, 
    hafta_gunu
ORDER BY 
    TYPEOFACCIDENT, 
    FIELD(hafta_gunu, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
    
    
    
    select
    REGIONNAME,
    AVG(SPEED) AS Average_Speed
    FROM 
    `accident analysis`.`insurancecompany`
    GROUP BY
    REGIONNAME;
