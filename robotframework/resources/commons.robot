# resources/commons.robot
# knihovna spolecnych RobotFramework keywordu pro pouziti napric celym testovacim systemem

*** Settings ***
Library    SeleniumLibrary


*** Keywords ***
Spust prohlizec Chrome
    [Documentation]    spusti novou instanci Chrome 
    [Arguments]    ${open_url}    ${assert_url}
    Open Browser
    ...    browser=chrome
    ...    options=add_argument("--disable-popup-blocking");add_argument("--ignore-certificate-errors")
    ...    url=${open_url}
    Maximize Browser Window
    Location Should Be    ${assert_url}


Potvrd GDPR Okno
    [Documentation]    pokud se objevi consent okno, potvrdi ho
    ${btn_consent}=    Set Variable    //*[@aria-label='Consent']
    ${je_viditelne_gdpr_okno}=    Run Keyword And Return Status    Page Should Contain Element    xpath=${btn_consent}
    IF    ${je viditelne_gdpr_okno}
        Click Element    xpath=${btn_consent}
    ELSE
        Log    message=GDPR okno se nezobrazilo, pokracuji...
    END


Odstran AdSense Reklamy
    [Documentation]    Pokud jsou na strance iFrame Google AdSense reklamy, odstrani je
    ${adSense_na_strance}=    Execute Javascript    return document.getElementsByTagName('iframe').length
    IF    '${adSense_na_strance} != 0'
        Execute JavaScript  
        ...    const adFrames = document.querySelectorAll('iframe[id^="aswift_"]');
        ...    adFrames.forEach(frame => frame.remove()); 
    END
    