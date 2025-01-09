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
  you can deploy individual components one by one by doing right click on the desire component and selecting the option '
  SFDX: Deploy this Source to Org'

### POST-Deploy Steps:

1. **Initialize the sums in the custom fields of the Account records by executing anonymously the code of the Apex Class 'InitializeAccountSums.cls'**
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
