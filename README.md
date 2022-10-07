# GitHub

## Story: Customer request to see the closed PR's: 
### Narrative #1:
    As an online customer 
    I want the app to automatically load the closed PR's of the public repository.
    
    #### Acceptance criteria:
    Given the customer has connectivity 
    When the customer requests to see the PR's
    then the app should load the PR's from given public repository.
    Replace the error screen with fetched list    
    

### Narrative #2:
    As an offline customer
    I want to see the Offline error screen
    
    #### Acceptance criteria:
    Given the customer doesn't have connectivity 
    When the customer requests to see the PR's
    then the app should display an error message. 
    

## Use cases:
### Load Pull Requests:

#### Data:
    - URL
    
#### Primary Course(Happy Path):
    - Execute `LoadPullRequestItems` command with above data
    - System download data from above URL
    - System validates downloaded data 
    - System create data models from valid data 
    - System delivers data models
    
#### Invalid data - Error Course (Sad Path):
    - System delivers error 
    
#### Network connectivity - Error Course (Sad Path): 


