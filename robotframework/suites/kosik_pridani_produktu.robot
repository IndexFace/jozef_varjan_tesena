*** Settings ***
Library    SeleniumLibrary
Resource    ${CURDIR}/../resources/commons.robot
Test Timeout    240s
Suite Setup    Spust prohlizec Chrome    open_url=http://automationexercise.com    assert_url=https://automationexercise.com/


*** Keywords ***
Vyber Produkt Z Nabidky
    [Arguments]    ${pocet_iteraci}
    FOR    ${i}    IN RANGE    0    ${pocet_iteraci}
        # Convert index to position (XPath uses 1-based indexing)
        ${position}=    Evaluate    ${i} + 1
        # xpath produktu z rodice 'features_items'
        ${el_product}=    Set Variable
        ...    (//*[contains(@class, 'features_items')]/descendant::*[contains(@class, 'col-sm-4')])[${position}]
        Mouse Over    xpath:${el_product}
        # btn 'Add to cart'
        ${add_to_cart_btn}=    Set Variable
        ...    ${el_product}/descendant::*[contains(@class, 'add-to-cart')]
        Wait Until Element Is Visible    xpath:${add_to_cart_btn}    timeout=5s
        # klikni btn 'Add to cart'
        Execute JavaScript    document.evaluate("${add_to_cart_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
        # cekej na okno 'added to cart'
        Wait Until Element Is Visible    css:.modal-content    timeout=5s
            IF    ${i} == 1
                Click Element    css:.modal-body u
            ELSE
                Click Element    css:.modal-footer .btn
                Sleep    1s
            END
    END


*** Test Cases ***
Kosik Pridani 2x Produkt
    [Documentation]    pridani 2x produktu, kontrola stavu kosika: cena, kvantita, celkova cena
    Potvrd GDPR Okno
    Wait Until Page Contains Element    xpath=//*[contains(text(), 'Products')]
    Click Element    xpath=//*[contains(text(), 'Products')]
    # najdi vsechny Google AdSense iframe reklamy a odstran je:
    Odstran AdSense Reklamy
    Vyber Produkt Z Nabidky    pocet_iteraci=2
    
    

    # Sleep    240s