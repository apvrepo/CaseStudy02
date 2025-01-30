
# Case Study:

## Instructions

1. Create a Salesforce playground and create a custom LWC component page that lists all accounts from the org inside panels in a grid layout.
Initially show 4 panels per row, every panel should contain the account name in the header area and under the header it should have a section showing two account fields: the ticker symbol and annual revenue.
Under this section the panel should show 3 tabs, "Contact Relations (n)", "Contacts (n)" and "Opportunities (n)":
- The "Contact Relations" tab should list all related contact relations, every row should show only the contact name and the created date.
- The "Contacts" tab should list all related contacts, every row should show only the contact name and the created date.
- The "Opportunities" tab should list all related opportunities, every row should show only the opportunity name and the amount.
All records should be sorted by name and every tab should contain in the title the number of related records.
Every record name should be clickable and navigate to the record detail page after clicking on it.
The UI should adapt to smaller device sizes, like phones and tablets.

2. Create two fields on Account: Business_Users__c and Decision_Makers__c.
Use a trigger to update these two fields to always contain the number of related contacts with the role "Business User" and "Decision Maker" respectively.

3. Add the new fields "Business_Users__c" and "Decision_Makers__c" to the account overview panels, place them under the ticker symbol and annual revenue.
Add a clickable control element to every row in the "Contact Relations" tab, to enable the user to edit the assigned roles. The UI should reflect the changes done when the user updated the roles.

4. Optional: Implement a solution so that when the number of records increases in the future, the solution will still remain performant


## General guidelines
- Create a Salesforce Developer account or Trailhead Playground for this assignment and build it as a SFDX project
- Try to use standard LWC Salesforce components and the SLDS library when possible and follow best practices for the implementation
- Use system labels whenever possible
- Please commit to a public repository on GitHub and share the path with us, make sure to commit all the necessary items (lwc components, flexipage etc.)
- Use branches and commits following best practices
- Include a README page with the instructions necessary to deploy and run the project

## Results:

![Screenshot from 2025-01-30 11-06-12](https://github.com/user-attachments/assets/7b17e825-8f4a-4a51-9b66-90ae49f336e8) 

![Screenshot from 2025-01-30 11-06-34](https://github.com/user-attachments/assets/5007eec7-6bc3-418a-bce5-d27c690c5c28)

![Screenshot from 2025-01-30 11-06-48](https://github.com/user-attachments/assets/43b6cc9f-774e-4be9-84ed-f77e22214d9d)

![Screenshot from 2025-01-30 11-06-57](https://github.com/user-attachments/assets/982b3eb7-42a2-4b19-a254-130c5c38676a)

![Screenshot from 2025-01-30 11-07-19](https://github.com/user-attachments/assets/91307551-4201-49f8-9dff-ed14c5b29cce)

![Screenshot from 2025-01-30 11-07-28](https://github.com/user-attachments/assets/a881f1e6-1e2f-434e-854a-5ee94a9d8185)

![Screenshot from 2025-01-30 11-07-44](https://github.com/user-attachments/assets/e434f2bc-6308-4085-9f5e-434f525fa494)

![Screenshot from 2025-01-30 11-07-57](https://github.com/user-attachments/assets/e629011e-2785-472b-94a9-20214feb2acb)

![Screenshot from 2025-01-30 11-13-13](https://github.com/user-attachments/assets/62ff89e3-debd-45ba-9007-9e05a6fcb2be)

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## Project Overview

This project includes the following components:
- **Apex Classes**: Business logic and helper classes.
- **Apex Triggers**: Automation logic for Salesforce objects.
- **Lightning Web Components (LWC)**: Custom UI components.
- **Custom Labels**: Labels used in the UI components.
- **Custom Objects**: Custom objects and fields.

### Apex Classes
- **AccountHelper**: Contains methods to update account-related counts and roles.
- **AccountContactRelationTriggerHandler**: Trigger handler for `AccountContactRelation` object.
- **ContactTriggerHandler**: Trigger handler for `Contact` object.
- **OpportunityTriggerHandler**: Trigger handler for `Opportunity` object.
- **InitializeAccountSums**: Batch class to initialize account sums fields.
- **TestDataFactory**: Utility class to create test data for unit tests.
- **AccountHelperTest**: Unit test class for `AccountHelper`.

### Lightning Web Components (LWC)
- **lWCAccountCardTabSet**: Custom component to display account-related information.
- **lWCPage**: Custom component to display a list of account records.

### Custom Labels
- **AnnualRevenueLabel**
- **BusinessUsersLabel**
- **ContactRelationsLabel**
- **ContactsLabel**
- **CreatedDateLabel**
- **DecisionMakersLabel**
- **OpportunitiesLabel**
- **TickerSymbolLabel**

	### Custom Fields in the Account Object
- **OpportunitiesSum__c**
- **AccountContactRelationSum__c**
- **ContactsSum__c**
- **Decision_Makers__c**
- **Business_Users__c**

	### Custom Flexipage
- **Accounts_Panel**

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Deployment Guide

### Prerequisites

1. **Salesforce CLI**: Ensure you have the Salesforce CLI installed. You can download it from [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm).
2. **Salesforce DX Project**: Ensure you have a Salesforce DX project set up.
3. **Extensions: 'Salesforce Extension Pack' installed on Visual Studio Code**


### PRE-Deploy Steps:

1. **Enable Account-Contact Relationship in Salesforce**
To enable Account-Contact Relationship in Salesforce, follow these steps:
- Navigate to Setup, the Quick Find box, enter ‘Account Settings’.
- Locate the ‘Contacts to Multiple Accounts’ settings.
- Enable the feature by checking the ‘Allow users to relate a contact to multiple accounts’ option.
- Save changes
This feature, often referred to as ‘Contacts to Multiple Accounts’, allows a single contact to be associated with multiple accounts, further enhancing the flexibility of relationship management in Salesforce.

2. **Create a Visual Studio Project with the clone metadata from the Git repository**


### Deploy Steps:

1. **Authenticate and Connect to the target org**:

2. **Deploy Source to target Org**:
  - You can achieve this by right-click on the 'package.xml' file and select option 'SFDX: Deploy Source in Manifest to Org' or
  you can deploy individual components one by one by doing right-click on the desire component and selecting the option '
  SFDX: Deploy this Source to Org'

### POST-Deploy Steps:

1. **Manually Activate the Flexipage 'Accounts_Panel'**
- Go to 'Setup' --> 'User Interface' --> 'Lightning App Builder'
- Search for the Lightning Page with name 'Accounts_Panel' and click the option 'Edit' 
- Click on the button 'Activation...' (on the right top corner of the screen) 
- Click on the tab 'App Default' 
- Click on the button 'Assign to Apps' 
- Select the app woith App Name 'Sales' 
- Click 'Next'
- Click 'Save'
- Click 'Save' (button next to the previous 'Activation...')
- LogOut from the Org, refresh the browser tab (CTRL+F5) and LogIn back again.

2. **Initialize the sums in the custom fields of the Account records by executing anonymously the code of the Apex Class 'InitializeAccountSums.cls'**
- Open Developer Console
- Click 'Debug'  --> 'Open Execute Anonymous Window' 
- Copy and paste the following code: 

InitializeAccountSums batch = new InitializeAccountSums();
Database.executeBatch(batch, 200); // Adjust the batch size as needed 

- Click 'Execute' button



## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
