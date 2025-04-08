*** Settings ***
Library    SeleniumLibrary
Resource    ${CURDIR}/../resources/commons.robot
Resource    ${CURDIR}/../resources/variables.resource

Suite Setup    Spust prohlizec Chrome    open_url=${eshop_url}    assert_url=${eshop_assert_url}

*** Variables ***


*** Keywords ***


*** Test Cases ***
Registrovany uzivatel se hlasi nespravnym heslem
    [Documentation]    registrovany uzivatel, nespravne heslo
    Potvrd GDPR Okno
    ${el_signup_login}=    Set Variable    xpath://*[contains(text(), 'Signup / Login')]
    Wait Until Page Contains Element    ${el_signup_login}    
    Click Element    ${el_signup_login}
    Element Should Be Visible    xpath://*[contains(text(), 'Login to your account')]
    Input Text    
    ...    xpath://*[@data-qa='login-email']    
    ...    text=index.face@mail2.test
    Input Password    
    ...    xpath://*[@data-qa='login-password']    
    ...    password=invalid.123
    Click Element    xpath://*[@data-qa='login-button']
    Sleep    2s
    Element Should Be Visible    
    ...    xpath://*[contains(text(), 'Your email or password is incorrect!')]   
    Close Browser
