DECLARE @json1 NVARCHAR(MAX)
DECLARE @json2 NVARCHAR(MAX)

SET @json1='{"vacationID":0,"userID_FK":null,"requetDate":"0001-01-01T00:00:00","totalNoOfDays":10,"startingDate":"2018-04-01T00:00:00","endingDate":"2018-04-10T00:00:00","backFromVacationDate":"2018-04-11T00:00:00","actualBackFromVacationDate":null,"daysDifference":null,"hasTickets":null,"hasSMS":null,"code_vacationStateID_FK":1,"vacation_CrUid":null,"vacation_CrDt":null,"backVacation_CrUid":null,"backVacation_CrDt":null,"thisVacationDetail":[{"vacationDetailsID":0,"vacationID_FK":0,"vacTypeID_FK":2,"noOfDay":5,"startingDate":"2018-04-01T00:00:00","endingDate":"2018-04-05T00:00:00"},{"vacationDetailsID":0,"vacationID_FK":0,"vacTypeID_FK":1,"noOfDay":5,"startingDate":"2018-04-06T00:00:00","endingDate":"2018-04-10T00:00:00"}]}';

SELECT @json2=value FROM OPENJSON(@json1) 
WHERE type= 4

DECLARE @vacationRequestID INT 

INSERT INTO VacationRequests(userID_FK ,requestDate ,totalNoOfDays ,startingDate ,backFromVacationDate ,actualBackFromVacationDate ,daysDifference ,hasTickets ,hasSMS ,code_vacationStateID_FK ,vacation_CrUid ,vacation_CrDt ,backVacation_CrUid ,backVacation_CrDt ) 
SELECT * FROM OPENJSON(@json1)
with
(
    userID_FK decimal(10, 0),
    requestDate DATE,
    totalNoOfDays INT,
    startingDate DATE,
    backFromVacationDate DATE,
    actualBackFromVacationDate DATE,
    daysDifference INT,
    hasTickets BIT,
    hasSMS BIT,
    code_vacationStateID_FK INT,
    vacation_CrUid nvarchar(50),
    vacation_CrDt DATE,
    backVacation_CrUid nvarchar(50),
    backVacation_CrDt DATE
)
SELECT @vacationRequestID = @@IDENTITY 


INSERT INTO vacationDetails(vacTypeID_FK, noOfDay, startingDate, endingDate, vacationID_FK) 
SELECT * , @vacationRequestID as vacationID_FK FROM OPENJSON(@json2)
 with
(
	vacTypeID_FK INT,
	noOfDay INT,
	startingDate DATE,
	endingDate DATE
) 


SELECT * FROM VacationRequests
SELECT * FROM vacationDetails
