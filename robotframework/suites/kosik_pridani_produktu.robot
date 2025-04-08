*** Settings ***
Library    SeleniumLibrary
Resource    ${CURDIR}/../resources/commons.robot
Resource    ${CURDIR}/../resources/variables.resource
Test Timeout    240s
Suite Setup    Spust prohlizec Chrome    open_url=http://automationexercise.com    assert_url=https://automationexercise.com/


*** Variables ***


*** Keywords ***
Vyber Produkt Z Nabidky
    [Arguments]    ${pocet_iteraci}
    Sleep    2s
    FOR    ${i}    IN RANGE    0    ${pocet_iteraci}
        ${position}=    Evaluate    ${i} + 1
        # xpath produktu z rodice 'features_items'
        ${el_product}=    Set Variable
        ...    (//*[contains(@class, 'features_items')]/descendant::*[contains(@class, 'col-sm-4')])[${position}]
        Mouse Over    xpath:${el_product}
        # btn 'Add to cart'
        ${add_to_cart_btn}=    Set Variable
        ...    ${el_product}/descendant::*[contains(@class, 'add-to-cart')]
        Wait Until Element Is Visible    xpath:${add_to_cart_btn}    timeout=${implicit_wait_timeout}
        # klikni btn 'Add to cart'
        Execute JavaScript    document.evaluate("${add_to_cart_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
        # cekej na okno 'added to cart'
        Wait Until Element Is Visible    css:.modal-content    timeout=${implicit_wait_timeout}
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
    Wait Until Page Contains Element    xpath://*[contains(text(), 'Products')]
    Click Element    xpath=//*[contains(text(), 'Products')]
    # najdi vsechny Google AdSense iframe reklamy a odstran je:
    Odstran AdSense Reklamy
    Vyber Produkt Z Nabidky    pocet_iteraci=2
    # redirect na stranku /view_cart
    Wait Until Page Contains Element     
    ...    xpath://*[@class='breadcrumb']/descendant::*[contains(text(), 'Shopping Cart')]   
    Page Should Contain Element    
    ...    xpath://*[@class='col-sm-6']/descendant::*[contains(text(), 'Proceed To Checkout')]
    # stranka ma obsahovat tabulku produktu
    Page Should Contain Element    css:#cart_info_table
    
    # pokud je jakakoliv validace tabulky fail, nastavi True
    ${test_failed}=    Set Variable    ${FALSE}

    # ------ Test Data ------
    ${popis_list}=    Create List    Blue Top    Men Tshirt
    ${cena_list}=    Create List     Rs. 500    Rs. 400
    ${mnoz_list}=    Create List     1    1
    ${celk_list}=    Create List     Rs. 500   Rs. 400
    ${data}=    Create Dictionary
    ...    popis    ${popis_list}
    ...    cena    ${cena_list}
    ...    mnoz    ${mnoz_list}
    ...    celk    ${celk_list}
    # ----------------------

    FOR    ${i}    IN RANGE    1    3
            ${row}=    Set Variable    //tbody/tr[@id='product-${i}']
            
            # zkontroluj, jestli existuje radek tabulky a vrat status
            ${row_exists}=    Run Keyword And Return Status    
            ...    Page Should Contain Element    xpath:${row}
            
            IF    not ${row_exists}
                Log    radek id: 'product-${i}' nenalezen    level=WARN
                Set Test Variable    ${test_failed}    ${TRUE}
                CONTINUE
            END
            
            # popis produktu:
            ${desc_valid}=    Run Keyword And Return Status    
            ...    Element Should Contain    
                ...    xpath:${row}/td[@class='cart_description']
                ...    expected=${data}[popis][${i - 1}]
            
            IF    not ${desc_valid}
                Log    Produkt ${i} - popis neodpovida    level=WARN
                Set Test Variable    ${test_failed}    ${TRUE}
            END
            
            # cena produktu
            ${price_valid}=    Run Keyword And Return Status    
            ...    Element Should Contain    
                ...    xpath:${row}/td[@class='cart_price']
                ...    expected=${data}[cena][${i - 1}]
            
            IF    not ${price_valid}
                Log    Produkt ${i} - cena nedopovida    level=WARN
                Set Test Variable    ${test_failed}    ${TRUE}
            END
            
            # mnozstvi produktu
            ${qty_valid}=    Run Keyword And Return Status    
            ...    Element Should Contain    
                ...    xpath:${row}/td[@class='cart_quantity']
                ...    expected=${data}[mnoz][${i - 1}]
            
            IF    not ${qty_valid}
                Log    Product ${i} - mnozstvi neodpovida    level=WARN
                Set Test Variable    ${test_failed}    ${TRUE}
            END
            
            # celkova cena produktu 
            ${total_valid}=    Run Keyword And Return Status    
            ...    Element Should Contain    
                ...    xpath:${row}/td[@class='cart_total']
                ...    expected=${data}[celk][${i - 1}]
            
            IF    not ${total_valid}
                Log    Product ${i} - mnozstvi celkem neodpovida    level=WARN
                Set Test Variable    ${test_failed}    ${TRUE}
            END
        END
        
        # test je Fail, pokud alespon jedna validace je Fail
        IF    ${test_failed}
            Fail    validace tabulky Produktu neni 100%!
    END
    Close Browser
