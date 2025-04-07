*** Settings ***
Library    SeleniumLibrary
Resource    ${CURDIR}/../resources/commons.robot
Resource    ${CURDIR}/../resources/variables.resource

Suite Setup    Spust prohlizec Chrome    open_url=${eshop_url}    assert_url=${eshop_assert_url}

*** Variables ***
# max. doba cekani na element
${implicit_wait_timeout}=    20s


*** Keywords ***


*** Test Cases ***
Registrovany uzivatel se hlasi nespravnym heslem
    [Documentation]    registrovany uzivatel, nespravne heslo
    Potvrd GDPR
    Wait Until Page Contains Element    xpath=//*[contains(text(), 'Signup / Login')]
    Click Element    xpath=//*[contains(text(), 'Signup / Login')]
    Element Should Be Visible    xpath=//*[contains(text(), 'Login to your account')]
    Input Text    
    ...    xpath=//*[@data-qa='login-email']    
    ...    text=index.face@mail.test
    Input Password    
    ...    xpath=//*[@data-qa='login-password']    
    ...    password=invalid.123
    Click Element    xpath=//*[@data-qa='login-button']
    Sleep    2s
    Element Should Be Visible    
    ...    xpath=//*[contains(text(), 'Your email or password is incorrect!')]   