*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${implicit_wait_timeout}=    20s
${test_url}=    http://automationexercise.com

*** Keywords ***
Spust prohlizec Chrome
    Open Browser
    ...    browser=chrome
    ...    options=add_argument("--disable-popup-blocking");add_argument("--ignore-certificate-errors")
    ...    url=${test_url}
    Maximize Browser Window

Potvrd GDPR
    [Documentation]    pokud se objevi consent okno, potvrdi ho
    ${btn_consent}=    Set Variable    //*[@aria-label='Consent']
    ${je_viditelne_gdpr_okno}=    Run Keyword And Return Status    Page Should Contain Element    xpath=${btn_consent}
    IF    ${je viditelne_gdpr_okno}
        Click Element    xpath=${btn_consent}
    ELSE
        Log    message=GDPR okno se nezobrazilo, pokracuji...
    END
   


*** Test Cases ***
Registrovany uzivatel se hlasi nespravnym heslem
    [Documentation]    registrovany uzivatel, nespravne heslo
    Spust prohlizec Chrome
    Potvrd GDPR
    Wait Until Page Contains Element    xpath=//*[contains(text(), 'Signup / Login')]
    Click Element    xpath=//*[contains(text(), 'Signup / Login')]
    Input Text    xpath=//*[@data-qa='login-email']    text=index.face@mail.test
    Input Password    xpath=//*[@data-qa='login-password']    password=invalid.123
    Click Element    xpath=//*[@data-qa='login-button']
    Wait Until Page Contains Element    xpath=//*[contains(text(), 'Your email or password is incorrect!')]

    #Sleep    120   

# class="fc-choice-dialog fc-dialog"