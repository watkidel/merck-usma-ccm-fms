*** Settings ***
Library    SeleniumLibrary
Library    DatabaseLibrary
Library     XrayConvertor.KeywordStoreExtension
*** Variables ***
${baseUrl}    https://ccmjartest.merck.com:8085/jar_sit_1/servlet/report.home?pack=
${browser}    headlesschrome             
${PORT}    1521
${HOST}    mmaswd2.cxhylvebomne.us-east-1.rds.amazonaws.com
${SID}    mmaswd2
${USER}    CON_CCMDSHBRD
${PASSWORD}    Jan24cCMdshbrd#73
${element}    xpath=/html[1]/body[1]/table[1]/tbody[1]/tr[1]/td[1]/b[1]

*** Keywords ***
Query Table from Database
    Connect To Database
    ...    oracledb
    ...    db_name=${SID}
    ...    db_user=${USER}
    ...    db_password=${PASSWORD}
    ...    db_host=${HOST}
    ...    db_port=1521
    ${Query}    Catenate   Select Distinct dsply_group_name,url_pattern From Rpt_Patterns Where url_pattern IN 
    ...    ('gp/asp/rp_asp_v3.xml', 'gp/bp/Corporate_Affiliation_Report.xml','pay/payment_overall.xml',
    ...    'rebates/hif.xml','validata_reporting/ineligible_pharmacy_check.xml','chargebacks/340B_chargeback_exception_report.xml','phs/340bCustomerReimbursementReport.xml',
    ...    'pay/payment_details_pmtdtl_otherstatus.xml','pay/payment_details_pmtdtl_valid.xml','pay/payment_details_pmtdtl_mcd.xml')
    ${results}    Query        ${Query}  
   RETURN     ${results}
- Jar Login
    Keyword Store Extension     prefixes= -    name= Jar Login    self=self
    Open Browser    ${baseUrl}    ${browser}
    Maximize Browser Window
    Set Selenium Speed    3
nav_To_Url
    Keyword Store Extension     prefixes= -    name= nav_To_Url   self=self
    [Arguments]    ${urlpttn}
    ${Url}    Catenate    SEPARATOR=    ${baseUrl}    ${urlpttn}
    Go To    ${Url}
- Input Username
    Keyword Store Extension     prefixes= -    name= Input Username    self=self
    [Arguments]    ${Username}
    Input Text     userid   ${Username}
- Input Password
    Keyword Store Extension     prefixes= -    name= Input Password    self=self
    [Arguments]    ${password}
    Input Text     pw    ${password}
- Click Login  
    Keyword Store Extension     prefixes= -    name= Click    self=self
    Click Button    loginButton
- Find Pattern On Screen
    Keyword Store Extension     prefixes= -    name= Find Pattern On Screen    self=self
    Select Frame     id:reportFrame
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${ELEMENT}
    ${result}=    Run Keyword If    ${status}    Get Text    ${element}    ELSE    Set Variable    None
    RETURN    ${result}

? Patterns Should Be Equal
    Keyword Store Extension     prefixes= -    name= Pattern Should Be Equal    self=self
    ${dataList}    Query Table from Database
    FOR    ${num}     IN RANGE    5
        nav_To_Url    ${dataList}[${num}][1]
        ${element}   - Find Pattern On Screen
        Should Be Equal    ${element}     ${dataList}[${num}][0]
        Capture Page Screenshot    Embed   
    END