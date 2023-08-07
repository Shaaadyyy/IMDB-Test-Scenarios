*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           String

*** Test Cases ***
1st
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Maximize Browser Window
    Input Text    id=suggestion-search    The Shawshank Redemption
    Click Button    id=suggestion-search-button
    ${movies}    Get WebElements    //*[@class="ipc-metadata-list-summary-item__t"]
    ${titles}    Create List
    FOR    ${movie}    IN    @{movies}
        ${movieTitle}    Set Variable    ${movie.text}
        Append To List    ${titles}    ${movieTitle}
        Log    ${movieTitle}
    END
    FOR    ${movie}    IN    @{titles}
        Should Contain Any    ${movie}    The Shawshank Redemption    the Shawshank Redemption
    END
    Should Be Equal As Strings    ${titles}[0]    The Shawshank Redemption
    [Teardown]    Close Browser

2nd
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Maximize Browser Window
    Click Element    //*[@id="imdbHeader-navDrawerOpen"]/span
    Sleep    1
    Click Element    //*[@id="imdbHeader"]/div[2]/aside/div/div[2]/div/div[1]/span/div/div/ul/a[2]/span
    wait until page contains Element    //*[@id="main"]/div/span/div/div/div[3]/table/thead/tr/th[2]
    ${movies}    Get WebElements    //*[@class="titleColumn"]
    ${titles}    Create List
    FOR    ${movie}    IN    @{movies}
        ${movieTitle}    Set Variable    ${movie.text}
        Append To List    ${titles}    ${movieTitle}
        Log    ${movieTitle}
    END
    ${len}    Get Length    ${titles}
    Should Be Equal As Numbers    ${len}    250
    Should contain    ${titles}[0]    The Shawshank Redemption
    [Teardown]    Close Browser

3rd
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Maximize Browser Window
    Click Element    //*[@id="nav-search-form"]/div[1]/div/label/span
    Sleep    1
    Click Element    //*[@id="navbar-search-category-select-contents"]/ul/a
    Wait Until Page Contains Element    //*[@id="header"]/h1
    Click Element    //*[@id="main"]/div[2]/div[1]/a
    Wait Until Page Contains Element    //*[@id="header"]/h1
    Select Checkbox    //*[@id="title_type-1"]
    Select Checkbox    //*[@id="genres-1"]
    Input Text    //*[@id="main"]/div[3]/div[2]/input[1]    2010
    Input Text    //*[@id="main"]/div[3]/div[2]/input[2]    2020
    Click Button    //*[@id="main"]/p[3]/button
    Sleep    1
    Wait Until Page Contains Element    //*[@id="main"]/div/h1
    Click Element    //*[@id="main"]/div/div[2]/a[3]
    Wait Until Page Contains Element    //*[@id="main"]/div/h1
    ${IMDb_Ratings}=    Get WebElements    //div[@class='lister-item-content']/div[@class='ratings-bar']/div[@class='inline-block ratings-imdb-rating']
    ${genres}    Get WebElements    xpath=//span[@class='genre']
    ${movies}    Get WebElements    xpath=//div[@class='lister-item-content']//h3/a
    ${moviesLength}    Get Length    ${movies}
    ${years}    Get WebElements    xpath=//div[@class='lister-item-content']//span[@class="lister-item-year text-muted unbold"]
    FOR    ${currentYear}    IN    @{years}
        ${yearText}=    Get Text    ${currentYear}
        ${year}=    Get Substring    ${yearText}    -5    -1
        Should Be Greater Than Or Equal To    ${year}    2010
        Should Be Smaller Than Or Equal To    ${year}    2020
    END
    FOR    ${currentGenre}    IN    @{genres}
        ${genre}=    Set Variable    ${currentGenre.text}
        Should Contain    ${genre}    Action
    END
    ${unsort_rate}    Create List
    ${IMDb_rate}    Create List
    FOR    ${currentRating}    IN    @{IMDb_Ratings}
        ${rating}=    Set Variable    ${currentRating.text}
        Append To List    ${unsort_rate}    ${rating}
    END
    FOR    ${currentRating}    IN    @{IMDb_Ratings}
        ${rating}=    Set Variable    ${currentRating.text}
        Append To List    ${IMDb_rate}    ${rating}
    END
    Sort List    ${IMDb_rate}
    Reverse List    ${IMDb_rate}
    Should Be Equal    ${IMDb_rate}    ${unsort_rate}

*** Keywords ***
Should Be Greater Than Or Equal To
    [Arguments]    ${number}    ${threshold}
    Should Be True    ${number} >= ${threshold}

Should Be Smaller Than Or Equal To
    [Arguments]    ${number}    ${threshold}
    Should Be True    ${number} <= ${threshold}
