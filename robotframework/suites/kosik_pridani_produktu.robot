*** Settings ***
Library    SeleniumLibrary
Resource    ${CURDIR}/../resources/commons.robot
Suite Setup    Spust prohlizec Chrome    open_url=http://automationexercise.com    assert_url=https://automationexercise.com/

*** Test Cases ***
Kosik Pridani 2x Produkt
    [Documentation]    pridani 2x produktu, kontrola stavu kosika: cena, kvantita, celkova cena
    Potvrd GDPR
    Wait Until Page Contains Element    xpath=//*[contains(text(), 'Products')]
    Click Element    xpath=//*[contains(text(), 'Products')]
    Sleep    2s
    # ------------------------------------------------
    Scroll Element Into View    css:.features_items:first-child
    
    # Wait Until Element Is Visible    css:.features_items    timeout=10s
    # # Hover over the first product
    # Mouse Over    css:.features_items:first-child .product-image-wrapper
    
    # # Click "Add to cart" button that appears on hover
    # Wait Until Element Is Visible    css:.features_items:first-child .product-overlay .add-to-cart
    # Click Element    css:.features_items:first-child .product-overlay .add-to-cart
    
    # # Verify product was added (modal appears)
    # Wait Until Element Is Visible    css:.modal-content    timeout=10s
    # Element Should Contain    css:.modal-title    Added!

    Sleep    240s