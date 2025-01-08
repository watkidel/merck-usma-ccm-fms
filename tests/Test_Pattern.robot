*** Settings ***
Resource    ../resources/resource.robot

*** Test Cases ***
Validate_Pattern
    [Documentation]    Login to Jar, navigate to report, verify correct report has loaded

    - Jar Login
    - Input Username     srvfmsdevuser   
    - Input Password      FmsGHA1@DevUser
    - Click Login
    ? Patterns Should Be Equal
    [Teardown]     Close Browser