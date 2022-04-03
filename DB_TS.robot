*** Settings ***
Library           DatabaseLibrary
Library           OperatingSystem
Library           BuiltIn
Library           SeleniumLibrary
Suite Setup       Connect To Database    pymysql    ${DBName}    ${DBUser}    ${DBPwd}    ${DBHost}    ${DBPort}
Suite Teardown    Disconnect From Database

*** Variables ***
${DBName}         mydb
${DBUser}         root
${DBPwd}          root
${DBHost}         127.0.0.1
${DBPort}         3306

*** Keywords ***
Drop person table
    ${output}=    Execute Sql String    DROP TABLE person
    Log To Console    ${output}
    Should Be Equal As Strings    ${output}    None

Check presence of person table
    Table Must Exist    person

*** Test Cases ***
Continue if person table absent
    ${status}=    Run Keyword And Ignore Error    Check presence of person table
    Log To Console    ${status}
    Run Keyword If    ${status}=='PASS', None    Drop person table

Create person table
    ${output}=    Execute Sql String    Create table person(id integer,first_name varchar(20),last_name varchar(20));
    Log To Console    ${output}
    Should Be Equal As Strings    ${output}    None

Inserting Data in person table
    ${output}=    Execute Sql String    Insert into person values(111,"Ollie","Tabouger");
    Log To Console    ${output}
    Should Be Equal As Strings    ${output}    None

Delete person in person table
    ${output}=    Execute Sql String    Delete from mydb.person
    Log To Console    ${output}
    Should Be Equal As Strings    ${output}    None

Populating person table
    ${output}=    Execute Sql Script    ./testdata/mydb_person_insertData.sql
    Log To Console    ${output}
    Should Be Equal As Strings    ${output}    None

Check if Julia record is present in Person table
    Check If Exists In Database    select id from mydb.person where first_name="Julia";

Check if Balgo record not present in Person table
    Check If not Exists In Database    select id from mydb.person where first_name="Balgo";

Verify row count is Zero
    Row Count Is 0    SELECT * FROM mydb.person WHERE first_name = 'x0x';

Verify row count is equal to specific value
    Row Count Is equal to x    SELECT * FROM mydb.person WHERE first_name = 'Tarek';    1

Verify row count is greater to specific value
    Row Count Is greater than x    SELECT * FROM mydb.person WHERE first_name = 'Tarek';    0

Verify row count is less to specific value
    Row Count Is less than x    SELECT * FROM mydb.person WHERE first_name = 'Tarek';    2

Update record in person table
    ${output}=    Execute Sql String    Update mydb.person set first_name ="Salma" where id=111;
    Log To Console    ${output}
    Should Be Equal As Strings    ${output}    None

Retrieve Records from Person Table
    @{queryResults}=    Query    Select * from mydb.person;
    log to console    ${queryResults}
